//
//  GlxwmViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GlxwmViewController.h"

@interface GlxwmViewController ()

@end

@implementation GlxwmViewController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel.text = @"联系我们";
    
    //姓名
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 19, 285, 15)];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.text = @"一族（天津）传媒科技有限公司";
    [self.view addSubview:nameLabel];
    
    //地址
    UILabel *dizhiLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(nameLabel.frame)+12, 285, 15)];
    dizhiLabel.font = [UIFont boldSystemFontOfSize:10.5];
    dizhiLabel.text = @"地址：天津经济技术开发区第六大街110号天润科技园B105";
    [self.view addSubview:dizhiLabel];
    
    //邮编
    UILabel *youbianLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(dizhiLabel.frame)+12, 285, 15)];
    youbianLabel.font = [UIFont boldSystemFontOfSize:10.5];
    youbianLabel.text = @"邮编：300457";
    [self.view addSubview:youbianLabel];
    
    //电话
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(youbianLabel.frame)+12, 285, 15)];
    phoneLabel.font = [UIFont boldSystemFontOfSize:10.5];
    phoneLabel.text = @"电话：022 6621 6608";
    [self.view addSubview:phoneLabel];
    
    //传真
    UILabel *chuanzhenLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(phoneLabel.frame)+12, 285, 15)];
    chuanzhenLabel.font = [UIFont boldSystemFontOfSize:10.5];
    chuanzhenLabel.text = @"传真：022 6621 0307";
    [self.view addSubview:chuanzhenLabel];
    
    //地图
    UIImageView *dituImv = [[UIImageView alloc]init];
    if (iPhone5) {
        dituImv.frame = CGRectMake(15, CGRectGetMaxY(chuanzhenLabel.frame)+22, 290, 220);
    }else{
        dituImv.frame = CGRectMake(15, CGRectGetMaxY(chuanzhenLabel.frame)+10, 290, 200);
    }
    
    [dituImv setImage:[UIImage imageNamed:@"ditu572_440.png"]];
    [self.view addSubview:dituImv];
    
    NSLog(@"%s",__FUNCTION__);
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
