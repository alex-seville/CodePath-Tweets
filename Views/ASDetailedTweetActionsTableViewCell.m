//
//  ASDetailedTweetActionsTableViewCell.m
//  ASTweet
//
//  Created by Alexander Seville on 3/29/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASDetailedTweetActionsTableViewCell.h"

@interface ASDetailedTweetActionsTableViewCell()

- (IBAction)replyButtonClick:(id)sender;

- (IBAction)retweetButtonClick:(id)sender;

- (IBAction)favoriteButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@end

@implementation ASDetailedTweetActionsTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(ASTweet *)tweet {
    
    _tweet = tweet;
    if (tweet.isFavorited){
        self.favoriteButton.backgroundColor = [UIColor yellowColor];
    }else{
        self.favoriteButton.backgroundColor = [UIColor whiteColor];
    }
    
    if (tweet.isRetweeted){
        self.retweetButton.backgroundColor = [UIColor greenColor];
    }else{
        self.favoriteButton.backgroundColor = [UIColor whiteColor];
    }
    
}



- (IBAction)replyButtonClick:(id)sender {
    //delegate this event to the view controller
    [_delegate didClickReply:_tweet];
}

- (IBAction)retweetButtonClick:(id)sender {
    //delegate this event to the view controller
    [_delegate didClickRetweet:_tweet];
}

- (IBAction)favoriteButtonClick:(id)sender {
    //delegate this event to the view controller
    [_delegate didClickFavorite:_tweet];
}
@end
