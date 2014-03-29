//
//  ASTweetViewController.h
//  ASTweet
//
//  Created by Alexander Seville on 3/29/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASTweet.h"

@interface ASTweetViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)  ASTweet *tweet;

@end
