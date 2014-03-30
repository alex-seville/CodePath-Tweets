//
//  ASComposeTweetViewController.m
//  ASTweet
//
//  Created by Alexander Seville on 3/29/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASComposeTweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ASTwitterAPI.h"
#import "SVProgressHUD.h"

NSString * const NewTweetCreatedNotification = @"NewTweetCreatedNotification";

@interface ASComposeTweetViewController ()
@property (weak, nonatomic) IBOutlet UITextView *composeTweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *twitterHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorProfileImage;

@property (nonatomic,strong) UIBarButtonItem *characterCount;

@end

@implementation ASComposeTweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.composeTweetTextView.delegate = self;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    cancelButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButton)];
    tweetButton.enabled = false;
    tweetButton.tintColor = [UIColor whiteColor];
    
    self.characterCount = [[UIBarButtonItem alloc] initWithTitle:@"140" style:UIBarButtonItemStylePlain target:self action:nil];
    self.characterCount.enabled = false;
    self.characterCount.tintColor = [UIColor whiteColor];
    
    
    self.navigationItem.rightBarButtonItems = @[tweetButton, self.characterCount];
    
    if (_replyTo != nil){
        self.composeTweetTextView.text = [_replyTo stringByAppendingString:@" "];
    }else{
        self.composeTweetTextView.text = @"";
    }
    
    ASUser *currentUser = [ASUser currentUser];
    
    [self.authorProfileImage setImageWithURL:[NSURL URLWithString:currentUser.profileImageURL]];
    self.twitterHandleLabel.text = [ASUser getFormattedScreenName:currentUser.screenName];
    self.realNameLabel.text = currentUser.realName;
    
    [self.composeTweetTextView becomeFirstResponder];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    self.characterCount.title = [@(140 - textView.text.length) stringValue];
    
    if (textView.text.length > 140 || textView.text.length == 0){
        self.navigationItem.rightBarButtonItem.enabled = false;
    }
    self.navigationItem.rightBarButtonItem.enabled = true;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    
    if (textView.text.length + text.length > 140){
        if (location != NSNotFound){
            self.navigationItem.rightBarButtonItem.enabled = false;
        }
        return NO;
    }
    else if (location != NSNotFound){
        self.navigationItem.rightBarButtonItem.enabled = false;
        return NO;
    }
    self.navigationItem.rightBarButtonItem.enabled = true;
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancelButton {
    
    [UIView animateWithDuration:0.75 animations:^{
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
        [self.navigationController popViewControllerAnimated:NO];
    } completion:nil];
}

- (void)onTweetButton {
    
    //in_reply_to_status_id
    
    ASTwitterAPI *apiClient = [ASTwitterAPI instance];
    [SVProgressHUD show];
    [apiClient postWithEndpointType:ASTwitterAPIEndpointAddTweet parameters:
   @{
     @"status": self.composeTweetTextView.text,
     @"in_reply_to_status_id": _replyIdStr ? _replyIdStr : @""
    } success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        
        /* parse new tweet */
        ASTweet *newTweet = [[ASTweet alloc] initWithDictionary:responseObject];
        /* notify observers */
        [[NSNotificationCenter defaultCenter] postNotificationName:NewTweetCreatedNotification object:self userInfo:[NSDictionary dictionaryWithObject:newTweet forKey:@"tweet"]];
        
        [UIView animateWithDuration:0.75 animations:^{
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
            [self.navigationController popViewControllerAnimated:NO];
        } completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error tweeting: %@", error);
        [SVProgressHUD dismiss];
    }];
    
    
}

@end
