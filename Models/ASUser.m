//
//  ASUser.m
//  ASTweet
//
//  Created by Alexander Seville on 3/27/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASUser.h"

NSString * const UserLoggedInNotification = @"UserLoggedInNotification";



@implementation ASUser

static ASUser *currentUser = nil;




- (void)setAsCurrentUser {
	currentUser = self;
	/* save to user defaults */
    [[NSUserDefaults standardUserDefaults] setObject:[self toDictionary] forKey:@"current_user"];
    /* notify others */
    [[NSNotificationCenter defaultCenter] postNotificationName:UserLoggedInNotification object:nil];
}

- (NSDictionary *)toDictionary {
    
    return @{
        @"description": self.description,
        @"followers_count": [NSString stringWithFormat:@"%i",self.followersCount],
        @"name": self.realName,
        @"location": self.location,
        @"profile_background_color": self.profileBackgroundColor,
        @"profile_background_image_url": self.profileBackgroundImageURL,
        @"profile_image_url": self.profileImageURL,
        @"screen_name": self.screenName,
        @"profile_background_image_url": self.profileBackgroundImageURL,
        @"friends_count": [NSString stringWithFormat:@"%i",self.followingCount],
        @"statuses_count_count": [NSString stringWithFormat:@"%i",self.tweetCount]
             };
}

- (ASUser*)initWithDictionary:(NSDictionary*)userDictionary {
    self = [super init];
    
    self.description = userDictionary[@"description"];
    self.followersCount = [userDictionary[@"followers_count"] intValue];
    self.realName = userDictionary[@"name"];
    self.location = userDictionary[@"location"];
    self.profileBackgroundColor = userDictionary[@"profile_background_color"];
    self.profileBackgroundImageURL = userDictionary[@"profile_background_image_url"];
    self.profileImageURL = userDictionary[@"profile_image_url"];
    self.screenName = userDictionary[@"screen_name"];
    self.profileBackgroundImageURL = userDictionary[@"profile_background_image_url"];
    self.followingCount = [userDictionary[@"friends_count"] intValue];
    self.tweetCount = [userDictionary[@"statuses_count"] intValue];
    
    return self;
}

#pragma mark - class methods


+ (ASUser *)currentUser {
	if (currentUser == nil){
		NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user"];
		if (dict){
			[[[ASUser alloc] initWithDictionary:dict] setAsCurrentUser];
		}
	}
	return currentUser;
}


+ (NSString *)getFormattedScreenName:(NSString *)screenName {
	return [@"@" stringByAppendingString:screenName];
}

@end
