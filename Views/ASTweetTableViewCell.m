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
- (IBAction)replyTweetClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *replyTweetLabel;
- (IBAction)retweetButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
- (IBAction)favoriteButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *favoriteButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;

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
    
    self.realNameLabel.text = _tweet.user.realName;
    self.twitterHandleLabel.text = [ASUser getFormattedScreenName:_tweet.user.screenName];
    self.tweetTextLabel.text = _tweet.text;
    self.tweetCreatedSinceLabel.text = [ASTweet getTimeSince:_tweet.createdAt];
        
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:_tweet.user.profileImageURL]];
    
    
    if (_tweet.isFavorited){
        self.favoriteButtonLabel.backgroundColor = [UIColor yellowColor];
    }
    if (_tweet.isRetweeted){
        self.retweetButton.backgroundColor = [UIColor greenColor];
    }
    
    
    if (_tweet.retweetCount > 0){
        self.retweetLabel.text = [@(_tweet.retweetCount) stringValue];
        self.retweetLabel.hidden = false;
    }else{
        self.retweetLabel.hidden = true;
    }
    if (_tweet.favoriteCount > 0){
        self.favoriteLabel.text = [@(_tweet.favoriteCount) stringValue];
        self.favoriteLabel.hidden = false;
    }else{
        self.favoriteLabel.hidden = true;
    }
    if (_tweet.replyCount > 0){
        self.replyTweetLabel.text = [@(_tweet.replyCount) stringValue];
        self.replyTweetLabel.hidden = false;
    }else{
        self.replyTweetLabel.hidden = true;
    }
}

- (IBAction)replyTweetClick:(id)sender {
    [_delegate didClickReply:_tweet];
}
- (IBAction)retweetButtonClick:(id)sender {
    [_delegate didClickRetweet:_tweet];
}
- (IBAction)favoriteButtonClick:(id)sender {
    [_delegate didClickFavorite:_tweet];
}
@end
