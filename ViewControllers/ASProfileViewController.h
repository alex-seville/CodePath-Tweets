//
//  ASProfileViewController.h
//  ASTweet
//
//  Created by Alexander Seville on 4/5/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASUser.h"

@interface ASProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)  ASUser *user;

@end
