//
//  GitHubApiManager.m
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/7/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#import "GitHubApiManager.h"
#import "GitHubRepo.h"
#import "GitHubCommit.h"

NSString *const GitHubApiURL = @"https://api.github.com";
NSString *const GitHubReposEndpoint = @"repos";
NSString *const GitHubCommitsEndpoint = @"commits";
NSString *const GitHubSearchSwiftEndpoint = @"search/repositories?q=language:swift&sort=stars&order=desc";

@interface GitHubApiManager ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation GitHubApiManager

+ (instancetype)shared {
    static GitHubApiManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

- (void)fetchTopSwiftWithLimit:(NSUInteger)limit
                          page:(NSUInteger)page
                   reloadCache:(BOOL)reloadCache
                    completion:(void(^)(NSArray <GitHubRepo *> *, NSError *))completion {
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:1024 * 1024 * 100 diskCapacity:1024 * 1024 * 500 diskPath:@"topswift"];
    
    if (reloadCache) {
        [cache removeAllCachedResponses];
    }
    
    NSString *urlString = [GitHubApiURL stringByAppendingPathComponent:GitHubSearchSwiftEndpoint];
    urlString = [urlString stringByAppendingFormat:@"&per_page=%lu&page=%lu", (unsigned long)limit, (unsigned long)page];
    NSURL *url = [NSURL URLWithString:urlString];
    
    [self fetchDataWithURL:url
                     cache:cache
             dataProcessor:^NSArray *(NSData *data, NSError **error) {
                 
                 NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
                 if (*error != nil) {
                     
                     return nil;
                 }
                 
                 NSArray *items = jsonObject[@"items"];
                 NSMutableArray *repos = [NSMutableArray new];
                 
                 for (NSDictionary *item in items) {
                     GitHubRepo *repo = [[GitHubRepo alloc] initWithDictionary:item];
                     if (repo != nil) {
                         [repos addObject:repo];
                     }
                 }
                 return repos;

             }
                completion:completion];
}

- (void)fetchCommitsForRepo:(GitHubRepo *)repo
                      limit:(NSUInteger)limit
                       page:(NSUInteger)page
                reloadCache:(BOOL)reloadCache
                 completion:(void(^)(NSArray <GitHubCommit *> *, NSError *))completion {
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:1024 * 1024 * 50 diskCapacity:1024 * 1024 * 50 diskPath:repo.name];
    if (reloadCache) {
        [cache removeAllCachedResponses];
    }
    
    NSString *urlString = [GitHubApiURL stringByAppendingPathComponent:GitHubReposEndpoint];
    urlString = [urlString stringByAppendingPathComponent:repo.name];
    urlString = [urlString stringByAppendingPathComponent:GitHubCommitsEndpoint];
    urlString = [urlString stringByAppendingFormat:@"?per_page=%lu&page=%lu", limit, page];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    [self fetchDataWithURL:url
                     cache:cache
             dataProcessor:^NSArray *(NSData *data, NSError **error) {
                 NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
                 if (*error != nil) {
                     return nil;
                 }
                 @try {
                     NSMutableArray *commits = [NSMutableArray new];
                     
                     for (NSDictionary *item in jsonObjects) {
                         GitHubCommit *commit = [[GitHubCommit alloc] initWithDictionary:item];
                         
                         if (completion != nil) {
                             [commits addObject:commit];
                         }
                     }
                     return commits;
                 } @catch (NSException *exception) {
                     NSDictionary *jsonError = (NSDictionary *)jsonObjects;
                     if ([jsonError isKindOfClass:[NSDictionary class]] && [jsonError objectForKey:@"message"] != nil) {
                         *error = [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey: [jsonError objectForKey:@"message"]}];
                     }
                     else {
                         *error = [NSError errorWithDomain:@"" code:0 userInfo:@{ NSLocalizedDescriptionKey: exception.reason }];
                     }
                     return nil;
                 }
             }
                completion:completion];
}

- (void)fetchDataWithURL:(NSURL *)url
                   cache:(NSURLCache *)cache
           dataProcessor:(NSArray *(^)(NSData *, NSError **))dataProcessor
              completion:(void(^)(NSArray *, NSError *))completion {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSCachedURLResponse *response = [cache cachedResponseForRequest:request];
    if (response != nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error = nil;
            NSArray *result = dataProcessor(response.data, &error);
            completion(result, error);
        });
    }
    else {
        [[self.session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                completion(nil, error);
            }
            else if (data != nil && response != nil) {
                NSError *error = nil;
                NSArray *result = dataProcessor(data, &error);
                completion(result, error);
                if (error == nil) {
                    NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
                    [cache storeCachedResponse:cachedResponse forRequest:request];
                }
            }
            else {
                completion(nil, [NSError errorWithDomain:@"" code:0 userInfo:@{ NSLocalizedDescriptionKey: @"Unknown error" }]);
            }
        }] resume];
    }
}

@end
