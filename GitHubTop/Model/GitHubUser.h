//
//  GitHubUser.h
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/7/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubObjectProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface GitHubUser : NSObject <GitHubObjectProtocol>

@property (nonatomic, strong, readonly) NSURL *avatar_url;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
