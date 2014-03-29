//
//  ASDetailedTweetTableViewCell.m
//  ASTweet
//
//  Created by Alexander Seville on 3/29/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASDetailedTweetTableViewCell.h"
#import "ASTweet.h"

@interface ASDetailedTweetTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;


@end


@implementation ASDetailedTweetTableViewCell

- (void)awakeFromNib
{
    // Initialization code
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
}

@end
