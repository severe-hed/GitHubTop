//
//  BaseViewController.h
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/8/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControllerProtocol.h"
#import "PresenterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController <ControllerProtocol, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) id <PresenterProtocol> presenter;

+ (Class)cellClass;

@end

NS_ASSUME_NONNULL_END
