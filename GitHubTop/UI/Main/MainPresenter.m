//
//  MainPresenter.m
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/7/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#import "MainPresenter.h"
#import "GitHubApiManager.h"
#import "ControllerProtocol.h"

NSString *const MainPresenterPageKey = @"MainPresenterPageKey";
const NSUInteger MainPresenterRepoLimit = 20;

@interface MainPresenter ()

@property (nonatomic, strong) NSArray <GitHubRepo *> *data;

@property (nonatomic, weak) id <ControllerProtocol> controller;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSUInteger page;

@end

@implementation MainPresenter

- (instancetype)initWithController:(id<ControllerProtocol>)controller {
    self = [super init];
    if (self) {
        self.controller = controller;
    }
    return self;
}

- (void)restoreState {
    if (self.isLoading) { return; }
    self.isLoading = true;
    
    self.page = [NSUserDefaults.standardUserDefaults integerForKey:MainPresenterPageKey];
    if (self.page == 0) {
        self.page = 1;
    }
    [GitHubApiManager.shared fetchTopSwiftWithLimit:MainPresenterRepoLimit
                                               page:self.page
                                        reloadCache:false
                                         completion:^(NSArray<GitHubRepo *> * repos, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (error != nil) {
                 [self.controller showError:error];
             }
             else {
                 self.data = repos;
                 [self.controller reloadData];
             }
         });
         self.isLoading = false;
     }];
    
}

- (void)reload {
    if (self.isLoading) {
        return;
    }
    self.isLoading = true;
    
    self.page = 1;
    
    [GitHubApiManager.shared fetchTopSwiftWithLimit:MainPresenterRepoLimit
                                               page:self.page
                                        reloadCache:true
                                         completion:^(NSArray<GitHubRepo *> * repos, NSError * error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error != nil) {
                [self.controller showError:error];
            }
            else {
                self.data = repos;
                [self.controller reloadData];
            }
        });
        self.isLoading = false;
    }];
    
}

- (void)loadMore {
    if (self.isLoading) {
        return;
    }
    self.isLoading = true;
    
    [GitHubApiManager.shared fetchTopSwiftWithLimit:MainPresenterRepoLimit
                                               page:self.page + 1
                                        reloadCache:false
                                         completion:^(NSArray<GitHubRepo *> * repos, NSError * error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self.controller showError:error];
            }
            else {
                self.page += 1;
                self.data = [self.data arrayByAddingObjectsFromArray:repos];
                [self.controller appendData];
            }
        });
        self.isLoading = false;
    }];
}

@synthesize object;

@end
