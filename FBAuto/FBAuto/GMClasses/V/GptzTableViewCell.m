//
//  GptzTableViewCell.m
//  FBAuto
//
//  Created by gaomeng on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GptzTableViewCell.h"


#import "GTimeSwitch.h"//时间处理类

@implementation GptzTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //内容
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 185, 17)];
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
        self.contentLabel = label;
        self.contentLabel.font = [UIFont systemFontOfSize:15];
        
        //时间
        UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+20, 25, 98, 17)];
        self.timeLabel = lable1;
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentLeft;
        
        
        [self.contentView addSubview:label];
        [self.contentView addSubview:lable1];
        
        
        //分割线
        UIView *fenView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, 320, 0.5)];
        fenView.backgroundColor = RGBCOLOR(180, 180, 180);
        [self.contentView addSubview:fenView];
        
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

@end
