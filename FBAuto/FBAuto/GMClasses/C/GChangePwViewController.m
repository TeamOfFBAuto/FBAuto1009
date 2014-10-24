//
//  GChangePwViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//个人中心点击修改密码跳转的页面
#import "GChangePwViewController.h"

#import "GmLoadData.h"//网络请求类


#import "GlocalUserImage.h"

#import "AppDelegate.h"

@interface GChangePwViewController ()

@end

@implementation GChangePwViewController


-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel.text = @"密码修改";
    
    self.tfArray = [NSMutableArray arrayWithCapacity:1];
    
    NSLog(@"%s",__FUNCTION__);
    
    //点击回收键盘
    UIControl *backControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [backControl addTarget:self action:@selector(Gshou) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backControl];
    
    
    
    //框
    for (int i = 0; i<2; i++) {
        UIView *kuang = [[UIView alloc]initWithFrame:CGRectMake(10, 25+i*54, 300, 44)];
        kuang.layer.borderColor = [RGBCOLOR(180, 180, 180)CGColor];
        kuang.layer.borderWidth = 0.5;
        [self.view addSubview:kuang];
    }
    
    //titile
    NSArray *titleArray = @[@"新    密   码",@"重复新密码"];
    for (int i = 0; i<2; i++) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 38+i*52, 50, 18)];
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 38+i*52, 200, 18)];
        tf.secureTextEntry = YES;
        
//        if (i ==1) {
            titleLabel.frame = CGRectMake(15, 38+i*52, 80, 18);
            
            tf.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame), 38+i*52, 200, 18);
            
//        }
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = titleArray[i];
        
        [self.tfArray addObject:tf];
        
        [self.view addSubview:titleLabel];
        [self.view addSubview:tf];
    }
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"修改" forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.frame = CGRectMake(10, 160, 300, 50);
    [btn addTarget:self action:@selector(xiugai) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    
    
}


//收键盘
-(void)Gshou{
    for (UITextField *tf in self.tfArray) {
        [tf resignFirstResponder];
    }
}

//修改按钮
-(void)xiugai{
    NSLog(@"%s",__FUNCTION__);
    UITextField *nTf = self.tfArray[0];//新密码tf
    UITextField *nTf1 = self.tfArray[1];//新密码tf1
    //NSString *oldPs = [GMAPI getUserPassWord];//老密码
    
    if (nTf.text.length == 0) {
        
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入新的密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
        return;
    }
    
    if ([nTf.text isEqualToString:nTf1.text]) {
        [self testWithNewPsw:nTf.text];
    }else{
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次输入内容不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }
    
    
}

-(void)testWithNewPsw:(NSString *)pw{
    NSString *newPassWord = [pw stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    GmLoadData *_test=[[GmLoadData alloc]init];
    NSString *str = [NSString stringWithFormat:FBAUTO_MODIFY_PASSWORD,[GMAPI getAuthkey],newPassWord,[GMAPI getUserPhoneNumber]];
    NSLog(@"修改密码 %@",str);
    
    //get
    [_test SeturlStr:str block:^(NSDictionary *dataInfo, NSString *errorinfo, NSInteger errcode) {
        
        NSLog(@"dataInfo %@errorinfo %@",dataInfo,errorinfo);
        
        if (errcode == 0) {
            
            
            NSLog(@"修改密码成功");
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改密码成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            al.tag = 1000;
            [al show];
            
//            [LCWTools cache:@"" ForKey:LOGIN_PASS];
            
//            PersonalViewController *personal = (PersonalViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).perSonalVC;
//            [personal tuichuDenglu];
            
        }else{
            
            NSLog(@"修改密码失败 == %@",errorinfo);
            
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"新密码与旧密码相同" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
        }
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        NSString *api = [NSString stringWithFormat:FBAUTO_LOG_OUT,[GMAPI getUid]];
        NSLog(@"%@",api);
        
        NSURL *url = [NSURL URLWithString:api];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        //清除UserDefaults里的数据
        NSUserDefaults *standUDef=[NSUserDefaults standardUserDefaults];
        [standUDef setObject:@""  forKey:USERAUTHKEY];
        [standUDef setObject:@""  forKey:USERID];
        [standUDef setObject:@""  forKey:USERNAME];
        [standUDef setObject:NO forKey:@"switchOnorOff"];
        
        [standUDef setBool:NO forKey:LOGIN_SUCCESS];
        
        [LCWTools cache:@"" ForKey:LOGIN_PASS];
        
        [standUDef synchronize];
        
        NSLog(@"authkey===%@",[GMAPI getAuthkey]);
        
        //清除沙盒里的数据
        
        //上传标志位
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"gIsUpFace"];
        
        //document路径
        NSString *documentPathStr = [GlocalUserImage documentFolder];
        NSString *userFace = @"/guserFaceImage.png";
        
        //文件管理器
        NSFileManager *fileM = [NSFileManager defaultManager];
        
        //清除 头像和 banner
        [fileM removeItemAtPath:[documentPathStr stringByAppendingString:userFace] error:nil];
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError==0) {
                NSLog(@"成功");
                
            }else{
                NSLog(@"xxssx===%@",connectionError);
            }
        }];
        
        [[RCIM sharedRCIM] disconnect:NO];
        
        self.tabBarController.selectedIndex = 0;
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
