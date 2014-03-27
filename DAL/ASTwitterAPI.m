//
//  ASTwitterAPI.m
//  ASTweet
//
//  Created by Alexander Seville on 3/26/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASTwitterAPI.h"

@implementation ASTwitterAPI

+ (ASTwitterAPI *)instance {
    static ASTwitterAPI *instance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[ASTwitterAPI alloc] init];//]WithBaseUrl:[NSURL api.twitter.com] consumerkey: consumersecret: ];
        /* store these in a strings file */
    });
    
    return instance;
}

@end
