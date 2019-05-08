//
//  GitHubApiManager.h
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/7/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GitHubRepo,GitHubCommit;

@interface GitHubApiManager : NSObject

+ (instancetype)shared;

- (void)fetchTopSwiftWithLimit:(NSUInteger)limit
                          page:(NSUInteger)page
                   reloadCache:(BOOL)reloadCache
                    completion:(void(^)(NSArray <GitHubRepo *> *, NSError *))completion;

- (void)fetchCommitsForRepo:(GitHubRepo *)repo
                      limit:(NSUInteger)limit
                       page:(NSUInteger)page
                reloadCache:(BOOL)reloadCache
                 completion:(void(^)(NSArray <GitHubCommit *>*, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
