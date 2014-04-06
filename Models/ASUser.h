//
//  ASUser.h
//  ASTweet
//
//  Created by Alexander Seville on 3/27/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserLoggedInNotification;

@interface ASUser : NSObject

@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, assign) NSInteger followersCount;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *profileBackgroundColor;
@property (nonatomic, strong) NSString *profileBackgroundImageURL;
@property (nonatomic, strong) NSString *profileImageURL;
@property (nonatomic, assign) NSInteger followingCount;
@property (nonatomic, assign) NSInteger tweetCount;

+ (ASUser *)currentUser;
+ (NSString *)getFormattedScreenName:(NSString *)screenName;

- (void)setAsCurrentUser;
- (ASUser*)initWithDictionary:(NSDictionary*)userDictionary;

@end
