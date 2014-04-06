//
//  ASTimelineViewController.h
//  ASTweet
//
//  Created by Alexander Seville on 3/26/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASTweetTableViewCell.h"

extern NSString * const TweetClicked;
extern NSString * const ComposeClicked;
extern NSString * const ProfilePhotoClicked;

@interface ASTimelineViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASTweetActionsDelegate>



@end
