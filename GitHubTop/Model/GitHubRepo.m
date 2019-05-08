//
//  GitHubRepo.m
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/7/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#import "GitHubRepo.h"
#import "GitHubUser.h"

NSString *const RepoNameKey = @"name";
NSString *const RepoOwnerKey = @"owner";
NSString *const RepoDescriptionKey = @"description";
NSString *const RepoFullNameKey = @"full_name";

@interface GitHubRepo ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) GitHubUser *user;
@property (nonatomic, strong) NSString *details;

@end

@implementation GitHubRepo

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        
        self.name = dict[RepoFullNameKey];
        self.title = dict[RepoNameKey];
        
        self.user = [[GitHubUser alloc] initWithDictionary:dict[RepoOwnerKey]];
        
        NSString *details = dict[RepoDescriptionKey];
        self.details = [details isKindOfClass:[NSString class]] ? details : @"";
    }
    return self;
}

@end
