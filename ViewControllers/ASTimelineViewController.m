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

@end

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
    
    [self loadTweets];
    
    /* allow refresh on swipe down */
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.timelineTableView addSubview:refreshControl];
    
    self.timelineTableView.dataSource = self;
    self.timelineTableView.delegate = self;
    
    UINib *tweetCellNib = [UINib nibWithNibName:@"ASTweetTableViewCell" bundle:nil];
    [self.timelineTableView registerNib:tweetCellNib forCellReuseIdentifier:@"ASTweetTableViewCell"];
    
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"New.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];
    composeButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = composeButton;
    
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
    ASTweetViewController *tweetView = [[ASTweetViewController alloc] init];
    tweetView.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:tweetView animated:YES];
    [self.timelineTableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - private

- (void)showTimelineTable {
    self.timelineTableView.hidden = false;
}

-(void) loadTweets {
    ASTwitterAPI *apiClient = [ASTwitterAPI instance];
    
    [SVProgressHUD show];
    [apiClient getWithEndpointType:ASTwitterAPIEndpointTimeline success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
    ASComposeTweetViewController *composeView = [[ASComposeTweetViewController alloc] init];
    
    
    
    [UIView  beginAnimations: @"ShowCompose"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController: composeView animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
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

@end
