//
//  GitHubCommit.h
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/8/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubObjectProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class GitHubUser;

@interface GitHubCommit : NSObject <GitHubObjectProtocol>

@property (nonatomic, strong, readonly) NSString *sha;
@property (nonatomic, strong, readonly) GitHubUser *author;
@property (nonatomic, strong, readonly) NSString *branch;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
