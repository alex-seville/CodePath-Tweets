//
//  ASComposeTweetViewController.h
//  ASTweet
//
//  Created by Alexander Seville on 3/29/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASTweet.h"

extern NSString * const NewTweetCreatedNotification;

@interface ASComposeTweetViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) NSString *replyTo;
@property (nonatomic, assign) NSString *replyIdStr;

@end
