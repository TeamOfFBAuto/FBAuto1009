//
//  GloginView.m
//  FBAuto
//
//  Created by gaomeng on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GloginView.h"

#import "GloginViewController.h"

////4寸屏幕
//#define Frame_row3Down CGRectMake(24, 312, 275, 210)
//#define Frame_row3Up CGRectMake(24, 312-180, 275, 210)
//
////3.5屏幕
//#define Frame_row3Down4s CGRectMake(24, 200, 275, 210)
//#define Frame_row3Up4s CGRectMake(24, 200-180, 275, 210)


@implementation GloginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //        //弹出键盘通知
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
        
        
        if (iPhone5) {
            _Frame_row3Down = CGRectMake(24, 312, 275, 210);
            _Frame_row3Up = CGRectMake(24, 312-180, 275, 210);
            
            _Frame_logoDown = CGRectMake(53, 118, 220, 60);
            _Frame_logoUp = CGRectMake(60, 50, 320-60-60, 60);
            
        }else{
            _Frame_row3Down = CGRectMake(24, 312-44, 275, 210);
            _Frame_row3Up = CGRectMake(24, 312-44-190, 275, 210);
            
            
            _Frame_logoDown = CGRectMake(53, 118, 220, 60);
            _Frame_logoUp = CGRectMake(105, 40, 110, 30);
        }
        
        
        
        //点击回收键盘
        UIControl *backControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
        [backControl addTarget:self action:@selector(Gshou) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backControl];
        
        //背景图
        UIImageView *backGroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"denglu_bg640_1096.png"]];
        backGroundImageView.frame = CGRectMake(0, 0, 320, 568);
        [self addSubview:backGroundImageView];
        
        //logo图
        UIImageView *logoImv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elogo440_120.png"] highlightedImage:nil];
//        logoImv.frame = CGRectMake(53, 118, 220, 60);
        
        logoImv.frame = CGRectMake(0, 118, 320, 70);
        logoImv.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:logoImv];
        self.logoImv = logoImv;
        
        
        
        //账号 密码 登录 底层view
        self.Row3backView = [[UIView alloc]initWithFrame:_Frame_row3Down];
        [self addSubview:self.Row3backView];
        //self.Row3backView.backgroundColor = [UIColor purpleColor];
        
        
        //账号和密码输入框
        //输入框
        _zhanghaoBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 275, 45)];
        [_zhanghaoBackView setImage:[UIImage imageNamed:@"denglu_shurukuang550_90.png"]];
        _passWordBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 275, 45)];
        [_passWordBackView setImage:[UIImage imageNamed:@"denglu_shurukuang550_90.png"]];
        
        
        
        
        
        //输入textField
        //用户名
        self.userTf = [[UITextField alloc]initWithFrame:CGRectMake(15, 0,275, 45)];
        self.userTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.userTf.textColor = RGBCOLOR(164, 164, 164);
        self.userTf.delegate = self;
        self.userTf.tag = 50;
        
        //密码
        self.passWordTf = [[UITextField alloc]initWithFrame:CGRectMake(15, 60, 275, 45)];
        self.passWordTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.passWordTf.secureTextEntry = YES;
        self.passWordTf.textColor = RGBCOLOR(164, 164, 164);
        self.passWordTf.delegate = self;
        self.passWordTf.tag = 51;
        
        [self.Row3backView addSubview:_zhanghaoBackView];
        [self.Row3backView addSubview:_passWordBackView];
        [self.Row3backView addSubview:self.userTf];
        [self.Row3backView addSubview:self.passWordTf];
        
        
        _placeHolder1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 275, 45)];
//        _placeHolder1.text = @"账号";
        _placeHolder1.text = @"手机号";
        _placeHolder1.textColor = RGBCOLOR(164, 164, 164);
        
        _placeHolder2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 60, 275, 45)];
        _placeHolder2.text = @"密码";
        _placeHolder2.textColor = RGBCOLOR(164, 164, 164);
        
        
        
        [self.Row3backView addSubview:_placeHolder1];
        [self.Row3backView addSubview:_placeHolder2];
        
        
        
        //登录
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setBackgroundImage:[UIImage imageNamed:@"denglu_botton550_100.png"] forState:UIControlStateNormal];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        loginBtn.titleLabel.textColor = [UIColor whiteColor];
        loginBtn.frame = CGRectMake(0, 130, 275, 50);
        [loginBtn addTarget:self action:@selector(denglu) forControlEvents:UIControlEventTouchUpInside];
        [self.Row3backView addSubview:loginBtn];
        
        
        
        //忘记密码
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setTitle:@"忘记密码" forState:UIControlStateNormal];
        btn1.frame = CGRectMake(0, CGRectGetMaxY(loginBtn.frame)+5, 50, 25);
        btn1.titleLabel.font = [UIFont systemFontOfSize:12];
        btn1.titleLabel.textColor = RGBCOLOR(123, 123, 123);
        [btn1 addTarget:self action:@selector(findmima) forControlEvents:UIControlEventTouchUpInside];
        [self.Row3backView addSubview:btn1];
        
        //免费注册
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setTitle:@"免费注册" forState:UIControlStateNormal];
        btn2.frame = CGRectMake(225, btn1.frame.origin.y, 50, 25);
        btn2.titleLabel.font = [UIFont systemFontOfSize:12];
        btn2.titleLabel.textColor = RGBCOLOR(123, 123, 123);
        [self.Row3backView addSubview:btn2];
        
        [btn2 addTarget:self action:@selector(zhuce) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
    }
    return self;
}


//block的set方法

-(void)setZhuceBlock:(zhuceBlock)zhuceBlock{
    _zhuceBlock = zhuceBlock;
}
-(void)setFindPassBlock:(findPasswBlock)findPassBlock{
    _findPassBlock = findPassBlock;
}
-(void)setDengluBlock:(dengluBlock)dengluBlock{
    _dengluBlock = dengluBlock;
}


//收键盘
-(void)Gshou{
    [self.userTf resignFirstResponder];
    [self.passWordTf resignFirstResponder];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.Row3backView.frame = _Frame_row3Down;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.logoImv.frame = _Frame_logoDown;
    } completion:^(BOOL finished) {
        
    }];
    
    
}




#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"------------------%@",NSStringFromRange(range));
    
    if (textField.tag == 50) {
        
        NSString *uname = [NSString stringWithFormat:@"%@%@",textField.text,string];
        
        NSLog(@"%lu",(unsigned long)uname.length);
        
        if (range.length!=1 || range.location!=0) {
            
            self.userName = uname;
            _placeHolder1.hidden = YES;
        }else{
            
            _placeHolder1.hidden = NO;
            
        }
    }else if(textField.tag == 51){
        NSString *passw = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if (range.length!=1 || range.location!=0) {
            self.userPassWord = passw;
            _placeHolder2.hidden = YES;
        }else{
            _placeHolder2.hidden = NO;
        }
    }
    
    return YES;
}





//键盘出现
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        self.Row3backView.frame = _Frame_row3Up;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.logoImv.frame = _Frame_logoUp;
    } completion:^(BOOL finished) {
        
    }];
    
    return YES;
}




//注册
-(void)zhuce{
    if (self.zhuceBlock) {
        self.zhuceBlock();
    }
}

//找回密码
-(void)findmima{
    if (self.findPassBlock) {
        self.findPassBlock();
    }
}


//登录
-(void)denglu{
    if (self.dengluBlock) {
        self.dengluBlock(self.userName,self.userPassWord);
    }
}


@end
