//
//  GjjxxViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GjjxxViewController.h"

#import "GmLoadData.h"

@interface GjjxxViewController ()

@end

@implementation GjjxxViewController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.gtype == 3) {//详细地址
        
        self.titleLabel.text = @"详细地址";
    }else if (self.gtype == 4)
    {
        self.titleLabel.text = @"简介";
    }
    
    NSLog(@"%s",__FUNCTION__);
    
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(gsave)];
//    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    UIView *customRbtn = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 42, 23)];
    customRbtn.layer.borderWidth = 0.5f;
    customRbtn.layer.cornerRadius = 4;
    customRbtn.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 42, 23)];
    title.text = @"完成";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:11];
    title.center = customRbtn.center;
    
    [customRbtn addSubview:title];
    UIBarButtonItem *customRightBtn = [[UIBarButtonItem alloc]initWithCustomView:customRbtn];
    
    
    UIBarButtonItem * space_button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space_button.width = -5;
    NSLog(@"%s",__FUNCTION__);
    
    UITapGestureRecognizer *ggsave = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gsave)];
    [customRbtn addGestureRecognizer:ggsave];
    self.navigationItem.rightBarButtonItems = @[space_button,customRightBtn];
    
    
    
    
    //框
    UIView *kuang = [[UIView alloc]initWithFrame:CGRectMake(10, 15, 300, 288)];
    kuang.layer.borderWidth = 0.5;
    kuang.layer.borderColor = [RGBCOLOR(220, 220, 220)CGColor];
    
    
    //输入框textview
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, 280, 288)];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.text = self.lastStr;
    [kuang addSubview:_textView];
    
    
    //添加视图
    [self.view addSubview:kuang];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)gsave{
    NSLog(@"%s",__FUNCTION__);
    //上传详细地址
    [self testDizhi];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 上传地区信息(文本)
-(void)testDizhi{
    if (self.gtype == 3) {//详细地址
        GmLoadData *_test=[[GmLoadData alloc]init];
        
        NSString *dizhi = [_textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //不需要转码
        
//        //转码
//        NSString *dizhiUtf8 = [dizhi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *str = [NSString stringWithFormat:FBAUTO_MODIFY_ADDRESS,[GMAPI getAuthkey],dizhi];
        
        //get
        [_test SeturlStr:str block:^(NSDictionary *dataInfo, NSString *errorinfo, NSInteger errcode) {
            if (errcode == 0) {
                
                NSLog(@"成功");
                //发通知
                [[NSNotificationCenter defaultCenter]postNotificationName:FBAUTO_CHANGEPERSONALINFO object:nil];
            }else{
                
                NSLog(@"修改失败 == %@",errorinfo);
                
            }
        }];
        
        
    }else if (self.gtype == 4){//简介
        
        GmLoadData *_test = [[GmLoadData alloc]init];
        NSString *jianjie = [_textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *str = [NSString stringWithFormat:FBAUTO_MODIFY_JIANJIE,[GMAPI getAuthkey],jianjie];
        //get请求
        [_test SeturlStr:str block:^(NSDictionary *dataInfo, NSString *errorinfo, NSInteger errcode) {
            
            
            if (errcode == 0) {
                NSLog(@"成功");
                //发通知
                [[NSNotificationCenter defaultCenter]postNotificationName:FBAUTO_CHANGEPERSONALINFO object:nil];
            }else{
                NSLog(@"修改失败 == %@",errorinfo);
            }
        }];
    }
    
}



@end
