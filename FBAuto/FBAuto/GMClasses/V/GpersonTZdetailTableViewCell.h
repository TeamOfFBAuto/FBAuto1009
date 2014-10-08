//
//  GpersonTZdetailTableViewCell.h
//  FBAuto
//
//  Created by gaomeng on 14-7-30.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GtzDetailViewController;

@interface GpersonTZdetailTableViewCell : UITableViewCell


@property(nonatomic,strong)UILabel *timeLabel;//时间
@property(nonatomic,strong)UILabel *contentLabel;//内容
@property(nonatomic,assign)GtzDetailViewController *delegate;

-(void)loadViewWithIndexPath:(NSIndexPath*)indexPath;

-(CGFloat)setCellHeight;

@end
