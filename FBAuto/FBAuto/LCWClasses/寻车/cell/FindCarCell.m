//
//  FindCarCell.m
//  FBAuto
//
//  Created by lichaowei on 14-7-18.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FindCarCell.h"
#import "CarSourceClass.h"

@implementation FindCarCell

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
    //@"发河北 寻美规 奥迪Q7 14款 豪华"
//    NSString *contentText = [NSString stringWithFormat:@"寻%@",aCar.car_name];
    
    NSString *contentText;
    NSMutableString *car_name = [NSMutableString stringWithString:aCar.car_name];
    NSArray *arr = [car_name componentsSeparatedByString:@" "];
    if (arr.count >= 2) {
        NSString *prefix = [arr objectAtIndex:0];
        [car_name replaceOccurrencesOfString:[NSString stringWithFormat:@"%@ ",prefix] withString:@"" options:0 range:NSMakeRange(0, car_name.length)];
        
        if ([car_name hasPrefix:prefix]) {
            contentText = car_name;
        }else
        {
            contentText = aCar.car_name;
        }
    }else
    {
        contentText = aCar.car_name;
    }
    
    self.contentLabel.text = [NSString stringWithFormat:@"寻%@",contentText];;
    
//    NSString *area = [NSString stringWithFormat:@"发%@%@",aCar.province];
//    
//    if ([area isEqualToString:@"发不限不限"]) {
//        area = @"发不限";
//    }
    NSString *area;
    if ([aCar.province isEqualToString:@"不限"]) {
        area = @"发全国";
    }else
    {
        area = [NSString stringWithFormat:@"发%@",aCar.province];
    }
    
    self.toAddressLabel.text = area;
    
//    self.moneyLabel.text = [self depositWithText:aCar.deposit];
    
    NSString *nameAndType = [NSString stringWithFormat:@"%@(%@)",aCar.username,aCar.usertype];
    
    self.nameLabel.text = nameAndType;
    self.timeLabel.text = [LCWTools timechange:aCar.dateline];
}

- (NSString *)depositWithText:(NSString *)text
{
    if ([text isEqualToString:@"1"]) {
        text = @"定金已付";
    }else if ([text isEqualToString:@"2"])
    {
        text = @"定金未支付";
    }else if ([text isEqualToString:@"0"] || [text isEqualToString:@""])
    {
        text = @"定金不限";
    }
    return text;
}

@end
