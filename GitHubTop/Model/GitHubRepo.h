//
//  GitHubRepo.h
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/7/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubObjectProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class GitHubUser;

@interface GitHubRepo : NSObject <GitHubObjectProtocol>

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) GitHubUser *user;
@property (nonatomic, strong, readonly) NSString *details;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
