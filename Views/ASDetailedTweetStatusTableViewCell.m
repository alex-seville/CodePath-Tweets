//
//  ASDetailedTweetStatusTableViewCell.m
//  ASTweet
//
//  Created by Alexander Seville on 3/29/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASDetailedTweetStatusTableViewCell.h"

@interface ASDetailedTweetStatusTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;


@end


@implementation ASDetailedTweetStatusTableViewCell

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
    if (tweet.retweetCount == 0){
        self.retweetCountLabel.hidden = true;
        self.retweetLabel.hidden = true;
    }else{
        self.retweetCountLabel.text = [@(tweet.retweetCount) stringValue];
    }
    
    if (tweet.favoriteCount == 0){
        self.favoriteCountLabel.hidden = true;
        self.favoriteLabel.hidden = true;
    }else{
        self.favoriteCountLabel.text = [@(tweet.favoriteCount) stringValue];
    }
    
    
    
}

@end
