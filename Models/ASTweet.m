//
//  ASTweet.m
//  ASTweet
//
//  Created by Alexander Seville on 3/28/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASTweet.h"
#import "ASUser.h"
#import "MHPrettyDate.h"


@implementation ASTweet




+ (NSMutableArray *)tweetsFromArray:(NSArray *)tweets {
    
    NSMutableArray *parsedTweets = [[NSMutableArray alloc] init];
    
    for (NSDictionary *tweet in tweets ){
        ASTweet *parsedTweet = [[ASTweet alloc] initWithDictionary:tweet];
        [parsedTweets addObject:parsedTweet];
    }
    
    return parsedTweets;
}

- (ASTweet*) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EE LLLL d HH:mm:ss Z yyyy"];
    self.createdAt = [dateFormat dateFromString:dictionary[@"created_at"]];
   
    self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
    self.retweetCount = [dictionary[@"retweet_count"] integerValue];
    self.text = dictionary[@"text"];
    self.user = [[ASUser alloc] initWithDictionary:dictionary[@"user"]];
    self.tweetIdStr = dictionary[@"id_str"];
    self.isFavorited = [dictionary[@"favorited"] boolValue];
    self.isRetweeted = [dictionary[@"retweeted"] boolValue];
    
    /* later we can parse these replies too, but for now we're just using the count */
    self.replyCount = ((NSArray *)dictionary[@"entities"][@"user_mentions"]).count;
    
    return self;
}

#pragma mark - class methods

+ (NSString *)getTimeSince:(NSDate *)date {
    return [MHPrettyDate prettyDateFromDate:date withFormat:MHPrettyDateShortRelativeTime];
}

@end
