//
//  CarSourceCell.m
//  FBAuto
//
//  Created by lichaowei on 14-7-16.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "CarSourceCell.h"
#import "CarSourceClass.h"

@implementation CarSourceCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellDataWithModel:(CarSourceClass *)aCar
{
    self.carNameLabel.text = aCar.car_name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@万元",aCar.price];
    self.paramsLabel.text = [NSString stringWithFormat:@"%@%@ 外观%@、内饰%@",aCar.carfrom,aCar.spot_future,aCar.color_out,aCar.color_in];
    self.userAndAddressLabel.text = [NSString stringWithFormat:@"%@(%@)",aCar.username,aCar.usertype];
    self.timeLabel.text = [LCWTools timechange:aCar.dateline];
}

@end
