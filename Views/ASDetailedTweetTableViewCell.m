//
//  ASDetailedTweetTableViewCell.m
//  ASTweet
//
//  Created by Alexander Seville on 3/29/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASDetailedTweetTableViewCell.h"
#import "ASTweet.h"
#import "UIImageView+AFNetworking.h"

@interface ASDetailedTweetTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorRealNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorTwitterHandleLabel;

@property (weak, nonatomic) IBOutlet UILabel *tweetDateCreatedLabel;

@end


@implementation ASDetailedTweetTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.authorProfileImageView.layer.masksToBounds = YES;
    self.authorProfileImageView.layer.cornerRadius = 5.0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Public methods


- (void)setTweet:(ASTweet *)tweet {
    
    _tweet = tweet;
    
    self.tweetTextLabel.text = tweet.text;
    self.authorRealNameLabel.text = tweet.user.realName;
    self.authorTwitterHandleLabel.text = [ASUser getFormattedScreenName:tweet.user.screenName];
    [self.authorProfileImageView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageURL]];
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:tweet.createdAt
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    self.tweetDateCreatedLabel.text = dateString;
    
}

@end
