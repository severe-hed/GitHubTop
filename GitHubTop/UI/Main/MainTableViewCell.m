//
//  MainTableViewCell.m
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/7/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#import "MainTableViewCell.h"
#import "GitHubRepo.h"
#import "GitHubUser.h"

@interface MainTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation MainTableViewCell

- (void)configure:(GitHubRepo *)repo {
    self.titleLabel.text = repo.name;
    self.descriptionLabel.text = repo.details;
}

@end
