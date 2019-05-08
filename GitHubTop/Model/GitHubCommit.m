//
//  GitHubCommit.m
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/8/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#import "GitHubCommit.h"
#import "GitHubUser.h"

NSString *const CommitShaKey = @"sha";
NSString *const CommitNameKey = @"commit.message";
NSString *const CommitAuthorKey = @"author";
NSString *const CommitAlternateAuthorKey = @"commit.author";

@interface GitHubCommit ()

@property (nonatomic, strong) NSString *sha;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) GitHubUser *author;
@property (nonatomic, strong) NSString *branch;

@end

@implementation GitHubCommit

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.sha = dict[CommitShaKey];
        self.name = [dict valueForKeyPath:CommitNameKey];
        NSDictionary *author = dict[CommitAuthorKey];
        if ([author isKindOfClass:[NSDictionary class]]) {
            self.author = [[GitHubUser alloc] initWithDictionary:dict[CommitAuthorKey]];
        }
        else {
            self.author = [[GitHubUser alloc] initWithDictionary:[dict valueForKeyPath:CommitAlternateAuthorKey]];
        }
    }
    return self;
}

@end
