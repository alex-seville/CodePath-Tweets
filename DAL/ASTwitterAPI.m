//
//  ASTwitterAPI.m
//  ASTweet
//
//  Created by Alexander Seville on 3/26/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASTwitterAPI.h"

NSString * const TOKEN_REQUEST_PATH = @"oauth/request_token";
NSString * const APP_SCHEME = @"astweet";
NSString * const TOKEN_CALLBACK_PATH = @"oauth_request";
NSString * const API_URL = @"https://api.twitter.com/";
NSString * const TOKEN_AUTH_URL = @"oauth/authorize?oauth_token=%@";

NSString * const GET_USER_URL = @"1.1/account/verify_credentials.json";
NSString * const GET_TIMELINE_URL = @"1.1/statuses/home_timeline.json";
NSString * const POST_STATUS_UPDATE_URL = @"1.1/statuses/update.json";
NSString * const POST_STATUS_RETWEET_URL = @"1.1/statuses/retweet/%@.json";
NSString * const POST_STATUS_FAVORITE_URL = @"1.1/favorites/create.json";
NSString * const POST_STATUS_UNFAVORITE_URL = @"1.1/favorites/destroy.json";
NSString * const GET_MENTIONS_URL = @"1.1/statuses/mentions_timeline.json";

static NSString *TWITTER_API_KEY;
static NSString *TWITTER_API_SECRET;
static NSString *TWITTER_ACCESS_TOKEN;
static NSString *TWITTER_ACCESS_TOKEN_SECRET;


@implementation NSURL (dictionaryFromQueryString)
-(NSDictionary *) dictionaryFromQueryString{
    
    NSString *query = [self query];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}
@end




@implementation ASTwitterAPI

+ (ASTwitterAPI *)instance {
    static ASTwitterAPI *instance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        
        /* read in api config from plist */
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSString *plistPath;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        plistPath = [rootPath stringByAppendingPathComponent:@"TwitterAPI.plist"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"TwitterAPI" ofType:@"plist"];
        }
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                              propertyListFromData:plistXML
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              format:&format
                                              errorDescription:&errorDesc];
        if (!temp) {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        
        
        TWITTER_API_KEY = [temp objectForKey:@"TWITTER_API_KEY"];
        TWITTER_API_SECRET = [temp objectForKey:@"TWITTER_API_SECRET"];
        TWITTER_ACCESS_TOKEN = [temp objectForKey:@"TWITTER_ACCESS_TOKEN"];
        TWITTER_ACCESS_TOKEN_SECRET = [temp objectForKey:@"TWITTER_ACCESS_TOKEN_SECRET"];
        
        /* now create the instance */
        
        instance = [[ASTwitterAPI alloc] initWithBaseURL:[NSURL URLWithString:API_URL] consumerKey:TWITTER_API_KEY consumerSecret:TWITTER_API_SECRET];
        
    });
    
    return instance;
}

- (void)login {
    /* remove any existing auth tokens */
	[self.requestSerializer removeAccessToken];
    
    NSString *tokenCallbackURL = [[APP_SCHEME stringByAppendingString:@"://"] stringByAppendingString:TOKEN_CALLBACK_PATH];
    
    /* request token */
    /* replace the succes and failure with private methods maybe */
    [self fetchRequestTokenWithPath:TOKEN_REQUEST_PATH method:@"POST" callbackURL:[NSURL URLWithString:tokenCallbackURL] scope:nil success:^ (BDBOAuthToken *requestToken) {
        NSString *authURL = [NSString stringWithFormat:[API_URL stringByAppendingString:TOKEN_AUTH_URL], requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
	
}

- (BOOL)processAuthResponseURL:(NSURL *)url onSuccess:(void (^)(void))success{
    if ([url.scheme  isEqual: APP_SCHEME]){
        if ([url.host  isEqual: TOKEN_CALLBACK_PATH]){
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                [self fetchAccessTokenWithPath:@"/oauth/access_token"
                                                method:@"POST"
                                          requestToken:[BDBOAuthToken tokenWithQueryString:url.query]
                                               success:^(BDBOAuthToken *accessToken) {
                                                   [self.requestSerializer saveAccessToken:accessToken];
                                                   
                                                   success();
                                               }
                                               failure:^(NSError *error) {
                                                   NSLog(@"Error");
                                               }];
                
            }
            return true;
        }
    }
    return false;
}

- (AFHTTPRequestOperation *)getWithEndpointType:(ASTwitterAPIEndpointType)endpointType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *endpointTypeStr = [[NSString alloc] init];
    NSDictionary *parameters = nil;
    
    if (endpointType == ASTwitterAPIEndpointUser){
        endpointTypeStr = GET_USER_URL;
    } else if (endpointType == ASTwitterAPIEndpointTimeline){
        endpointTypeStr = GET_TIMELINE_URL;
        
        parameters = @{
                       @"count": @(20)
                       };
    } else if (endpointType == ASTwitterAPIEndpointMentions){
        endpointTypeStr = GET_MENTIONS_URL;
    }
    
    return [self GET:endpointTypeStr parameters:parameters success:success failure:failure];

}

- (AFHTTPRequestOperation *)postWithEndpointType:(ASTwitterAPIEndpointType)endpointType parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *endpointTypeStr = [[NSString alloc] init];
    
    if (endpointType == ASTwitterAPIEndpointAddTweet){
        endpointTypeStr = POST_STATUS_UPDATE_URL;
    } else if (endpointType == ASTwitterAPIEndpointReply){
        endpointTypeStr = POST_STATUS_UPDATE_URL;
    } else if (endpointType == ASTwitterAPIEndpointRetweet){
        NSString *tweetId = parameters[@"id"];
        
        endpointTypeStr = [NSString stringWithFormat:POST_STATUS_RETWEET_URL, tweetId ];
    } else if (endpointType == ASTwitterAPIEndpointFavorite) {
        endpointTypeStr = POST_STATUS_FAVORITE_URL;
    } else if (endpointType == ASTwitterAPIEndpointUnfavorite) {
        endpointTypeStr = POST_STATUS_UNFAVORITE_URL;
    }
    
    return [self POST:endpointTypeStr parameters:parameters success:success failure:failure];
    
}



@end
