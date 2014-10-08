//
//  GperInfoTableViewCell.m
//  FBAuto
//
//  Created by gaomeng on 14-7-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GperInfoTableViewCell.h"
#import "GperInfoViewController.h"

#import "GjjxxViewController.h"//简介 和 详细的界面

#import "GlocalUserImage.h"

#import "UIImageView+AFNetworking.h"



@implementation GperInfoTableViewCell

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
}



-(void)setUserFaceBlock:(userFaceBlock)userFaceBlock{
    _userFaceBlock = userFaceBlock;
}




//加载控件并返回高度
-(CGFloat)loadViewWithIndexPath:(NSIndexPath*)theIndexPath{
    CGFloat height = 0;
    
    
    NSArray *titleArray = @[@"姓名",@"地区",@"手机号",@"详细地址",@"简介"];
    
    
    
    if (theIndexPath.section == 0) {//头像
        
        height = 95;
        
        //框
        UIButton *kuang = [[UIButton alloc]initWithFrame:CGRectMake(10, 15, 300, 64)];
        kuang.layer.borderWidth = 0.5;
        kuang.layer.borderColor = [RGBCOLOR(220, 220, 220)CGColor];
        [kuang addTarget:self action:@selector(gtouxiang) forControlEvents:UIControlEventTouchUpInside];
        
        
        //title
        UILabel *titielLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 40, 30, 15)];
        titielLabel.font = [UIFont systemFontOfSize:15];
        titielLabel.text = @"头像";
        
        //头像imageview
        UIImageView *touxiangImv = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titielLabel.frame)+187, 25, 45, 45)];
        touxiangImv.backgroundColor = RGBCOLOR(180, 180, 180);
        
        if ([GlocalUserImage getUserFaceImage]) {
            touxiangImv.image = [GlocalUserImage getUserFaceImage];
        }else{
            [touxiangImv sd_setImageWithURL:[NSURL URLWithString:self.delegate.headimage] placeholderImage:[UIImage imageNamed:@"defaultFace"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSData *data = UIImageJPEGRepresentation(image, 0.5);
                [GlocalUserImage setUserFaceImageWithData:data];
            }];
        }
        
        
        //箭头
        UIImageView *jiantou = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiantou_hui10_18.png"] highlightedImage:nil];
        jiantou.frame = CGRectMake(CGRectGetMaxX(touxiangImv.frame)+10, 42, 5, 8);
        
        
        
        
        //添加视图
        [self.contentView addSubview:kuang];
        [self.contentView addSubview:titielLabel];
        [self.contentView addSubview:touxiangImv];
        [self.contentView addSubview:jiantou];
        
        
    }else if (theIndexPath.section == 1){//详细信息
        
        height = 44;
        
        //框
        UIButton *kuang = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
        kuang.layer.borderWidth = 0.5;
        kuang.layer.borderColor = [RGBCOLOR(220, 220, 220)CGColor];
        
        //遮挡底部边框重合的部分
        UIView *diview = [[UIView alloc]initWithFrame:CGRectMake(10, 44, 300, 0.5)];
        diview.backgroundColor = [UIColor whiteColor];
        
        //title
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(22, 15, 60, 15)];
        titleLable.font = [UIFont systemFontOfSize:15];
        titleLable.text = titleArray[theIndexPath.row];
        
        
        //内容label
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLable.frame)+30, titleLable.frame.origin.y-3, 190, titleLable.frame.size.height+6)];
        contentLabel.textAlignment = NSTextAlignmentRight;
        contentLabel.textColor = RGBCOLOR(129, 129, 129);
        contentLabel.font = [UIFont systemFontOfSize:15];
        
        
        
        if (theIndexPath.row == 0) {//姓名
            contentLabel.text = self.delegate.userName;
        }else if (theIndexPath.row == 1){//地区
            contentLabel.text = self.delegate.area;
        }else if (theIndexPath.row == 2){//电话
            contentLabel.text = self.delegate.phoneNum;
        }else if (theIndexPath.row == 3){//详细地址
            contentLabel.frame =CGRectMake(CGRectGetMaxX(titleLable.frame)+30, titleLable.frame.origin.y-3, 175, titleLable.frame.size.height+6);
            UIImageView *jiantou = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiantou_hui10_18.png"]];
            jiantou.frame = CGRectMake(CGRectGetMaxX(contentLabel.frame)+10, 18, 5, 8);
            contentLabel.text = self.delegate.address;
            [self.contentView addSubview:jiantou];
        }else if (theIndexPath.row == 4){//简介
            contentLabel.frame =CGRectMake(CGRectGetMaxX(titleLable.frame)+30, titleLable.frame.origin.y-3, 175, titleLable.frame.size.height+6);
            UIImageView *jiantou = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiantou_hui10_18.png"]];
            jiantou.frame = CGRectMake(CGRectGetMaxX(contentLabel.frame)+10, 18, 5, 8);
            [self.contentView addSubview:jiantou];
            contentLabel.text = self.delegate.jianjie;
        }
        
        
        
        //添加视图
        [self.contentView addSubview:kuang];
        [self.contentView addSubview:titleLable];
        [self.contentView addSubview:diview];
        [self.contentView addSubview:contentLabel];
        
        
        //功能
        if (theIndexPath.row == 3 || theIndexPath.row == 4) {//详细地址 简介
            if (theIndexPath.row == 3) {//详细地址
                kuang.tag = 3;
                [kuang addTarget:self action:@selector(tui:) forControlEvents:UIControlEventTouchUpInside];
            }else if (theIndexPath.row == 4){//简介
                kuang.tag = 4;
                [kuang addTarget:self action:@selector(tui:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        
        
    }
    
    return height;
}




//简介 和 详细信息 推的界面
-(void)tui:(UIButton *)sender{
    GjjxxViewController *aaa = [[GjjxxViewController alloc]init];
    if (sender.tag == 3) {//详细地址
        aaa.lastStr = [NSString stringWithFormat:@"%@",self.delegate.address];
    }else if (sender.tag == 4){//简介
        aaa.lastStr = [NSString stringWithFormat:@"%@",self.delegate.jianjie];
    }
    aaa.gtype = (int)sender.tag;
    [self.delegate.navigationController pushViewController:aaa animated:YES];
}


//点击头像的方法
-(void)gtouxiang{
    if (self.userFaceBlock) {
        self.userFaceBlock();
    }
}


@end
