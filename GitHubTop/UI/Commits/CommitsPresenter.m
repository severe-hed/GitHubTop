//
//  CommitsPresenter.m
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/8/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#import "CommitsPresenter.h"
#import "GitHubApiManager.h"
#import "ControllerProtocol.h"

NSString *const CommitsPresenterPageKey = @"CommitsPresenterPageKey";
const NSUInteger CommitsPresenterCommitLimit = 10;

@interface CommitsPresenter ()

@property (nonatomic, strong) NSArray <GitHubCommit *> *data;

@property (nonatomic, weak) id <ControllerProtocol> controller;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSUInteger page;

@end

@implementation CommitsPresenter

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
    
    self.page = [NSUserDefaults.standardUserDefaults integerForKey:CommitsPresenterPageKey];
    
    if (self.page == 0) {
        self.page = 1;
    }
    
    [GitHubApiManager.shared fetchCommitsForRepo:(GitHubRepo *)self.object
                                           limit:CommitsPresenterCommitLimit
                                            page:self.page reloadCache:false
                                      completion:^(NSArray<GitHubCommit *> * commits, NSError * error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error != nil) {
                [self.controller showError:error];
            }
            else {
                self.data = commits;
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
    
    [GitHubApiManager.shared fetchCommitsForRepo:(GitHubRepo *)self.object
                                           limit:CommitsPresenterCommitLimit
                                            page:self.page
                                     reloadCache:true
                                      completion:^(NSArray<GitHubCommit *> * commits, NSError * error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error != nil) {
                [self.controller showError:error];
            }
            else {
                self.data = commits;
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
    
    [GitHubApiManager.shared fetchCommitsForRepo:(GitHubRepo *)self.object
                                           limit:CommitsPresenterCommitLimit
                                            page:self.page + 1
                                     reloadCache:false
                                      completion:^(NSArray<GitHubCommit *> * commits, NSError * error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self.controller showError:error];
            }
            else {
                self.page += 1;
                self.data = [self.data arrayByAddingObjectsFromArray:commits];
                [self.controller appendData];
            }
        });
        self.isLoading = false;
    }];
}

@synthesize object;

@end
