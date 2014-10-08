//
//  GmarkTableViewCell.m
//  FBAuto
//
//  Created by gaomeng on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GmarkTableViewCell.h"

#import "GmarkViewController.h"

#import "CarSourceClass.h"//数据Model类

@implementation GmarkTableViewCell

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


-(void)setDelImvClickedBlock:(DelImvClickedBlock)delImvClickedBlock{
    _delImvClickedBlock = delImvClickedBlock;
}


//加载视图 填充数据 并返回单元格高度
-(CGFloat)loadViewWithIndexPath:(NSIndexPath*)theIndexPatch{
    CGFloat height = 0;
    self.contentView.backgroundColor = RGBCOLOR(238, 238, 238);
    
    //白色竖条
    _DelWhView = [[UIView alloc]initWithFrame:CGRectMake(90, 0, 0.5, 60)];
    _DelWhView.backgroundColor = [UIColor whiteColor];
    
    _noDelWhView = [[UIView alloc]initWithFrame:CGRectMake(50, 0, 0.5, 60)];
    _noDelWhView.backgroundColor = [UIColor whiteColor];
    
    //车源分类titleLabel
    UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 24, 25, 13)];
    
    tLabel.font = [UIFont systemFontOfSize:12];
    tLabel.textColor = RGBCOLOR(129, 129, 129);
    self.tLabel = tLabel;
    
    //车源信息
    UILabel *cLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 23, 240, 14)];
    cLabel.font = [UIFont systemFontOfSize:13];
    self.cLabel = cLabel;
    
    
    
    
    
    
    //添加视图
    [self.contentView addSubview:_DelWhView];
    [self.contentView addSubview:_noDelWhView];
    [self.contentView addSubview:tLabel];
    [self.contentView addSubview:cLabel];
    
    NSLog(@" delegate  ----- %d",self.delegate.delType);
    
    //白色竖线
    if (self.delegate.delType == 2) {//不是删除
        _DelWhView.hidden = YES;
        _noDelWhView.hidden = NO;
        tLabel.frame = CGRectMake(15, 24, 25, 13);
    }else if (self.delegate.delType == 3){//删除
        _noDelWhView.hidden = YES;
        _DelWhView.hidden = NO;
        tLabel.frame = CGRectMake(52, 24, 25, 13);
        cLabel.frame = CGRectMake(105, 23, 200, 14);
        
        
        //添加选择图标
        self.clickImv = [[UIImageView alloc]initWithFrame:CGRectMake(18, 20, 20, 20)];
        self.clickImv.userInteractionEnabled = YES;
        self.clickImv.tag = theIndexPatch.row;
        [self.clickImv setImage:[UIImage imageNamed:@"xuanze_up_44_44.png"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap:)];
        //        [self.clickImv addGestureRecognizer:tap];
        
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 60)];
        backView.userInteractionEnabled = YES;
        backView.tag = theIndexPatch.row;
        [backView addSubview:self.clickImv];
        [backView addGestureRecognizer:tap];
        
        
        
        [self.contentView addSubview:backView];
    }
    
    
    height = 60;
    return height;
}

//选择是否删除的点击方法
-(void)doTap:(UITapGestureRecognizer *)sender{
    NSLog(@"%ld",(long)sender.view.tag);
    if (self.delImvClickedBlock) {
        self.delImvClickedBlock(sender.view.tag);
    }
}



//填充数据
-(void)configWithNetData:(NSArray *)array indexPath:(NSIndexPath*)theIndexPath{
    CarSourceClass *aCar = array[theIndexPath.row];
    self.tLabel.text = aCar.stype_name;
    self.cLabel.text = aCar.car_name;
    
}

@end
