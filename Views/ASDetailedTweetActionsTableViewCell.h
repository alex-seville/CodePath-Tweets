//
//  ASDetailedTweetActionsTableViewCell.h
//  ASTweet
//
//  Created by Alexander Seville on 3/29/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASTweet.h"

@protocol ASDetailedTweetActionsDelegate <NSObject>
@required
- (void)didClickReply:(ASTweet *)tweet;
- (void)didClickRetweet:(ASTweet *)tweet;
- (void)didClickFavorite:(ASTweet *)tweet;

@end

@interface ASDetailedTweetActionsTableViewCell : UITableViewCell

@property (nonatomic, strong) ASTweet *tweet;
@property (nonatomic, weak) id <ASDetailedTweetActionsDelegate> delegate;

@end


