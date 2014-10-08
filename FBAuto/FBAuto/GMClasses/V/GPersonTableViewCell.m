//
//  GPersonTableViewCell.m
//  FBAuto
//
//  Created by gaomeng on 14-7-7.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GPersonTableViewCell.h"

@implementation GPersonTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}


//block的set方法
-(void)setKuangBlock:(kuangBlock)kuangBlock{
    _kuangBlock = kuangBlock;
}




//加载控件
-(void)loadViewWithIndexPath:(NSIndexPath *)theIndexPatch{
    viewTag++;
    
    //背景框
    self.kuang = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
    self.kuang.layer.borderWidth = 0.5;
    self.kuang.layer.borderColor = [RGBCOLOR(220, 220, 220)CGColor];
    [self.contentView addSubview:self.kuang];
    //设置背景框的tag值
    if (theIndexPatch.section == 0) {
        self.kuang.tag = theIndexPatch.row+1;//1 2 3 4
    }else if (theIndexPatch.section == 1){
        self.kuang.tag = theIndexPatch.row +5;//5 6 7
    }
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gdoTap:)];
    [self.kuang addGestureRecognizer:tap];
    
    //标题lable
    self.titileLabel= [[UILabel alloc]initWithFrame:CGRectMake(22, 14, 60, 17)];
    self.titileLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.titileLabel];
    
    
    //箭头
    UIImageView *jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titileLabel.frame)+210, 18, 5, 9)];
    [jiantou setImage:[UIImage imageNamed:@"jiantou_hui10_18.png"]];
    [self.contentView addSubview:jiantou];
}


//给标题赋值
-(void)dataWithTitleLableWithIndexPath:(NSIndexPath *)theIndexPatch{
    
    if (theIndexPatch.row == 0 && theIndexPatch.section == 0) {
        self.titileLabel.text = @"我的资料";
    }else if (theIndexPatch.row == 1 && theIndexPatch.section == 0){
        self.titileLabel.text = @"我的车源";
    }else if (theIndexPatch.row == 2 && theIndexPatch.section == 0){
        self.titileLabel.text = @"我的求购";
    }else if (theIndexPatch.row == 3 && theIndexPatch.section == 0){
        self.titileLabel.text = @"我的收藏";
    }else if (theIndexPatch.row == 0 && theIndexPatch.section == 1){
        self.titileLabel.text = @"修改密码";
    }else if (theIndexPatch.row == 1 && theIndexPatch.section == 1){
        self.titileLabel.text = @"联系我们";
    }else if (theIndexPatch.row == 2 && theIndexPatch.section == 1){
        self.titileLabel.text = @"消息设置";
    }else if (theIndexPatch.row == 3 && theIndexPatch.section == 1){
        self.titileLabel.text = @"退出登录";
    }
    
}






-(void)gdoTap:(UITapGestureRecognizer *)sender{
    
    if (self.kuangBlock) {
        self.kuangBlock(sender.view.tag);
    }
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
