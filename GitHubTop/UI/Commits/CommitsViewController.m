//
//  CommitsViewController.m
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/8/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#import "CommitsViewController.h"
#import "PresenterProtocol.h"
#import "CommitTableViewCell.h"
#import "GitHubObjectProtocol.h"

@interface CommitsViewController ()

@end

@implementation CommitsViewController

+ (Class)cellClass {
    return [CommitTableViewCell class];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.presenter.object.name;
    
    [self.presenter restoreState];
}

@end
