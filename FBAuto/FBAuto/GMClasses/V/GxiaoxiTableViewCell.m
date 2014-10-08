//
//  GxiaoxiTableViewCell.m
//  FBAuto
//
//  Created by gaomeng on 14-7-24.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GxiaoxiTableViewCell.h"

#import "GxiaoxiViewController.h"

@implementation GxiaoxiTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //头像
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
        imageView.backgroundColor = RGBCOLOR(180, 180, 180);
        [self.contentView addSubview:imageView];
        self.headImageView = imageView;

        
        //姓名
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+6, CGRectGetMinY(imageView.frame)+3, 150, 17)];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        
        //时间
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+8, nameLabel.frame.origin.y+4, 92, 13)];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        //内容
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame)+8, 250, 15)];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.font = [UIFont systemFontOfSize:14];
        self.contentLabel = contentLabel;
        [self.contentView addSubview:contentLabel];
        
        //分割线
        UIView *fenView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, 320, 0.5)];
        fenView.backgroundColor = RGBCOLOR(214, 214, 214);
        [self.contentView addSubview:fenView];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}




-(void)configWithData:(XMPPMessageModel *)model{
    
    //头像
    NSString *imageUrlUtf8 = [LCWTools md5:model.fromId];
    NSString *jiequ = [imageUrlUtf8 substringFromIndex:imageUrlUtf8.length-4];
    NSString *str1 = [jiequ substringToIndex:2];
    NSString *str2 = [jiequ substringFromIndex:2];
    
    NSString *headImageUrlStr = [NSString stringWithFormat:@"http://fbautoapp.fblife.com/resource/head/%@/%@/thumb_%@_Thu.jpg",str1,str2,model.fromId];
    NSLog(@"头像url地址   %@",headImageUrlStr);
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]];
    
    
    //时间
    NSString *time1 = [model.time substringWithRange:NSMakeRange(0, 4)];
    NSString *time2 = [model.time substringWithRange:NSMakeRange(5, 2)];
    NSString *time3 = [model.time substringWithRange:NSMakeRange(8, 2)];
    NSString *time = [NSString stringWithFormat:@"%@年%@月%@日",time1,time2,time3];
    self.timeLabel.text = time;
    
    //姓名
    self.nameLabel.text = model.fromName;
    
    //判断是否是图片
    
    NSString *message = model.newestMessage;
    
    if ([message rangeOfString:@"<img height"].length > 0) {
        message = @"你有一条图片消息";
    }
    //内容
    self.contentLabel.text = message;
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
