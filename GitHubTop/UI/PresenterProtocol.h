//
//  MainPresenterProtocol.h
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/7/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#ifndef MainPresenterProtocol_h
#define MainPresenterProtocol_h

@class GitHubRepo;
@protocol ControllerProtocol, GitHubObjectProtocol;

@protocol PresenterProtocol

- (instancetype)initWithController:(id <ControllerProtocol>)controller;
- (void)restoreState;
- (void)reload;
- (void)loadMore;
@property (nonatomic, readonly) NSArray *data;
@property (nonatomic, strong) id <GitHubObjectProtocol> object;

@end

#endif /* MainPresenterProtocol_h */
