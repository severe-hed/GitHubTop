//
//  BaseViewController.m
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/8/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#import "BaseViewController.h"
#import "CellProtocol.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

+ (Class)cellClass {
    NSAssert(false, @"Should be overrided");
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
//    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    NSString *cellClassName = NSStringFromClass([self.class cellClass]);
    [self.tableView registerNib:[UINib nibWithNibName:cellClassName bundle:nil] forCellReuseIdentifier:cellClassName];
    [self.tableView addSubview:self.refreshControl];
    
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
}

- (void)refreshAction {
    [self.presenter reload];
}

#pragma mark - ControllerProtocol

- (void)showError:(NSError *)error {
    [self.refreshControl endRefreshing];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:true completion:^{}];
}

- (void)reloadData {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)appendData {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableView.contentSize.height > 0 &&
        self.tableView.contentOffset.y > 0 &&
        self.tableView.contentOffset.y + self.tableView.safeAreaInsets.top + self.tableView.safeAreaInsets.bottom >=
        (self.tableView.contentSize.height - self.tableView.bounds.size.height))
    {
        [self.presenter loadMore];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.presenter.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell <CellProtocol> *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self.class cellClass]) forIndexPath:indexPath];
    [cell configure:self.presenter.data[indexPath.row]];
    return cell;
}

@end
