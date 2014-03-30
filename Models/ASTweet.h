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
@property (nonatomic, assign) int favoriteCount;
@property (nonatomic, assign) int retweetCount;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) ASUser *user;
@property (nonatomic, strong) NSString *tweetIdStr;
@property (nonatomic, assign) BOOL isFavorited;
@property (nonatomic, assign) BOOL isRetweeted;
@property (nonatomic, assign) int replyCount;

+ (NSMutableArray *)tweetsFromArray:(NSArray *)tweets;
+ (NSString *)getTimeSince:(NSDate *)date;
- (ASTweet*) initWithDictionary:(NSDictionary *)dictionary;

@end
