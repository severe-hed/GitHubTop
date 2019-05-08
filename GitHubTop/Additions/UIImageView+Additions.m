//
//  UIImageView+Additions.m
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/8/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#import "UIImageView+Additions.h"

@implementation UIImageView (Additions)

- (void)loadFromURL:(NSURL *)url {
    self.hidden = false;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:indicator];
    indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [indicator startAnimating];
    self.image = nil;
    
    __weak typeof(self) wSelf = self;
    
    void(^completion)(UIImage *) = ^(UIImage *image){
        dispatch_async(dispatch_get_main_queue(), ^{
            wSelf.image = image;
            [indicator stopAnimating];
            wSelf.hidden = image == nil;
        });
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLCache *cache = NSURLCache.sharedURLCache;
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSCachedURLResponse *response = [cache cachedResponseForRequest:request];
        if (response != nil) {
            completion([UIImage imageWithData:response.data]);
        }
        else {
            [[NSURLSession.sharedSession dataTaskWithRequest:request
                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
            {
                UIImage *resultImage = nil;
                if (data != nil && response != nil && error == nil) {
                    NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
                    [cache storeCachedResponse:cachedResponse forRequest:request];
                    resultImage = [UIImage imageWithData:data];
                }
                completion(resultImage);
            }] resume];
        }
    });
    
}

@end
