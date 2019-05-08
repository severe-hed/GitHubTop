//
//  GitHubUser.m
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/7/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#import "GitHubUser.h"

NSString *const UserNameKey = @"login";
NSString *const UserAvatarKey = @"avatar_url";
NSString *const UserAlternateNameKey = @"name";

@interface GitHubUser ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *avatar_url;

@end

@implementation GitHubUser

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        NSString *name = dict[UserNameKey];
        if ([name isKindOfClass:[NSString class]]) {
            self.name = name;
        }
        else {
            self.name = dict[UserAlternateNameKey];
        }
        
        NSString *avatarString = dict[UserAvatarKey];
        self.avatar_url = [avatarString isKindOfClass:[NSString class]] ? [NSURL URLWithString:avatarString] : nil;
    }
    return self;
}

@end
