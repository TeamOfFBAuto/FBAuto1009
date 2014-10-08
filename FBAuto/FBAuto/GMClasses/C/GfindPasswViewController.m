//
//  GfindPasswViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-2.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GfindPasswViewController.h"


#import "GmPrepareNetData.h"

#import "SzkLoadData.h"

@interface GfindPasswViewController ()

@end

@implementation GfindPasswViewController



- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%s",__FUNCTION__);
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UIControl *backControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 320, 568-114)];
    [backControl addTarget:self action:@selector(allShou) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backControl];
    
    //自定义返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui_24_42.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    //    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftBtn.frame = CGRectMake(0, 0, 52, 21);
    UIBarButtonItem *aa = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    UIBarButtonItem * space_button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space_button.width = -27;
    
    self.navigationItem.leftBarButtonItems = @[space_button,aa];
    
    
    self.titleLabel.text = @"找回密码";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    NSArray *titleArray = @[@"手机号",@"验证码",@"新密码"];
    
    //加载视图
    for (int i = 0; i<3; i++) {
        //框
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(10, 25 +i*53, 300, 44)];
        //view.layer.cornerRadius = 4;//设置那个圆角的有多圆
        view1.layer.borderWidth = 0.5;//设置边框的宽度，当然可以不要
        view1.layer.borderColor = [RGBCOLOR(180, 180, 180) CGColor];//设置边框的颜色
        //view.backgroundColor = [UIColor purpleColor];
        view1.userInteractionEnabled = NO;//关掉用户触摸
        [self.view addSubview:view1];
        
        //title
        UILabel *titileLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 42+i*50, 200, 15)];
        titileLabel.font = [UIFont systemFontOfSize:15];
        titileLabel.text = titleArray[i];
        [self.view addSubview:titileLabel];
        
        //content
        UITextField *contentf = [[UITextField alloc]initWithFrame:CGRectMake(70, 42+i*50, 200, 15)];
        [self.view addSubview:contentf];
        if (i == 0) {
            self.phonetf = contentf;
            self.phonetf.keyboardType = UIKeyboardTypePhonePad;
        }else if (i == 1){
            self.yanzhengtf = contentf;
            self.yanzhengtf.keyboardType = UIKeyboardTypePhonePad;
        }else if (i == 2){
            self.passWordtf = contentf;
            self.passWordtf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        }
        
        
    }
    
    //获取验证码
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(10, 180, 300, 50);
    [btn1 setTitle:@"获取验证码" forState:UIControlStateNormal];
    btn1.backgroundColor = RGBCOLOR(149, 149, 149);
    btn1.layer.cornerRadius = 4;
    [btn1 addTarget:self action:@selector(yanzhengma) forControlEvents:UIControlEventTouchUpInside];
    _yanzhengBtn = btn1;
    [self.view addSubview:btn1];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(10, CGRectGetMaxY(btn1.frame)+5, 300, 50);
    [btn2 setTitle:@"重置密码" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor orangeColor];
    btn2.layer.cornerRadius = 4;
    [btn2 addTarget:self action:@selector(zhaohui) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    
    
}

//收键盘
-(void)allShou{
    [self.phonetf resignFirstResponder];
    [self.yanzhengtf resignFirstResponder];
    [self.passWordtf resignFirstResponder];
}

//返回上一个界面
-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

//获取验证码
-(void)yanzhengma{
    if (self.phonetf.text.length != 11) {
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }else{
        _yanzhengBtn.userInteractionEnabled = NO;
        SzkLoadData *szk = [[SzkLoadData alloc]init];
        
        NSString *str = [NSString stringWithFormat:FBAUTO_GET_VERIFICATION_CODE,self.phonetf.text,2];
        NSString *api = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [szk SeturlStr:api block:^(NSArray *arrayinfo, NSString *errorindo, NSInteger errcode) {
            NSLog(@"获取手机验证码%@",errorindo);
            NSLog(@"errcode:%d",errcode);
        }];
        
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changexianshi) userInfo:nil repeats:YES];
        [_timer fire];
        
        _timeNum = 60;
        
        [_yanzhengBtn setTitle:[NSString stringWithFormat:@"%d秒后重新发送",_timeNum] forState:UIControlStateNormal];
    }
    
}



-(void)changexianshi{
    
    
    _timeNum--;
    [_yanzhengBtn setTitle:[NSString stringWithFormat:@"%d秒后重新发送",_timeNum] forState:UIControlStateNormal];
    
    if (_timeNum == 0) {
        [_yanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        _yanzhengBtn.userInteractionEnabled = YES;
    }
    
}




//重置密码
-(void)zhaohui{
    

    
    NSString *str = [NSString stringWithFormat:FBAUTO_MODIFY_FIND_PASSWORD,self.phonetf.text,self.yanzhengtf.text,self.passWordtf.text];
    NSString *api = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:api];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length>0) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                int errcode = [[dic objectForKey:@"errcode"]intValue];
                NSString *errinfo = [dic objectForKey:@"errinfo"];
                NSLog(@"errcode %d",errcode);
                if (errcode !=0) {
                    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:errinfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [al show];
                }else if (errcode == 0){
                    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"重置成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    aler.tag = 2000;
                    [aler show];
                }
            }
        }else{
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
        }
    }];
    
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2000) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
