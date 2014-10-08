//
//  FBFriendCell.m
//  FBAuto
//
//  Created by lichaowei on 14-7-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBFriendCell.h"
#import "FBFriendModel.h"
#import "UIImageView+WebCache.h"
#import "FBCityData.h"

@implementation FBFriendCell

- (void)awakeFromNib
{
    // Initialization code
//    self.bgView.layer.borderWidth = 0.5f;
//    self.bgView.layer.borderColor = [UIColor colorWithHexString:@"b4b4b4"].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickToShare:(id)sender {
    cellBlock(chatWithUser,1);
}

- (IBAction)clickToDial:(id)sender {
    
    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    
}
- (IBAction)clickToChat:(id)sender {
    
    cellBlock(chatWithUser,0);
}

/**
 *  赋值
 */

- (void)getCellData:(FBFriendModel *)aModel cellBlock:(CellBlock)aCellBlock
{
    cellBlock = aCellBlock;
    chatWithUser = aModel.phone;
    phoneNum = aModel.phone;
    
    self.nameLabel.text = aModel.buddyname;
    self.phoneNumLabel.text = aModel.phone;
    self.addressLabel.text = aModel.city_name;
    
    if ([aModel.usertype integerValue] == 1) {
        [self.saleTypeLabel setTitle:@"个人" forState:UIControlStateNormal];
    }else if ([aModel.usertype integerValue] == 2){
        [self.saleTypeLabel setTitle:@"商家" forState:UIControlStateNormal];
    }
    
    
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[LCWTools headImageForUserId:aModel.buddyid]] placeholderImage:[UIImage imageNamed:@"defaultFace"]];
}

@end
