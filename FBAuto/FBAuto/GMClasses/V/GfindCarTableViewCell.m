//
//  GfindCarTableViewCell.m
//  FBAuto
//
//  Created by gaomeng on 14-7-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GfindCarTableViewCell.h"

#import "GfindCarViewController.h"

@implementation GfindCarTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGBCOLOR(238, 238, 238);
    }
    return self;
}




-(CGFloat)loadView:(NSIndexPath*)theIndexPath{
    
    NSLog(@"%s",__FUNCTION__);
    CGFloat height = 0;
    
    //多少次浏览
    self.ciLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 18, 75, 13)];

    _ciLable.textAlignment = NSTextAlignmentCenter;
    _ciLable.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_ciLable];
    
//    //浏览
//    UILabel *llLabel = [[UILabel alloc]initWithFrame:CGRectMake(28, CGRectGetMaxY(_ciLable.frame)+4, 24, 13)];
//    llLabel.font = [UIFont systemFontOfSize:12];
//    llLabel.text = @"浏览";
//    [self.contentView addSubview:llLabel];
    
    //白色竖条
    UIView *bview = [[UIView alloc]initWithFrame:CGRectMake(78, 0, 0.5, 60)];
    bview.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bview];
    
    
    //内容label
    self.cLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bview.frame)+20, 15, 158, 15)];
    _cLabel.backgroundColor = [UIColor clearColor];
    _cLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_cLabel];
    
    //时间label
    self.tLabel = [[UILabel alloc]initWithFrame:CGRectMake(_cLabel.frame.origin.x, CGRectGetMaxY(_cLabel.frame)+8, 120, 13)];
    _tLabel.backgroundColor = [UIColor clearColor];
    _tLabel.font = [UIFont systemFontOfSize:13];
    _tLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_tLabel];
    
    
    height = 60;
    
    //操作按钮
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setImage:[UIImage imageNamed:@"jiantou_down18_10.png"] forState:UIControlStateNormal];
    [self.addBtn setImageEdgeInsets:UIEdgeInsetsMake(7.5, 5, 7.5, 5)];
    self.addBtn.frame = CGRectMake(277, 10, 40, 40);
    [self.contentView addSubview:self.addBtn];
    [self.addBtn addTarget:self action:@selector(tianjia) forControlEvents:UIControlEventTouchUpInside];
    
    
    //根据vc的indexPathArray 和 cell高度标示展示cell
    
    if (self.delegate.indexPathArray.count == 2) {//有last 有flag
        
        NSIndexPath *lastIndexPath = self.delegate.indexPathArray[0];
        NSIndexPath *flagIndexPath = self.delegate.indexPathArray[1];
        if (theIndexPath.row == lastIndexPath.row && theIndexPath.section == lastIndexPath.section) {//last的高度给60
            
            height = 60;
            if (_shanchuView) {//如果有删除的view的话 删掉
                [_shanchuView removeFromSuperview];
            }
        }else if (theIndexPath.row == flagIndexPath.row && theIndexPath.section == flagIndexPath.section){//flag的高度给vc的标示高度
            height = self.delegate.flagHeight;
            
            //添加删除view
            [self addSanchuView];
        }
    }else if (self.delegate.indexPathArray.count == 1){//flag 和 last 是同一个
        
        NSIndexPath *flagIndexPath = self.delegate.indexPathArray[0];
        if (theIndexPath.row == flagIndexPath.row && theIndexPath.section == flagIndexPath.section) {
            height = self.delegate.flagHeight;
            if (self.delegate.flagHeight == 60) {
                if (_shanchuView) {
                    [_shanchuView removeFromSuperview];
                }
            }else{
                [self addSanchuView];
            }
            
        }
        
    }
    
    
    
    NSLog(@"%f",height);
    
    if (height == 60) {
        [self.addBtn setImage:[UIImage imageNamed:@"jiantou_down18_10.png"] forState:UIControlStateNormal];
    }else if (height == 120){
        [self.addBtn setImage:[UIImage imageNamed:@"jiantou_up18_10.png"] forState:UIControlStateNormal];
    }
    
    return height;
}

//添加按钮点击方法
-(void)tianjia{
    
    if (self.addviewBlock) {
        self.addviewBlock();
    }
    
    
}

//添加删除界面view
-(void)addSanchuView{
    
    _shanchuView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, 320, 60)];
    
    //图片数组
    UIImage *imag1 = [UIImage imageNamed:@"lajitong44_44.png"];//删除
    UIImage *imag2 = [UIImage imageNamed:@"xiugai32_44.png"];//修改
    UIImage *imag3 = [UIImage imageNamed:@"shuaxin40_44.png"];//刷新
    UIImage *imag4 = [UIImage imageNamed:@"xubxhe_fabu_44_44.png"];//分享
    NSArray *imageArray = @[imag1,imag2,imag3,imag4];
    
    //titile数组
    NSString *t1 = @"删除";
    NSString *t2 = @"修改";
    NSString *t3 = @"刷新";
    NSString *t4 = @"分享";
    NSArray *titleArray = @[t1,t2,t3,t4];
    
    
    for (int i = 0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0+i*80, 0, 80, 60);
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        [btn setImage:imageArray[i] forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(40, 6, 11, 30)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 28, 28, 28)];
        
        
        btn.tag = i+10;
        [btn addTarget:self action:@selector(viewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.backgroundColor = [UIColor blackColor];
        [_shanchuView addSubview:btn];
    }
    _shanchuView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_shanchuView];
}


//操作view上面的btn点击方法
-(void)viewBtnClicked:(UIButton *)sender{
    if (self.caozuoBtnBlock) {
        self.caozuoBtnBlock(sender.tag);
    }
}






-(void)setAddviewBlock:(addViewBlock)addviewBlock{
    _addviewBlock = addviewBlock;
}

-(void)setCaozuoBtnBlock:(caozuoBtnBlock)caozuoBtnBlock{
    _caozuoBtnBlock = caozuoBtnBlock;
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
