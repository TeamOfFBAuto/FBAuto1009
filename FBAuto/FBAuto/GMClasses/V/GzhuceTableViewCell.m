//
//  GzhuceTableViewCell.m
//  FBAuto
//
//  Created by gaomeng on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GzhuceTableViewCell.h"
#import "GuserZhuce.h"

#import "SzkLoadData.h"

#import "GzhuceViewController.h"

#import "FBCityData.h"


#import "GmPrepareNetData.h"

@implementation GzhuceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configViewWithType:reuseIdentifier];
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



//根据type加载控件
-(void)configViewWithType:(NSString *)theType{
    if ([theType isEqualToString:@"geren"]) {//个人注册================================================
        //分配内存
        self.contenTfArray = [NSMutableArray arrayWithCapacity:1];
        
        //标题数组
        _titielArray = @[@"姓名",@"地区",@"密码",@"重复密码",@"手机",@"验证码"];
        
        //注册界面的view
        self.zhuceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,  568-114)];
        //self.zhuceView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.zhuceView];
        
        //点击回收键盘
        UIControl *backControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 320, 568-114)];
        [backControl addTarget:self action:@selector(allShou) forControlEvents:UIControlEventTouchDown];
        [self.zhuceView addSubview:backControl];
        
        for (int i = 0; i<6; i++) {
            //框
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 5+i*55, 300, 44)];
            //view.layer.cornerRadius = 4;//设置那个圆角的有多圆
            view.layer.borderWidth = 0.5;//设置边框的宽度，当然可以不要
            view.layer.borderColor = [RGBCOLOR(180, 180, 180) CGColor];//设置边框的颜色
            //view.backgroundColor = [UIColor purpleColor];
            view.userInteractionEnabled = NO;//关掉用户触摸
            [self.zhuceView addSubview:view];
            //验证码
            if (i == 5) {
                view.frame = CGRectMake(10, 5+i*55, 194, 45);
                view.layer.borderWidth = 0.5;
                view.layer.borderColor = [RGBCOLOR(180, 180, 180) CGColor];//设置边框的颜色
                [self.zhuceView addSubview:view];
                
            }
            
            
            //titile
            UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 20+i*55, 30, 15)];
            if (i == 3) {//重复密码
                titleLable.frame = CGRectMake(20, 20+i*55, 60, 15);
            }else if (i == 5){//验证码
                titleLable.frame = CGRectMake(20, 20+i*55, 45, 15);
            }
            titleLable.font = [UIFont systemFontOfSize:15];
            titleLable.text = _titielArray[i];
            [self.zhuceView addSubview:titleLable];
            
            
            //输入内容 根据响应者链 需要关掉框view的用户触摸 并把contentTf加到self.view上
            UITextField *contentTf = [[UITextField alloc]initWithFrame:CGRectMake(55, 20+i*55, 230, 15)];
            contentTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
            contentTf.font = [UIFont systemFontOfSize:15];
            contentTf.tag = 10+i;//根据tag判读是哪个tf
            contentTf.delegate = self;
            NSLog(@"%@",NSStringFromCGRect(contentTf.frame));
            if (i == 3) {//重复密码
                contentTf.frame = CGRectMake(85, 20+i*55, 200, 15);
            }else if (i == 5){//验证码
                contentTf.frame = CGRectMake(70, 20+i*55, 130, 15);
                _yanzhengBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _yanzhengBtn.frame = CGRectMake(CGRectGetMaxX(contentTf.frame)+10+4, contentTf.frame.origin.y-14, 95, 45);
                [_yanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                _yanzhengBtn.tag = 70;
                [_yanzhengBtn addTarget:self action:@selector(yanzheng:) forControlEvents:UIControlEventTouchUpInside];
                _yanzhengBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [_yanzhengBtn setBackgroundImage:[UIImage imageNamed:@"yanzhengma_bg194_90.png"] forState:UIControlStateNormal];
                [self.contentView addSubview:_yanzhengBtn];
            }
            
            
            if (i == 1) {
                
                NSString *province = self.delegate.province;
                NSString *city = self.delegate.city;
                NSString *area = [province stringByAppendingString:city];
                
                NSLog(@"------------- %@",area);
                
                contentTf.text = area;
            }
            
            
            [self.contentView addSubview:contentTf];
            
            
            
            
            
            if (i == 2 || i == 3) {//密码
                contentTf.keyboardType = UIKeyboardTypeASCIICapable;
            }
            
            if (i == 4) {//手机
                contentTf.keyboardType = UIKeyboardTypeNumberPad;
            }
            
            //把contentTf装到数组里
            [self.contenTfArray addObject:contentTf];
            
        }
        
        
        
        
        
        //提交
        UIButton *tijiaoBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 340, 300, 50)];
        tijiaoBtn.layer.cornerRadius = 4;
        tijiaoBtn.backgroundColor = [UIColor orangeColor];
        [tijiaoBtn setTitle:@"提交" forState:UIControlStateNormal];
        tijiaoBtn.tag = 100;
        [tijiaoBtn addTarget:self action:@selector(tijiaoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.zhuceView addSubview:tijiaoBtn];
        
    }else if ([theType isEqualToString:@"shangjia"]){//商家注册==========================================
        //非配内存
        self.contentTfArray1 = [[NSMutableArray alloc]init];
        
        //标题数组
        _titielArray = @[@"公司全称",@"公司简称",@"地区",@"详细地址",@"密码",@"重复密码",@"手机",@"验证码"];
        
        //注册界面的view
        self.zhuceView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568-68)];
        [self.contentView addSubview:self.zhuceView1];
        
        //点击回收键盘
        UIControl *backControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 320, 568-114)];
        [backControl addTarget:self action:@selector(allShou) forControlEvents:UIControlEventTouchDown];
        [self.zhuceView1 addSubview:backControl];
        
        for (int i = 0; i<8; i++) {
            //框
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 5+i*55, 300, 44)];
            //view.layer.cornerRadius = 4;//设置那个圆角的有多圆
            view.layer.borderWidth = 0.5;//设置边框的宽度，当然可以不要
            view.layer.borderColor = [RGBCOLOR(180, 180, 180) CGColor];//设置边框的颜色
            //view.backgroundColor = [UIColor purpleColor];
            view.userInteractionEnabled = NO;//关掉用户触摸
            [self.zhuceView1 addSubview:view];
            //验证码
            if (i == 7) {
                view.frame = CGRectMake(10, 5+i*55, 194, 45);
                view.layer.borderWidth = 0.5;
                view.layer.borderColor = [RGBCOLOR(180, 180, 180) CGColor];//设置边框的颜色
                [self.zhuceView1 addSubview:view];
                
            }
            
            
            //titile
            UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 20+i*55, 30, 15)];
            if (i == 5 || i ==0 || i==1 || i == 3) {//重复密码 公司全称 公司简介 详细地址
                titleLable.frame = CGRectMake(20, 20+i*55, 60, 15);
            }else if (i == 7){//验证码
                titleLable.frame = CGRectMake(20, 20+i*55, 45, 15);
            }
            titleLable.font = [UIFont systemFontOfSize:15];
            titleLable.text = _titielArray[i];
            [self.zhuceView1 addSubview:titleLable];
            
            
            //输入内容 根据响应者链 需要关掉框view的用户触摸 并把contentTf加到self.view上
            UITextField *contentTf = [[UITextField alloc]initWithFrame:CGRectMake(55, 20+i*55, 230, 15)];
            contentTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
            contentTf.font = [UIFont systemFontOfSize:15];
            contentTf.delegate = self;
            contentTf.tag = 20+i;//根据tag判读是哪个tf
            NSLog(@"%@",NSStringFromCGRect(contentTf.frame));
            if (i == 5 || i ==0 || i==1 || i == 3) {//重复密码 公司全称 公司简介
                contentTf.frame = CGRectMake(85, 20+i*55, 200, 15);
            }else if (i == 7){//验证码
                contentTf.frame = CGRectMake(70, 20+i*55, 130, 15);
                _yanzhengBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
                _yanzhengBtn1.frame = CGRectMake(CGRectGetMaxX(contentTf.frame)+10+4, contentTf.frame.origin.y-14, 95, 45);
                [_yanzhengBtn1 setTitle:@"获取验证码" forState:UIControlStateNormal];
                _yanzhengBtn1.tag = 71;
                [_yanzhengBtn1 addTarget:self action:@selector(yanzheng:) forControlEvents:UIControlEventTouchUpInside];
                _yanzhengBtn1.titleLabel.font = [UIFont systemFontOfSize:14];
                [_yanzhengBtn1 setBackgroundImage:[UIImage imageNamed:@"yanzhengma_bg194_90.png"] forState:UIControlStateNormal];
                [self.contentView addSubview:_yanzhengBtn1];
            }
            
            
            
            [self.contentView addSubview:contentTf];
            
            
            
            
            if (i == 4 || i == 5) {
                contentTf.keyboardType = UIKeyboardTypeASCIICapable;
            }
            
            if (i == 6) {
                contentTf.keyboardType = UIKeyboardTypeNumberPad;
            }
            
            
            //把contentTf装到数组里
            [self.contentTfArray1 addObject:contentTf];
            
        }
        
        
        
        //提交
        UIButton *tijiaoBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 450, 300, 50)];
        tijiaoBtn.layer.cornerRadius = 4;
        tijiaoBtn.backgroundColor = [UIColor orangeColor];
        tijiaoBtn.tag = 101;
        [tijiaoBtn setTitle:@"提交" forState:UIControlStateNormal];
        [tijiaoBtn addTarget:self action:@selector(tijiaoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.zhuceView1 addSubview:tijiaoBtn];
        
        
    }
    
    
    
    
    
    

    
    
    
    
}



//收键盘
-(void)allShou{
    NSLog(@"==========================");
    for (UITextField *tf in self.contenTfArray) {
        [tf resignFirstResponder];
    }
    
    for (UITextField *tf in self.contentTfArray1) {
        [tf resignFirstResponder];
    }
    
    if (self.shouTablevBlock) {
        self.shouTablevBlock();
    }
    
    
    
    
}



//验证短信
-(void)yanzheng:(UIButton *)sender{
    
    
    if (sender.tag == 70) {//个人短信验证
        UITextField *tf = self.contenTfArray[4];
        if (tf.text.length <11) {//判断手机号是否正确
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
        }else{
            _yanzhengBtn.userInteractionEnabled = NO;
            
            
            NSLog(@"%@",tf.text);
            
            
            
            NSString *str = [NSString stringWithFormat:FBAUTO_GET_VERIFICATION_CODE,tf.text,1];
            
            
            NSLog(@"手机验证码请求地址:%@",str);
            
            NSURL *url = [NSURL URLWithString:str];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
                if (data.length == 0) {
                    return ;
                }
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSString *errinfo = [dic objectForKey:@"errinfo"];
                NSString *errcode = [dic objectForKey:@"errcode"];
                if ([errcode intValue] != 0) {
                    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:errinfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [al show];
                }
                
                NSLog(@"%@ %@",dic,errinfo);
                
            }];
            
            NSLog(@"%s",__FUNCTION__);
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeBtnTitle) userInfo:nil repeats:YES];
            [_timer fire];
            
            _timeNum = 60;
            
            [_yanzhengBtn setTitle:[NSString stringWithFormat:@"%d秒后重新发送",_timeNum] forState:UIControlStateNormal];
        }
        
        
    }else if(sender.tag == 71){//商家短信验证
        
        
        UITextField *tf = self.contentTfArray1[6];
        if (tf.text.length < 11) {
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
        }else{
            
            
            NSLog(@"%@",tf.text);
            
            
            _yanzhengBtn1.userInteractionEnabled = NO;
            NSString *str = [NSString stringWithFormat:FBAUTO_GET_VERIFICATION_CODE,tf.text,2];
            
            NSLog(@"%@",str);
            NSURL *url = [NSURL URLWithString:str];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (data.length == 0) {
                    return ;
                }
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSString *errinfo = [dic objectForKey:@"errinfo"];
                NSString *errcode = [dic objectForKey:@"errcode"];
                if ([errcode intValue] != 0) {
                    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:errinfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [al show];
                }
                
                NSLog(@"%@ %@",dic,errinfo);
            }];
            
            NSLog(@"%s",__FUNCTION__);
            _timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeBtnTitle1) userInfo:nil repeats:YES];
            [_timer1 fire];
            _timeNum1 = 60;
            [_yanzhengBtn1 setTitle:[NSString stringWithFormat:@"%d秒后重新发送",_timeNum1] forState:UIControlStateNormal];
        }
        
    }
    
    
    
    
    
    
}


-(void)changeBtnTitle{//个人
    
    
    
    _yanzhengBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _timeNum--;
    [_yanzhengBtn setTitle:[NSString stringWithFormat:@"%d秒后重新发送",_timeNum] forState:UIControlStateNormal];
    
    if (_timeNum == 0) {
        [_yanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        _yanzhengBtn.userInteractionEnabled = YES;
    }
}

-(void)changeBtnTitle1{//商家
    _yanzhengBtn1.userInteractionEnabled = NO;
    _yanzhengBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
    _timeNum1--;
    [_yanzhengBtn1 setTitle:[NSString stringWithFormat:@"%d秒后重新发送",_timeNum1] forState:UIControlStateNormal];
    
    if (_timeNum1 == 0) {
        [_yanzhengBtn1 setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer1 invalidate];
        _yanzhengBtn1.userInteractionEnabled = YES;
    }
}

#pragma mark-判断各个是否为空

-(BOOL)indoGeren{
    BOOL panduan = YES;
    for (UITextField *tf in self.contenTfArray) {
        if (tf.text.length == 0) {
            panduan = NO;
        }
    }
    
    return panduan;
}

-(BOOL)indoShangjia{
    BOOL panduan = YES;
    for (UITextField *tf in self.contentTfArray1) {
        if (tf.text.length == 0) {
            panduan = NO;
        }
    }
    
    return panduan;
}

#pragma mark - 提交
-(void)tijiaoBtnClicked:(UIButton *)sender{
    
    [self allShou];
    
    if (sender.tag == 100) {//个人提交
        
        if (![self indoGeren]) {
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"请完善信息" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            return;
        };
        
        GuserZhuce *guerzhuce = [[GuserZhuce alloc]init];
        guerzhuce.province = self.province;
        guerzhuce.city = self.city;
        guerzhuce.token = [[NSUserDefaults standardUserDefaults]objectForKey:DEVICETOKEN];
        UITextField *tf = nil;
        
        for (int i = 0; i<6; i++) {
            tf = self.contenTfArray[i];
            if (i == 4) {//手机
                guerzhuce.phone = tf.text;
            }else if (i == 2){//密码
                guerzhuce.password = tf.text;
            }else if(i == 5){//验证码
                guerzhuce.code = tf.text;
            }else if (i == 0){//用户名
                guerzhuce.name = tf.text;
            }else if (i == 3){
                guerzhuce.password1 = tf.text;
            }
        }
        
        
        
        if (guerzhuce.password.length<6) {//密码不能小于六位
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码长度不能少于6位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            return;
        }
        
        if ([guerzhuce.password isEqualToString:guerzhuce.password1] && [self indoGeren]) {//没问题 请求注册接口
            _hud = [GMAPI showMBProgressWithText:@"正在提交" addToView:self.contentView];
            _hud.delegate = self;
            NSString *str = [NSString stringWithFormat:FBAUTO_REGISTERED,guerzhuce.phone,guerzhuce.password,guerzhuce.name,(long)guerzhuce.province,(long)guerzhuce.city,1,guerzhuce.code,guerzhuce.token,@""];
            
            NSLog(@"个人注册接口:%@",str);
            
            NSString *api = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:api];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (data.length > 0) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        int erroCode = [[dic objectForKey:@"errcode"]intValue];
                        NSString *erroInfo = [dic objectForKey:@"errinfo"];
                        NSLog(@"个人注册接口 errcode:%d",erroCode);
                        NSLog(@"个人注册接口 错误信息:%@",erroInfo);
                        if (erroCode !=0) {
                            [self hudWasHidden:_hud];
                            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:erroInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [al show];
                        }else if (erroCode == 0){
                            [self hudWasHidden:_hud];
                            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:erroInfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            al.tag = 133;
                            [al show];
                        }
                        
                    }
                    
                }else{
                    [self hudWasHidden:_hud];
                    NSLog(@"data 为空 connectionError %@",connectionError);
                    
                    NSString *errInfo = @"网络有问题,请检查网络";
                    switch (connectionError.code) {
                        case NSURLErrorNotConnectedToInternet:
                            errInfo = @"无网络连接";
                            break;
                        case NSURLErrorTimedOut:
                            errInfo = @"网络连接超时";
                            break;
                        default:
                            break;
                    }
                    
                }
            }];
            
            
            
            
        }else if (![guerzhuce.password isEqualToString:guerzhuce.password1]){//密码不一致
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"重复密码和密码填写不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
        }
        
        
        
        
        
        
    }else if (sender.tag == 101){//商家提交
        if (![self indoShangjia]) {
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"请完善信息" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            return;
        }
        GuserZhuce *userzc = [[GuserZhuce alloc]init];
        userzc.province = self.province1;
        userzc.city = self.city1;
        userzc.token = [[NSUserDefaults standardUserDefaults]objectForKey:DEVICETOKEN];;
        
        UITextField *tf = nil;
        for (int i = 0; i<8; i++) {
            tf = self.contentTfArray1[i];
            if (i == 6) {//手机
                userzc.phone = tf.text;
            }else if (i == 4){//密码
                userzc.password = tf.text;
            }else if (i == 1){//商家公司简介
                userzc.name = tf.text;
            }else if (i == 7){//验证码
                userzc.code = tf.text;
            }else if (i == 5){//重复密码
                userzc.password1 = tf.text;
            }else if (i == 0){
                userzc.fullname = tf.text;
            }else if (i == 3){
                userzc.address = tf.text;
            }
        }
        
        
        
        if (userzc.password.length <6) {//密码不能少于六位
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码长度不能少于6位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            return;
        }
        
        
        
        if ([userzc.password isEqualToString:userzc.password1] && [self indoShangjia]) {
            
            _hud = [GMAPI showMBProgressWithText:@"正在提交" addToView:self.contentView];
            _hud.delegate = self;
            
            NSString *str = [NSString stringWithFormat:FBAUTO_REGISTERED,userzc.phone,userzc.password,userzc.name,(long)userzc.province,(long)userzc.city,2,userzc.code,userzc.token,userzc.fullname];
            NSString *str1 = [NSString stringWithFormat:@"%@&address=%@",str,userzc.address];
            NSString *api = [str1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",str1);
            
            NSURL *url = [NSURL URLWithString:api];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (data.length > 0) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        int erroCode = [[dic objectForKey:@"errcode"]intValue];
                        NSString *erroInfo = [dic objectForKey:@"errinfo"];
                        NSLog(@"商家注册接口 errcode:%d",erroCode);
                        NSLog(@"商家注册接口 错误信息:%@",erroInfo);
                        if (erroCode !=0) {
                            [self hudWasHidden:_hud];
                            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:erroInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [al show];
                        }else if (erroCode == 0){
                            [self hudWasHidden:_hud];
                            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:erroInfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            al.tag = 134;
                            [al show];
                        }
                        
                    }
                    
                }else{
                    [self hudWasHidden:_hud];
                    NSLog(@"data 为空 connectionError %@",connectionError);
                    
                    NSString *errInfo = @"网络有问题,请检查网络";
                    switch (connectionError.code) {
                        case NSURLErrorNotConnectedToInternet:
                            errInfo = @"无网络连接";
                            break;
                        case NSURLErrorTimedOut:
                            errInfo = @"网络连接超时";
                            break;
                        default:
                            break;
                    }
                    
                }
            }];
            
            
        }else if (![userzc.password isEqualToString:userzc.password1]){
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"重复密码和密码填写不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
        }
        
    }
    
}


-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud.delegate = nil;
    hud = nil;
    
}



//block set方法
-(void)setCellBlock:(cellBlock)cellBlock{
    _cellBlock = cellBlock;
}

-(void)setTfBlock:(tfBlock)tfBlock{
    _tfBlock = tfBlock;
}

-(void)setShouTablevBlock:(shouTablevBlock)shouTablevBlock{
    _shouTablevBlock = shouTablevBlock;
}

-(void)setChooseAreaBlock:(chooseAreaBlock)chooseAreaBlock{
    _chooseAreaBlock = chooseAreaBlock;
}


//根据键盘高度调整 控件显示
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (self.tfBlock) {
        self.tfBlock(textField.tag);
    }
    
    if (textField.tag == 11 || textField.tag == 22) {//地区
        if (self.chooseAreaBlock) {
            self.chooseAreaBlock();
        }
        return NO;
    }
    
    
    // [textField resignFirstResponder];
    
    return YES;
}

//给地区赋值
-(void)areaFuzhi{
    //个人
    UITextField *tf = self.contenTfArray[1];
    if (self.delegate.province && self.delegate.city) {
        tf.text = [self.delegate.province stringByAppendingString:self.delegate.city];
    }
    self.province = self.delegate.provinceIn;
    self.city = self.delegate.cityIn;
    
    //商家
    UITextField *tf1 = self.contentTfArray1[2];
    if (self.delegate.province1 && self.delegate.city1) {
        tf1.text = [self.delegate.province1 stringByAppendingString:self.delegate.city1];
    }
    self.province1 = self.delegate.provinceIn1;
    self.city1 = self.delegate.cityIn1;
    
}



#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 133) {//个人注册成功
        if (buttonIndex == 0) {
            [self.delegate.navigationController popViewControllerAnimated:YES];
        }
    }else if (alertView.tag == 134){//商家注册成功
        if (buttonIndex == 0) {
            [self.delegate.navigationController popViewControllerAnimated:YES];
        }
    }
    
}






@end
