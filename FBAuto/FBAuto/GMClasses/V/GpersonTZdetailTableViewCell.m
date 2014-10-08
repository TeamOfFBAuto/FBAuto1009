//
//  GpersonTZdetailTableViewCell.m
//  FBAuto
//
//  Created by gaomeng on 14-7-30.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GpersonTZdetailTableViewCell.h"

#import "GtzDetailViewController.h"


#import "UILabel+GautoMatchedText.h"

@implementation GpersonTZdetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




-(void)loadViewWithIndexPath:(NSIndexPath*)indexPath{
    
    if (indexPath.row == 0) {//时间
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        self.timeLabel.font = [UIFont systemFontOfSize:13];
        self.timeLabel.textColor = RGBCOLOR(168, 168, 168);
        self.timeLabel.text = self.delegate.timeStr;
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.timeLabel];
        
        //分割线
        UIView *fenView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 320, 0.5)];
        fenView.backgroundColor = RGBCOLOR(214, 214, 214);
        [self.contentView addSubview:fenView];
        
        
    }else if (indexPath.row == 1){//内容
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.contentLabel.font = [UIFont systemFontOfSize:15];
        self.contentLabel.text = self.delegate.contentStr;
        [self.contentLabel setMatchedFrame4LabelWithOrigin:CGPointMake(25, 22) width:320-22-22];
        [self.contentView addSubview:self.contentLabel];
        
        
        //分割线
        UIView *fenView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame)+22, 320, 0.5)];
        fenView.backgroundColor = RGBCOLOR(214, 214, 214);
        [self.contentView addSubview:fenView];
        
    }
    
}

-(CGFloat)setCellHeight{
    CGFloat height = 0;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = self.delegate.contentStr;
    [label setMatchedFrame4LabelWithOrigin:CGPointMake(25, 22) width:320-22-22];
    height = label.frame.size.height+22+22;
    return height;
}

@end
