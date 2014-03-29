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


@interface ASTweetViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tweetTable;

@end

@implementation ASTweetViewController

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
    self.tweetTable.dataSource = self;
    self.tweetTable.delegate = self;
    
    UINib *detailedTweetNib = [UINib nibWithNibName:@"ASDetailedTweetTableViewCell" bundle:nil];
    [self.tweetTable registerNib:detailedTweetNib forCellReuseIdentifier:@"ASDetailedTweetTableViewCell"];
    
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"New.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];
    composeButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = composeButton;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASDetailedTweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ASDetailedTweetTableViewCell" forIndexPath:indexPath];
    [cell setTweet:self.tweet];
    return cell;
}

- (void) onComposeButton {
    ASComposeTweetViewController *composeView = [[ASComposeTweetViewController alloc] init];
    [self presentViewController:composeView animated:YES completion: nil];
}

@end
