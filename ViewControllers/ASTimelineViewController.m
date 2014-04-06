//
//  ASTimelineViewController.m
//  ASTweet
//
//  Created by Alexander Seville on 3/26/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASTimelineViewController.h"
#import "ASUser.h"
#import "ASTweetTableViewCell.h"
#import "ASTwitterAPI.h"
#import "ASTweet.h"
#import "ASTweetViewController.h"
#import "ASComposeTweetViewController.h"
#import "SVProgressHUD.h"


@interface ASTimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;

@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) NSDictionary *tweetAttributes;
@property (nonatomic, strong) ASTwitterAPI *apiClient;



@end

NSString * const TweetClicked = @"TweetClicked";
NSString * const ComposeClicked = @"ComposeClicked";
NSString * const ProfilePhotoClicked = @"ProfilePhotoClicked";

@implementation ASTimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tweetAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.tweets.count == 0){
        self.timelineTableView.hidden = true;
    }
    
    self.apiClient = [ASTwitterAPI instance];
    
    [self loadTweets];
    
    /* allow refresh on swipe down */
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.timelineTableView addSubview:refreshControl];
    
    self.timelineTableView.dataSource = self;
    self.timelineTableView.delegate = self;
    
    UINib *tweetCellNib = [UINib nibWithNibName:@"ASTweetTableViewCell" bundle:nil];
    [self.timelineTableView registerNib:tweetCellNib forCellReuseIdentifier:@"ASTweetTableViewCell"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addTweetToTimeline:)
                                                 name:NewTweetCreatedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASTweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ASTweetTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell setTweet:self.tweets[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat MIN_TWEET_HEIGHT = 85.0;
    
    ASTweet *tweet = (ASTweet*)self.tweets[indexPath.row];
    
    NSInteger tweetCellHeight = [[ASUser getFormattedScreenName:tweet.text] boundingRectWithSize:CGSizeMake(221, 144*17) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.tweetAttributes context:nil].size.height;
    
    CGFloat rowHeight = 27.0 + tweetCellHeight + 8.0;
    
    return rowHeight > MIN_TWEET_HEIGHT ? rowHeight : MIN_TWEET_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Row selected");
    [[NSNotificationCenter defaultCenter] postNotificationName:TweetClicked object:nil userInfo:[NSDictionary dictionaryWithObject:self.tweets[indexPath.row] forKey:@"tweet"]];
    [self.timelineTableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - private

- (void)showTimelineTable {
    self.timelineTableView.hidden = false;
}

-(void) loadTweets {
    
    
    [SVProgressHUD show];
    [self.apiClient getWithEndpointType:ASTwitterAPIEndpointTimeline success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.tweets = [ASTweet tweetsFromArray:responseObject];
        
        if (self.tweets.count > 0){
            self.timelineTableView.hidden = false;
        }
        
        
        [self.timelineTableView reloadData];
        [SVProgressHUD dismiss];
        
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
        [SVProgressHUD dismiss];
    }];

}

- (void)onComposeButton{
    [self onComposeButtonWithReply:nil];
}

- (void)onComposeButtonWithReply:(ASTweet *)tweet{
    NSLog(@"Reply clicked");
    NSDictionary *params = nil;
    
    if (tweet != nil){
        params = [NSDictionary dictionaryWithObject:@{
                                             @"replyIdStr": tweet.tweetIdStr,
                                             @"replyTo": tweet.user.screenName
                                             } forKey:@"compose"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ComposeClicked object:nil userInfo:params];
    
   
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self loadTweets];
    [refreshControl endRefreshing];
}

- (void)addTweetToTimeline:(NSNotification *) notification {
    ASTweet *newTweet = (ASTweet *)notification.userInfo[@"tweet"];
    [self.tweets insertObject:newTweet atIndex:0];
    [self.timelineTableView reloadData];
}

#pragma mark - tweet actions

- (void) didClickReply:(ASTweet *)tweet {
    [self onComposeButtonWithReply:tweet];
}

- (void) didClickRetweet:(ASTweet *)tweet {
    
    tweet.isRetweeted = true;
    tweet.retweetCount++;
    
    [self.apiClient postWithEndpointType:ASTwitterAPIEndpointRetweet parameters:
     @{
       @"id": tweet.tweetIdStr
       } success:^(AFHTTPRequestOperation *operation, id responseObject){
           
           /* refresh the line */
           
           /* update retweet icon */
       } failure:^(AFHTTPRequestOperation *operation, NSError *error){
           
           tweet.isRetweeted = false;
           tweet.retweetCount--;
           NSLog(@"Error tweeting: %@", error);
           
       }];
    
}

- (void) didClickFavorite:(ASTweet *)tweet {
    
    ASTwitterAPIEndpointType type = tweet.isFavorited ? ASTwitterAPIEndpointUnfavorite : ASTwitterAPIEndpointFavorite;
    
    tweet.isFavorited = true;
    tweet.favoriteCount++;
    
    [self.apiClient postWithEndpointType:type parameters:
     @{
       @"id": tweet.tweetIdStr
       } success:^(AFHTTPRequestOperation *operation, id responseObject){
           
           
          //refresh the lne
           /* update retweet icon */
       } failure:^(AFHTTPRequestOperation *operation, NSError *error){
           
           tweet.isFavorited = false;
           tweet.favoriteCount--;
           NSLog(@"Error tweeting: %@", error);
           
       }];
    
}

- (void) didClickProfile:(ASUser *)user {
    NSLog(@"clicked profile, notify observers");
    [[NSNotificationCenter defaultCenter] postNotificationName:ProfilePhotoClicked object:nil userInfo:@{@"user": user}];
}



@end
