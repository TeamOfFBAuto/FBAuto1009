//
//  GyhzyTableViewCell.m
//  FBAuto
//
//  Created by gaomeng on 14-7-11.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GyhzyTableViewCell.h"
#import "GuserModel.h"

#import "CarSourceClass.h"

#import "GTimeSwitch.h"

#import "FBCityData.h"

@implementation GyhzyTableViewCell

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





-(CGFloat)loadViewWithIndexPath:(NSIndexPath *)theIndexPath model:(GuserModel*)userModel{
    CGFloat height = 0;
    
    if (theIndexPath.row == 0){//公司名 省份
        //图片
        UIImageView *imaV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
        imaV.backgroundColor = [UIColor grayColor];
        self.touxiangImageView = imaV;
        [self.contentView addSubview:imaV];
        
        //公司全称
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imaV.frame)+10, 14, 240, 15)];
        nameLabel.font = [UIFont systemFontOfSize:14];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        
        //省份
        UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame)+8, 30, 15)];
        titleL.font = [UIFont systemFontOfSize:13];
        titleL.text = @"省份:";
        [self.contentView addSubview:titleL];
        
        UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleL.frame)+7, CGRectGetMaxY(nameLabel.frame)+8, 200, 15)];
        cityLabel.font = [UIFont systemFontOfSize:13];
        cityLabel.textColor = RGBCOLOR(129, 129, 129);
        self.areaLable = cityLabel;
        [self.contentView addSubview:cityLabel];
        
        //高度
        height = 65;
        
    }else if (theIndexPath.row == 1){//电话 地址
        
        //标题lable
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 12, 30, 13)];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.text = @"电话:";
        [self.contentView addSubview:titleLabel];
        
        UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame)+10, 30, 13)];
        titleLabel1.font = [UIFont systemFontOfSize:13];
        titleLabel1.text = @"地址:";
        [self.contentView addSubview:titleLabel1];
        
        //内容label
        
        self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+5, titleLabel.frame.origin.y, 110, titleLabel.frame.size.height)];
        self.phoneLabel.textColor = RGBCOLOR(129, 129, 129);
        self.phoneLabel.font = [UIFont systemFontOfSize:13];
        
        self.dizhiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel1.frame)+5, titleLabel1.frame.origin.y, 260, 14)];
        self.dizhiLabel.font = [UIFont systemFontOfSize:12];
        self.dizhiLabel.text = userModel.address;
        if (self.dizhiLabel.text.length>0) {
            [self.dizhiLabel setMatchedFrame4LabelWithOrigin:CGPointMake(CGRectGetMaxX(titleLabel1.frame)+5, titleLabel1.frame.origin.y) width:260];
        }

        self.dizhiLabel.textColor = RGBCOLOR(129, 129, 129);
        
        
        [self.contentView addSubview:self.phoneLabel];
        [self.contentView addSubview:self.dizhiLabel];
        
        
        
        height = CGRectGetMaxY(self.dizhiLabel.frame);
        
        
    }else if (theIndexPath.row == 2){//简介
        UILabel *titelLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 30, 13)];
        titelLabel.font = [UIFont systemFontOfSize:13];
        titelLabel.text = @"简介:";
        [self.contentView addSubview:titelLabel];
        
        //简介内容label
        self.jianjieLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.jianjieLabel.textColor = RGBCOLOR(149, 149, 149);
        self.jianjieLabel.font = [UIFont systemFontOfSize:12];
        
        [self.contentView addSubview:self.jianjieLabel];
        [self configWithUserModel:userModel];
        
        if (self.jianjieLabel.text.length != 0) {
            height = self.jianjieLabel.frame.size.height +20;
        }else{
            height = CGRectGetMaxY(titelLabel.frame)+10;
        }
        
        
        
    }else if(theIndexPath.row == 3){//在售车源 标题
        UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 60, 12)];
        tLabel.font = [UIFont systemFontOfSize:12];
        tLabel.text = @"在售车源:";
        [self.contentView addSubview:tLabel];
        height = 42;
    }else{
        //车名
        UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 13, 216, 16)];
        
        //tLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        
        self.carNameLabel = tLabel;
        [self.contentView addSubview:tLabel];
        
        //价钱
        UILabel *pLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tLabel.frame)+5, 13, 80, 16)];
        pLabel.font = [UIFont systemFontOfSize:15];
        pLabel.textAlignment = NSTextAlignmentRight;
        pLabel.textColor = [UIColor redColor];
        self.carPriceLabel = pLabel;
        [self.contentView addSubview:pLabel];
        
        //描述1
        self.carClabel1 = [[UILabel alloc]initWithFrame:CGRectMake(tLabel.frame.origin.x, CGRectGetMaxY(tLabel.frame)+9, 48, 13)];
        self.carClabel1.font = [UIFont systemFontOfSize:12];
        self.carClabel1.textColor = RGBCOLOR(129, 129, 129);
        [self.contentView addSubview:self.carClabel1];
        
        //描述2
        self.carClale2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.carClabel1.frame)+9, self.carClabel1.frame.origin.y, self.carClabel1.frame.size.width, self.carClabel1.frame.size.height)];
        self.carClale2.font = [UIFont systemFontOfSize:12];
        self.carClale2.textColor = RGBCOLOR(129, 129, 129);
        [self.contentView addSubview:self.carClale2];
        
        
        
        //商家描述
        self.carUserNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.carClabel1.frame.origin.x, CGRectGetMaxY(self.carClabel1.frame)+9, 250, 14)];
        self.carUserNameLabel.font = [UIFont systemFontOfSize:13];
        self.carUserNameLabel.textColor = RGBCOLOR(129, 129, 129);
        
        [self.contentView addSubview:self.carUserNameLabel];
        
        //时间
        self.carTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.carUserNameLabel.frame)+10, self.carUserNameLabel.frame.origin.y, 40, 14)];
        
        self.carTimeLabel.font = [UIFont systemFontOfSize:13];
        self.carTimeLabel.textAlignment = NSTextAlignmentRight;
        self.carTimeLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.carTimeLabel];
        
        
        height = 84;
    }
    
    return height;
}




-(void)configWithUserModel:(GuserModel*)userModel{
    self.nameLabel.text = userModel.name;
    
    self.phoneLabel.text = userModel.phone;
    self.dizhiLabel.text = userModel.address;
    
    if ([userModel.usertype intValue] == 1) {//个人
        NSString *sheng = [FBCityData cityNameForId:[userModel.province intValue]];
        NSString *shi = [FBCityData cityNameForId:[userModel.city intValue]];
        
        self.areaLable.text = [NSString stringWithFormat:@"%@%@",sheng,shi];
    }else if ([userModel.usertype intValue] == 2){//商家
        NSString *sheng = [FBCityData cityNameForId:[userModel.province intValue]];
        self.nameLabel.text = [NSString stringWithFormat:@"%@（%@）",userModel.name,sheng];
        
        self.areaLable.text = userModel.fullname;
    }
    
    
    self.jianjieLabel.text = userModel.intro;
    [self.jianjieLabel setMatchedFrame4LabelWithOrigin:CGPointMake(45, 10) width:266];
    [self.touxiangImageView sd_setImageWithURL:[NSURL URLWithString:userModel.headimage]];
    
}



-(void)configWithCarModel:(CarSourceClass *)car userModel:(GuserModel*)userModel{
    self.carNameLabel.text = car.car_name;
    self.carPriceLabel.text = [NSString stringWithFormat:@"%@万元",car.price];
    NSString *carfrom = car.carfrom;//汽车版本
    NSString *spot_future = car.spot_future;//现货或期货
    NSString *color_out = [car.color_out substringWithRange:NSMakeRange(0, 1)];//外观颜色
    NSString *color_in = [car.color_in substringWithRange:NSMakeRange(0, 1)];//内饰颜色
    
    self.carClabel1.text = [NSString stringWithFormat:@"%@%@",carfrom,spot_future];
    self.carClale2.text = [NSString stringWithFormat:@"外%@内%@",color_out,color_in];
    NSString *str = nil;
    if ([userModel.usertype intValue] == 1 ) {
        str = @"个人";
    }else if ([userModel.usertype intValue] == 2){
        str = @"商家";
    }
    self.carUserNameLabel.text = [NSString stringWithFormat:@"%@（%@）",userModel.name,str];//商家简介
    
    //时间
    
    NSString *timeStr = [GTimeSwitch testtime:car.dateline];
    self.carTimeLabel.text = [timeStr substringFromIndex:car.dateline.length-5];
    
    
    
}



@end
