//
//  GloginViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GloginViewController.h"
#import "GloginView.h"//登录界面view
#import "GzhuceViewController.h"//注册
#import "GfindPasswViewController.h"//找回密码
#import "RCIM.h"
#import "MBProgressHUD.h"
#import "DXAlertView.h"

@interface GloginViewController ()
{
    UIActivityIndicatorView *j;
}

@end

@implementation GloginViewController



-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}


//-(void)viewDidAppear:(BOOL)animated{
//
//    [super viewDidAppear:animated];
//    //隐藏navigationBar
//    self.navigationController.navigationBarHidden = YES;
//
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.button_back.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%s",__FUNCTION__);
    
    GloginView *gloginView = [[GloginView alloc]initWithFrame:CGRectMake(0, 0, 320, iPhone5?568:480)];
    self.gloginView = gloginView;
    [self.view addSubview:gloginView];
    
    gloginView.userTf.text = [LCWTools cacheForKey:LOGIN_PHONE];
    gloginView.passWordTf.text = [LCWTools cacheForKey:LOGIN_PASS];
    
    
    __weak typeof (self)bself = self;
    __weak typeof (gloginView)bgloginView = gloginView;
    
    //设置跳转注册block
    [gloginView setZhuceBlock:^{
        [bgloginView Gshou];
        [bself pushToZhuceVC];
    }];
    
    //设置找回密码block
    [gloginView setFindPassBlock:^{
        [bgloginView Gshou];
        [bself pushToFindPassWordVC];
    }];
    
    //登录
    [gloginView setDengluBlock:^(NSString *usern, NSString *passw) {
        
        NSLog(@"--%@     --%@",usern,passw);
        
        if (usern.length ==0 && passw.length == 0) {
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入用户名和密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
        }else if (usern.length == 0 || passw.length == 0){
            if (usern.length == 0) {
                UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入用户名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [al show];
            }else if (passw.length == 0){
                UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [al show];
            }
        }else{
            [bself dengluWithUserName:usern pass:passw];
        }
        
    }];
    
}

#pragma mark - 登录
-(void)dengluWithUserName:(NSString *)name pass:(NSString *)passw{
    //菊花
    j = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    j.center = CGPointMake(160, 235);
    [self.view addSubview:j];
    [j startAnimating];
    
    NSString *deviceToken = [GMAPI getDeviceToken] ? [GMAPI getDeviceToken] : @"testToken";
    
    NSString *str = [NSString stringWithFormat:FBAUTO_LOG_IN,name,passw,deviceToken];
    
    //保存用户手机号
    [[NSUserDefaults standardUserDefaults]setObject:name forKey:USERPHONENUMBER];
    
    [LCWTools cache:name ForKey:LOGIN_PHONE];
    
    NSLog(@"登录请求接口======%@",str);
    
    __weak typeof(self)weakSelf = self;
    
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSLog(@"error-----------%@",connectionError);

        if ([data length] == 0) {
            return;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@ %@",dic,[dic objectForKey:@"errinfo"]);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if ([[dic objectForKey:@"errcode"] intValue] == 0) {
            
            NSDictionary *datainfo = [dic objectForKey:@"datainfo"];
            NSString *userid = [datainfo objectForKey:@"uid"];
            NSString *username = [datainfo objectForKey:@"name"];
            NSString *authkey = [datainfo objectForKey:@"authkey"];
//            NSString *open = [datainfo objectForKey:@"open"];
            
            [weakSelf loginRongCloudWithUserId:userid name:username headImageUrl:[LCWTools headImageForUserId:userid] pass:passw authkey:authkey];
            
        }else{
            
            [j stopAnimating];
            
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请核对用户名或密码是否正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            
            [defaults setBool:NO forKey:LOGIN_SUCCESS];
        }
        
        [defaults synchronize];
        
    }];
    
    
}

#pragma mark - 融云获取token

- (void)loginRongCloudWithUserId:(NSString *)userId
                            name:(NSString *)name
                    headImageUrl:(NSString *)imageUrl
                            pass:(NSString *)pass
                         authkey:(NSString *)authkey
{
//    userId = [NSString stringWithFormat:@"%@@fbauto",userId];
    
    NSString *url = [NSString stringWithFormat:FBAUTO_RONGCLOUD_TOKEN,userId,name,imageUrl];
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"融云 result%@",result);
        int code = [[result objectForKey:@"code"]integerValue];
        NSString *errorMessage = [result objectForKey:@"errorMessage"];
        
        if (code == 200) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *userId = [result objectForKey:@"userId"];
            NSString *loginToken = [result objectForKey:@"token"];
            
            
            [defaults setObject:userId forKey:USERID];
            [defaults setObject:name forKey:USERNAME];
            [defaults setObject:authkey forKey:USERAUTHKEY];
            [defaults setObject:pass forKey:USERPASSWORD];
            
            [defaults setObject:loginToken forKey:RONGCLOUD_TOKEN];
            
            [LCWTools cache:pass ForKey:LOGIN_PASS];
            
            //mwnrOTV2cDrNDC3SoyiHZfLyOKy7yy366rmw6z+PnBjpWE9XUQNU2Ofso9zhZOEI5WvfXMGOZU/pD+IdsMsjqQ==
            //6YJbgRceE4dxU5fJGoRPP/LyOKy7yy366rmw6z+PnBjpWE9XUQNU2CFs8N6Ox5PsKlHh5ZwuAuLpD+IdsMsjqQ==
            
            
            typeof(self) __weak weakSelf = self;
            [RCIM connectWithToken:loginToken completion:^(NSString *userId) {
                
                NSLog(@"登录成功! %@",userId);
                
                [defaults setBool:YES forKey:LOGIN_SUCCESS];
                
                [j stopAnimating];
                
                [defaults synchronize];
                
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
                
            } error:^(RCConnectErrorCode status) {
                
                [j stopAnimating];
                
                
                NSLog(@"%@",[NSString stringWithFormat:@"登录失败！\n Code: %d！",status]);
                    
                [defaults setBool:NO forKey:LOGIN_SUCCESS];
                
                [defaults synchronize];
                
                
            }];
            
            
        }else
        {
            [j stopAnimating];
            
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:errorMessage contentText:nil leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
            
            alert.rightBlock = ^(){
                NSLog(@"取消");
                
            };
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        
        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
        
    }];

}



#pragma mark - 跳转到注册界面
-(void)pushToZhuceVC{
    GzhuceViewController *gzhuceVc = [[GzhuceViewController alloc]init];
    [self.navigationController pushViewController:gzhuceVc animated:YES];
}

#pragma mark - 跳转找回密码界面
-(void)pushToFindPassWordVC{
    GfindPasswViewController *gfindwVc = [[GfindPasswViewController alloc]init];
    [self.navigationController pushViewController:gfindwVc animated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
