//
//  ASTweetTableViewCell.m
//  ASTweet
//
//  Created by Alexander Seville on 3/28/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASTweetTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface ASTweetTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetCreatedSinceLabel;



@end

@implementation ASTweetTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.userProfileImage.layer.masksToBounds = YES;
    self.userProfileImage.layer.cornerRadius = 5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Public methods


- (void)setTweet:(ASTweet *)tweet {
    
    _tweet = tweet;
    
    self.realNameLabel.text = tweet.user.realName;
    self.twitterHandleLabel.text = [ASUser getFormattedScreenName:tweet.user.screenName];
    self.tweetTextLabel.text = tweet.text;
    self.tweetCreatedSinceLabel.text = [ASTweet getTimeSince:tweet.createdAt];
        
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:tweet.user.profileImageURL]];
}

@end
