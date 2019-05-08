//
//  MainControllerProtocol.h
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/7/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#ifndef MainControllerProtocol_h
#define MainControllerProtocol_h

@protocol ControllerProtocol

- (void)reloadData;
- (void)appendData;
- (void)showError:(NSError *)error;

@end

#endif /* MainControllerProtocol_h */
