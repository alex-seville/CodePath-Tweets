//
//  ASSplashScreenViewController.m
//  ASTweet
//
//  Created by Alexander Seville on 3/26/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASSplashScreenViewController.h"
#import "ASTimelineViewController.h"


@interface ASSplashScreenViewController ()

@end

@implementation ASSplashScreenViewController

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
    
    int64_t delayInSeconds = 2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController pushViewController:[[ASTimelineViewController alloc] init] animated:YES];
    });
    
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
