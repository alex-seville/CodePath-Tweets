//
//  ASTwitterAPI.h
//  ASTweet
//
//  Created by Alexander Seville on 3/26/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBOAuth1RequestOperationManager.h"

typedef enum  {
    ASTwitterAPIEndpointUser,
    ASTwitterAPIEndpointTimeline,
    ASTwitterAPIEndpointAddTweet,
    ASTwitterAPIEndpointReply,
    ASTwitterAPIEndpointRetweet,
    ASTwitterAPIEndpointFavorite,
    ASTwitterAPIEndpointUnfavorite,
    ASTwitterAPIEndpointMentions,
    ASTwitterAPIEndpointMyTweets
} ASTwitterAPIEndpointType;

@interface ASTwitterAPI : BDBOAuth1RequestOperationManager




+ (ASTwitterAPI *) instance;
- (void)login;
- (BOOL)processAuthResponseURL:(NSURL *)url onSuccess:(void (^)(void))success;
- (AFHTTPRequestOperation *)getWithEndpointType:(ASTwitterAPIEndpointType)endpointType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)postWithEndpointType:(ASTwitterAPIEndpointType)endpointType parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
