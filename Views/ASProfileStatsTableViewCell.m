//
//  ASProfileStatsTableViewCell.m
//  ASTweet
//
//  Created by Alexander Seville on 4/6/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASProfileStatsTableViewCell.h"

@interface ASProfileStatsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UIView *middleView;

@end

@implementation ASProfileStatsTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(ASUser *)user {
    self.tweetCountLabel.text = [self stringForReputationFormatted:user.tweetCount ];
    self.followersCountLabel.text = [self stringForReputationFormatted:user.followersCount ];
    self.followingCountLabel.text = [self stringForReputationFormatted:user.followingCount ];
}


//from http://stackapps.com/questions/1012/how-to-format-reputation-numbers-similar-to-stack-exchange-sites
- (NSString*) stringForReputationFormatted:(int)reputation
{
    NSString *returnable = nil;
    NSLog(@"formatting: %i", reputation);
    if (reputation < 10000) {
        returnable = [NSString stringWithFormat:@"%i", reputation];
    }
    else {
        NSString *repStr    = [NSString stringWithFormat:@"%i", reputation];
        NSString *whole     = [repStr substringToIndex:[repStr length]-3];
        NSString *decimal   = [repStr substringWithRange:NSMakeRange([repStr length]-3, 1)];
        if ([decimal intValue] != 0) {
            returnable = [whole stringByAppendingFormat:@".%@K", decimal];
        } else {
            returnable = [whole stringByAppendingFormat:@"K"];
        }
    }
    NSLog(@"returning: %@", returnable);
    return returnable;
}
@end
