//
//  FBFriend2Cell.m
//  FBAuto
//
//  Created by lichaowei on 14-7-4.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBFriend2Cell.h"
#import "FBFriendModel.h"
#import "FBCityData.h"

@implementation FBFriend2Cell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)getCellData:(FBFriendModel *)aModel
{
    NSString *useType = nil;
    if ([aModel.usertype isEqualToString:@"1"]) {
        useType = @"个人";
    }else if ([aModel.usertype isEqualToString:@"2"]){
        useType = @"商家";
    }
    
    NSString *name = aModel.name ? aModel.name : aModel.buddyname;
    
    self.nameAndTypeL.text = [NSString stringWithFormat:@"%@(%@)",name,useType];
    self.phoneNumAndAddressL.text = [NSString stringWithFormat:@"%@(%@)",aModel.phone,[FBCityData cityNameForId:[aModel.province intValue]]];
    
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:[LCWTools headImageForUserId:aModel.uid]] placeholderImage:[UIImage imageNamed:@"detail_test.jpg"]];
}

@end
