//
//  ASProfileViewController.m
//  ASTweet
//
//  Created by Alexander Seville on 4/5/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ASProfileStatsTableViewCell.h"

@interface ASProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileBackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userRealnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreennameLabel;
@property (weak, nonatomic) IBOutlet UITableView *statusTable;

@end

@implementation ASProfileViewController

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
    
    UINib *profileCellNib = [UINib nibWithNibName:@"ASProfileStatsTableViewCell" bundle:nil];
    [self.statusTable registerNib:profileCellNib forCellReuseIdentifier:@"ASProfileStatsTableViewCell"];
    
    
    [self.profileBackgroundImage setImageWithURL:[NSURL URLWithString:self.user.profileBackgroundImageURL]];
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:self.user.profileImageURL]];
    self.userRealnameLabel.text = self.user.realName;
    self.userScreennameLabel.text = [ASUser getFormattedScreenName:self.user.screenName];
    
    [self.profileBackgroundImage setClipsToBounds:YES];
    
    self.statusTable.delegate = self;
    self.statusTable.dataSource = self;
    
    [self.statusTable reloadData];
    
    NSLog(@"user: %@", self.user);
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
    ASProfileStatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ASProfileStatsTableViewCell" forIndexPath:indexPath];
    [cell setUser:self.user];
    return cell;
}


@end
