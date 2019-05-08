//
//  GitHubObjectProtocol.h
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/8/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#ifndef GitHubObjectProtocol_h
#define GitHubObjectProtocol_h

@protocol GitHubObjectProtocol

@property (nonatomic, strong, readonly) NSString *name;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

#endif /* GitHubObjectProtocol_h */
