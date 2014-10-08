//
//  GMessageSViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GMessageSViewController.h"
#import "GlocalUserImage.h"

@interface GMessageSViewController ()

@end

@implementation GMessageSViewController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%s",__FUNCTION__);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.titleLabel.text = @"消息设置";
    
    //框
    UIView *kuang = [[UIView alloc]initWithFrame:CGRectMake(10, 15, 300, 45)];
    kuang.layer.borderWidth = 0.5;
    kuang.layer.borderColor = [RGBCOLOR(180, 180, 180)CGColor];
    [self.view addSubview:kuang];
    
    //文字titile
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(22, 30, 60, 17)];
    titleLable.text = @"消息提示";
    titleLable.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:titleLable];
    
    
    //开关
    UISwitch *swi = [[UISwitch alloc]initWithFrame:CGRectMake(245, 20, 0, 0)];
    swi.onTintColor = [UIColor orangeColor];
    swi.on = YES;
    [swi addTarget:self action:@selector(onOrOff:) forControlEvents:UIControlEventValueChanged];
    
    self.mySwitch = swi;
    
    
    
    self.mySwitch.on = [GlocalUserImage getMessageOnOrOff];
    
    [self.view addSubview:swi];
    
    
    
    
}



-(void)onOrOff:(UISwitch*)sender{
    
    NSLog(@"---------------%d",sender.on);
    
    if (sender.on) {//开
        NSString *api = [NSString stringWithFormat:FBAUTO_MESSAGE_TYPE,[GMAPI getAuthkey],1];
        NSURL *url = [NSURL URLWithString:api];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            [GlocalUserImage setMessageOnOrOff:YES];
        }];
    }else{//关
        NSString *api = [NSString stringWithFormat:FBAUTO_MESSAGE_TYPE,[GMAPI getAuthkey],2];
        NSURL *url = [NSURL URLWithString:api];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            [GlocalUserImage setMessageOnOrOff:NO];
        }];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
