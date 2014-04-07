//
//  ASMainViewController.m
//  ASTweet
//
//  Created by Alexander Seville on 4/4/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASMainViewController.h"
#import "ASHamburgerViewController.h"
#import "ASTimelineViewController.h"
#import "ASTweetViewController.h"
#import "ASComposeTweetViewController.h"
#import "ASProfileViewController.h"
#import "ASTwitterAPI.h"

@interface ASMainViewController ()

@property (nonatomic, strong) UIViewController *contentViewController;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, assign) BOOL menuOpen;
@property (nonatomic, strong) ASHamburgerViewController *menu;

- (IBAction)onPan:(UIPanGestureRecognizer *)sender;

@end

@implementation ASMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.menu =[[ASHamburgerViewController alloc] init];
        ASTimelineViewController *timeline = [[ASTimelineViewController alloc] init];
        timeline.timelineType = ASTwitterAPIEndpointTimeline;
        
        self.contentViewController = timeline;
        self.menuOpen = false;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onViewDetail:)
                                                     name:TweetClicked object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onCompose:)
                                                     name:ComposeClicked object:nil];
        
        /* menu events */
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onProfileClicked)
                                                     name:ProfileClicked object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onTimelineClicked)
                                                     name:TimelineClicked object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onMentionsClicked)
                                                     name:MentionsClicked object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onShowProfile:)
                                                     name:ProfilePhotoClicked object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onShowMyTweets)
                                                     name:MyTweetsClicked object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    
    
    UIBarButtonItem *hamButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(onHamburgerButton)];
    hamButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = hamButton;
    
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"New.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];
    composeButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = composeButton;
    
    
    
    [self.navigationController.navigationBar setBarTintColor:self.contentViewController.view.backgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];

    
    UIView *timeLine = self.contentViewController.view;
    timeLine.frame = self.contentView.frame;
    
    [self decorateNewView:timeLine];
    
    // Do any additional setup after loading the view from its nib.
    [self.contentView addSubview:self.menu.view];
    [self.contentView addSubview:timeLine];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onHamburgerButton {
    
    NSInteger offset = 60;
    if (self.menuOpen){
        offset = ((UIView *)self.contentView.subviews[1]).frame.size.width;
        self.menuOpen = false;
    }else{
        self.menuOpen = true;
    }
    
    
    [UIView animateWithDuration:0.25 animations:^{
        UIView *subview = (UIView *)self.contentView.subviews[1];
        CGRect endFrame = CGRectMake(subview.frame.size.width-offset, subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height );
        subview.frame = endFrame;
    }];
    
}

- (void) onViewDetail:(NSNotification *) notification {
    NSLog(@"on view detail");
    ASTweetViewController *tweetView = [[ASTweetViewController alloc] init];
    tweetView.tweet = (ASTweet *)notification.userInfo[@"tweet"];
    [self.navigationController pushViewController:tweetView animated:YES];
    
}

- (void) onShowProfile:(NSNotification *) notification {
    NSLog(@"on view profile");
    ASProfileViewController *profileView = [[ASProfileViewController alloc] init];
    profileView.user = (ASUser *)notification.userInfo[@"user"];
    [self.navigationController pushViewController:profileView animated:YES];
    
}


- (void) onCompose:(NSNotification *) notification {
    ASComposeTweetViewController *composeView = [[ASComposeTweetViewController alloc] init];
    NSDictionary *dict = notification.userInfo[@"compose"];
    
    if (dict != nil){
        composeView.replyIdStr = dict[@"tweetIdStr"];
        composeView.replyTo = [ASUser getFormattedScreenName:dict[@"replyTo"]];
    }
    
    
    [UIView  beginAnimations: @"ShowCompose"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController: composeView animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

- (void) onComposeButton {
    ASComposeTweetViewController *composeView = [[ASComposeTweetViewController alloc] init];
    [UIView  beginAnimations: @"ShowCompose"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController: composeView animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

- (void) onProfileClicked {
    NSLog(@"Profile clicked");
    [self hideCurrentView:^(void){
        /* load profile view */
        ASProfileViewController *profileView = [[ASProfileViewController alloc] init];
        profileView.user = [ASUser currentUser];
        NSLog(@"add profile view to array");
        self.contentViewController = profileView;
        NSLog(@"add profile view to view");
        profileView.view.frame = self.contentView.frame;
        CGRect endFrame = CGRectMake(self.contentView.frame.size.width+20, profileView.view.frame.origin.y, profileView.view.frame.size.width, profileView.view.frame.size.height );
        profileView.view.frame = endFrame;
        [self decorateNewView:profileView.view];
        [self.contentView addSubview:profileView.view];
        NSLog(@"show profile view");
        self.menuOpen = false;
        [self showView];
    }];
}

- (void) onTimelineClicked {
    NSLog(@"timeline clicked");
    [self hideCurrentView:^(void){
        /* load timeline view */
        ASTimelineViewController *timelineView = [[ASTimelineViewController alloc] init];
        timelineView.timelineType = ASTwitterAPIEndpointTimeline;
        self.contentViewController = timelineView;
        
        timelineView.view.frame = self.contentView.frame;
        CGRect endFrame = CGRectMake(self.contentView.frame.size.width+20, timelineView.view.frame.origin.y, timelineView.view.frame.size.width, timelineView.view.frame.size.height );
        timelineView.view.frame = endFrame;

        [self decorateNewView:timelineView.view];
        [self.contentView addSubview:timelineView.view];
        self.menuOpen = false;

        [self showView];
    }];
}

- (void) onMentionsClicked {
    NSLog(@"mentions clicked");
    [self hideCurrentView:^(void){
        /* load timeline view */
        ASTimelineViewController *timelineView = [[ASTimelineViewController alloc] init];
        timelineView.timelineType = ASTwitterAPIEndpointMentions;
        self.contentViewController = timelineView;
        
        timelineView.view.frame = self.contentView.frame;
        CGRect endFrame = CGRectMake(self.contentView.frame.size.width+20, timelineView.view.frame.origin.y, timelineView.view.frame.size.width, timelineView.view.frame.size.height );
        timelineView.view.frame = endFrame;
        
        [self decorateNewView:timelineView.view];
        [self.contentView addSubview:timelineView.view];
        self.menuOpen = false;
        
        [self showView];
    }];
}

- (void) onShowMyTweets {
    NSLog(@"my tweets clicked");
    [self hideCurrentView:^(void){
        /* load timeline view */
        ASTimelineViewController *timelineView = [[ASTimelineViewController alloc] init];
        timelineView.timelineType = ASTwitterAPIEndpointMyTweets;
        self.contentViewController = timelineView;
        
        timelineView.view.frame = self.contentView.frame;
        CGRect endFrame = CGRectMake(self.contentView.frame.size.width+20, timelineView.view.frame.origin.y, timelineView.view.frame.size.width, timelineView.view.frame.size.height );
        timelineView.view.frame = endFrame;
        
        [self decorateNewView:timelineView.view];
        [self.contentView addSubview:timelineView.view];
        self.menuOpen = false;
        
        [self showView];
    }];
}

- (void) decorateNewView:(UIView *)view {
    view.layer.shadowOffset = CGSizeMake(-5, 0);
    view.layer.shadowRadius = 5;
    view.layer.shadowOpacity = 0.5;
}

- (void) hideCurrentView:(void (^)(void))success {
    UIView *subview = (UIView *)self.contentView.subviews[1];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect endFrame = CGRectMake(self.contentView.frame.size.width+20, subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height );
        subview.frame = endFrame;
    } completion:^(BOOL finished){
        NSLog(@"Hiding done");
        [self.contentView.subviews[1] removeFromSuperview];
        success();
    }];
}

- (void) showView {
    UIView *subview = (UIView *)self.contentView.subviews[1];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect endFrame = CGRectMake(0, subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height );
        subview.frame = endFrame;
    } ];
}

- (IBAction)onPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint point = [panGestureRecognizer locationInView:self.contentView];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.contentView];
    UIView *subview = (UIView *)self.contentView.subviews[1];
    
    if (self.menuOpen){
        if (panGestureRecognizer.state == UIGestureRecognizerStateChanged){
            
            CGRect endFrame = CGRectMake(point.x, subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height );
            subview.frame = endFrame;
        }else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded){
            NSInteger offset = subview.frame.size.width-60;
            if (velocity.x <= 0){
                offset = 0;
                self.menuOpen = false;
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                CGRect endFrame = CGRectMake(offset, subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height );
                subview.frame = endFrame;
            }];
            
            
        }
    }
}
@end
