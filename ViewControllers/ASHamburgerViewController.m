//
//  ASHamburgerViewController.m
//  ASTweet
//
//  Created by Alexander Seville on 4/4/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASHamburgerViewController.h"

@interface ASHamburgerViewController ()
@property (nonatomic, strong) NSArray *list;
@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@end


NSString * const ProfileClicked = @"ProfileClicked";
NSString * const TimelineClicked = @"TimelineClicked";
NSString * const MentionsClicked = @"MentionsClicked";

@implementation ASHamburgerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.list = @[@"Profile", @"Timeline", @"Mentions"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuTable.delegate = self;
    self.menuTable.dataSource = self;
    
    // Do any additional setup after loading the view from its nib.
    [self.menuTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = self.list[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select row");
    if (indexPath.row == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:ProfileClicked object:nil];
    } else if (indexPath.row == 1){
        [[NSNotificationCenter defaultCenter] postNotificationName:TimelineClicked object:nil];
    } else if (indexPath.row == 2){
        [[NSNotificationCenter defaultCenter] postNotificationName:MentionsClicked object:nil];
    }
    [self.menuTable deselectRowAtIndexPath:indexPath animated:NO];
}

@end
