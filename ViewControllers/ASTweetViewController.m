//
//  ASTweetViewController.m
//  ASTweet
//
//  Created by Alexander Seville on 3/29/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASTweetViewController.h"
#import "ASDetailedTweetTableViewCell.h"
#import "ASComposeTweetViewController.h"
#import "ASDetailedTweetActionsTableViewCell.h"
#import "ASDetailedTweetStatusTableViewCell.h"
#import "ASTwitterAPI.h"


@interface ASTweetViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tweetTable;
@property (nonatomic, strong) NSDictionary *tweetAttributes;
@property (nonatomic, assign) BOOL showStatus;
@property (nonatomic, strong) ASTwitterAPI *apiClient;
@end

@implementation ASTweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tweetAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tweetTable.dataSource = self;
    self.tweetTable.delegate = self;
    
    UINib *detailedTweetNib = [UINib nibWithNibName:@"ASDetailedTweetTableViewCell" bundle:nil];
    [self.tweetTable registerNib:detailedTweetNib forCellReuseIdentifier:@"ASDetailedTweetTableViewCell"];

    UINib *actionsTweetNib = [UINib nibWithNibName:@"ASDetailedTweetActionsTableViewCell" bundle:nil];
    [self.tweetTable registerNib:actionsTweetNib forCellReuseIdentifier:@"ASDetailedTweetActionsTableViewCell"];

    UINib *statusTweetNib = [UINib nibWithNibName:@"ASDetailedTweetStatusTableViewCell" bundle:nil];
    [self.tweetTable registerNib:statusTweetNib forCellReuseIdentifier:@"ASDetailedTweetStatusTableViewCell"];

    
    
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"New.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];
    composeButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = composeButton;
    
    if (_tweet.retweetCount > 0 || _tweet.favoriteCount > 0){
        self.showStatus = true;
    }else{
        self.showStatus = false;
    }
    
    self.apiClient = [ASTwitterAPI instance];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /* display the tweet and the action bar */
    return self.showStatus ? 3 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        ASDetailedTweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ASDetailedTweetTableViewCell" forIndexPath:indexPath];
        [cell setTweet:self.tweet];
        return cell;
    }
    
    if (self.showStatus && indexPath.row == 1){
        
        UIColor *lightLine = [UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1.0f];
        
        ASDetailedTweetStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ASDetailedTweetStatusTableViewCell" forIndexPath:indexPath];
        [cell setTweet:self.tweet];
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, cell.contentView.frame.size.width-16, 1)];
        
        topLineView.backgroundColor = lightLine;
        [cell.contentView addSubview:topLineView];
        
        return cell;
        
    }else{
    
        UIColor *lightLine = [UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1.0f];
    
        ASDetailedTweetActionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ASDetailedTweetActionsTableViewCell" forIndexPath:indexPath];
        [cell setTweet:self.tweet];
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, cell.contentView.frame.size.width-16, 1)];
        cell.delegate = self;
    
        topLineView.backgroundColor = lightLine;
        [cell.contentView addSubview:topLineView];
    
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height-1, cell.contentView.frame.size.width, 1)];
    
        bottomLineView.backgroundColor = lightLine;
        [cell.contentView addSubview:bottomLineView];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        CGFloat MIN_TWEET_HEIGHT = 97.0;
    
        NSInteger tweetCellHeight = [[ASUser getFormattedScreenName:self.tweet.text] boundingRectWithSize:CGSizeMake(301, 144*16) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.tweetAttributes context:nil].size.height;
    
        CGFloat rowHeight = 80.0 + tweetCellHeight + 30.0 + 8.0;
    
        return rowHeight > MIN_TWEET_HEIGHT ? rowHeight : MIN_TWEET_HEIGHT;
    }
    return 43;
}


#pragma mark - tweet actions

- (void) didClickReply:(ASTweet *)replyCell {
    [self onComposeButton];
}

- (void) didClickRetweet:(ASTweet *)tweet {
    
    [self.apiClient postWithEndpointType:ASTwitterAPIEndpointRetweet parameters:
     @{
       @"id": _tweet.tweetIdStr
       } success:^(AFHTTPRequestOperation *operation, id responseObject){
           _tweet.isRetweeted = true;
           _tweet.retweetCount++;
           
           self.showStatus = true;
           [self.tweetTable reloadData];
           
           /* update retweet icon */
       } failure:^(AFHTTPRequestOperation *operation, NSError *error){
           NSLog(@"Error tweeting: %@", error);
           
       }];

}

- (void) didClickFavorite:(ASTweet *)tweet {
   
    ASTwitterAPIEndpointType type = tweet.isFavorited ? ASTwitterAPIEndpointUnfavorite : ASTwitterAPIEndpointFavorite;
    
    _tweet.isFavorited = !tweet.isFavorited;
    if (_tweet.isFavorited){
        _tweet.favoriteCount++;
        self.showStatus = true;
    }else{
        _tweet.favoriteCount--;
        if (_tweet.favoriteCount == 0){
            self.showStatus = false;
        }
    }
    [self.tweetTable reloadData];
    
    [self.apiClient postWithEndpointType:type parameters:
     @{
       @"id": tweet.tweetIdStr
       } success:^(AFHTTPRequestOperation *operation, id responseObject){
           
          
           /* update retweet icon */
       } failure:^(AFHTTPRequestOperation *operation, NSError *error){
           
           _tweet.isFavorited = !tweet.isFavorited;
           if (_tweet.isFavorited){
               _tweet.favoriteCount++;
               self.showStatus = true;
           }else{
               _tweet.favoriteCount--;
               if (_tweet.favoriteCount == 0){
                   self.showStatus = false;
               }
           }
           [self.tweetTable reloadData];
           NSLog(@"Error tweeting: %@", error);
           
       }];

}


#pragma mark - private

- (void) onComposeButton {
    ASComposeTweetViewController *composeView = [[ASComposeTweetViewController alloc] init];
    composeView.replyTo = [ASUser getFormattedScreenName:self.tweet.user.screenName];
    composeView.replyIdStr = self.tweet.tweetIdStr;
   
    [UIView  beginAnimations: @"ShowCompose"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController: composeView animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

@end
