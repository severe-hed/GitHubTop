//
//  MainViewController.m
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/7/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#import "MainViewController.h"
#import "PresenterProtocol.h"
#import "MainPresenter.h"
#import "MainTableViewCell.h"

#import "CommitsViewController.h"
#import "CommitsPresenter.h"
#import "GitHubRepo.h"

@interface MainViewController ()

@end

@implementation MainViewController

+ (Class)cellClass {
    return [MainTableViewCell class];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[MainPresenter alloc] initWithController:self];
    [self.presenter restoreState];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    GitHubRepo *repo = self.presenter.data[indexPath.row];
    CommitsViewController *controller = [[CommitsViewController alloc] initWithNibName:@"CommitsViewController" bundle:nil];
    controller.presenter = [[CommitsPresenter alloc] initWithController:controller];
    controller.presenter.object = repo;
    [self.navigationController pushViewController:controller animated:true];
}

@end
