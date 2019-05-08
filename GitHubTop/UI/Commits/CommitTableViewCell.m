//
//  CommitTableViewCell.m
//  GitHubTop
//
//  Created by Sergey Khliustin on 5/8/19.
//  Copyright © 2019 severehed. All rights reserved.
//

#import "CommitTableViewCell.h"
#import "GitHubCommit.h"
#import "GitHubUser.h"
#import "UIImageView+Additions.h"

@interface CommitTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation CommitTableViewCell

- (void)configure:(GitHubCommit *)data {
    self.titleLabel.text = data.sha;
    self.detailsLabel.text = data.name;
    self.authorLabel.text = data.author.name;
    [self.avatarImageView loadFromURL:data.author.avatar_url];
}

@end
