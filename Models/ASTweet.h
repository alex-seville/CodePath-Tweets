//
//  ASTweet.h
//  ASTweet
//
//  Created by Alexander Seville on 3/28/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASUser.h"

@interface ASTweet : NSObject

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) ASUser *user;

+ (NSMutableArray *)tweetsFromArray:(NSArray *)tweets;
+ (NSString *)getTimeSince:(NSDate *)date;

@end
