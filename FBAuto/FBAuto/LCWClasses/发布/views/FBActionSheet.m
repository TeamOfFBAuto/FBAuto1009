//
//  FBActionSheet.m
//  FBAuto
//
//  Created by lichaowei on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBActionSheet.h"
#define KLEFT 20
#define KTOP 20
#define DIS_SMALL 10
#define DIS_BIG 22

@implementation FBActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.window.windowLevel = UIAlertViewStyleDefault;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        self.alpha = 0.0;
        
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.bottom, 320, 208)];
        bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
        [self addSubview:bgView];
        
        UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        firstButton.frame = CGRectMake(KLEFT, KTOP, 320 - KLEFT * 2, 45);
        [firstButton setTitle:@"拍照" forState:UIControlStateNormal];
        [firstButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        firstButton.layer.cornerRadius = 5;
        firstButton.layer.borderWidth = 1.0;
        firstButton.tag = 0;
        firstButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [firstButton setBackgroundImage:[UIImage imageNamed:@"bai_button554_90"] forState:UIControlStateNormal];
        [bgView addSubview:firstButton];
        
        UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
        secondButton.frame = CGRectMake(KLEFT, firstButton.bottom + DIS_SMALL, 320 - KLEFT * 2, 45);
        [secondButton setTitle:@"从手机相册选择" forState:UIControlStateNormal];
        [secondButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        secondButton.layer.cornerRadius = 5;
        secondButton.layer.borderWidth = 1.0;
        secondButton.tag = 1;
        secondButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [secondButton setBackgroundImage:[UIImage imageNamed:@"bai_button554_90"] forState:UIControlStateNormal];
        [bgView addSubview:secondButton];
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(KLEFT, secondButton.bottom + DIS_BIG, 320 - KLEFT * 2, 45);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelButton.layer.cornerRadius = 5;
        cancelButton.layer.borderWidth = 1.0;
        cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cancelButton.tag = 2;
        cancelButton.backgroundColor = [UIColor colorWithHexString:@"7f858a"];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"hui_button554_90"] forState:UIControlStateNormal];
        [bgView addSubview:cancelButton];
        
        [firstButton addTarget:self action:@selector(actionToDo:) forControlEvents:UIControlEventTouchUpInside];
        [secondButton addTarget:self action:@selector(actionToDo:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton addTarget:self action:@selector(actionToDo:) forControlEvents:UIControlEventTouchUpInside];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [self show];
    }
    return self;
}

- (void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect aFrame = bgView.frame;
        aFrame.origin.y = [UIApplication sharedApplication].keyWindow.bottom - 208;
        bgView.frame = aFrame;
        
        self.alpha = 1.0;
    }];
}


- (void)actionBlock:(ActionBlock)aBlock
{
    actionBlock = aBlock;
}

- (void)actionToDo:(UIButton *)button
{
    //0,1,2
    actionBlock(button.tag);
    [self hidden];
}

- (void)hidden
{
    [self removeFromSuperview];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hidden];
}

@end
