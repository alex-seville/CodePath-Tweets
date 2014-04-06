//
//  ASTweetTableViewCell.h
//  ASTweet
//
//  Created by Alexander Seville on 3/28/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASTweet.h"
#import "ASUser.h"

@protocol ASTweetActionsDelegate <NSObject>
@required
- (void)didClickReply:(ASTweet *)tweet;
- (void)didClickRetweet:(ASTweet *)tweet;
- (void)didClickFavorite:(ASTweet *)tweet;
- (void)didClickProfile:(ASUser *)user;

@end

@interface ASTweetTableViewCell : UITableViewCell

@property (nonatomic, strong) ASTweet *tweet;
@property (nonatomic, weak) id <ASTweetActionsDelegate> delegate;

@end
