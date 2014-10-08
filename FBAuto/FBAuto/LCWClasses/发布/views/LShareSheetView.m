//
//  LShareSheetView.m
//  FBAuto
//
//  Created by lichaowei on 14-7-24.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "LShareSheetView.h"
#define KLEFT 20
#define KTOP 20
#define DIS_SMALL 10
#define DIS_BIG 22

#define VIEW_HEIGHT 236

@implementation LShareSheetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.window.windowLevel = UIAlertViewStyleDefault;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        self.alpha = 0.0;
        
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.bottom, 320, VIEW_HEIGHT)];
        bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
        [self addSubview:bgView];
        
        
        //微信、QQ、朋友圈、微博、站内好友
        
//        items = @[@"微信",@"QQ",@"朋友圈",@"微博",@"站内好友"];
        
        items = @[@"微信",@"QQ",@"朋友圈",@"微博"];
        NSArray *images = @[@"weixin72_72",@"QQ72_72",@"pengyouquan72_7222x",@"weibo90_72",@"haoyou90_70"];
        
        CGFloat left = 96 / 2.f;
        CGFloat aHeight = 36.f;
        CGFloat top = 55 / 2.f;
        CGFloat aWidth = 36.0;
        
        int line = 0;
        for (int i = 0; i < items.count; i ++) {
            
            line = i / 3;
            
            UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [itemBtn setFrame:CGRectMake(left + (62 + aWidth) * (i % 3), top + (20 + aWidth + 10) * line, aWidth, aHeight)];
            [itemBtn setBackgroundImage:[UIImage imageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];
            [bgView addSubview:itemBtn];
            itemBtn.tag = 100 + i;
            
            [itemBtn addTarget:self action:@selector(actionToDo:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(itemBtn.left - aWidth / 2.0, itemBtn.bottom + 5, aWidth * 2, 20)];
            titleLabel.text = [items objectAtIndex:i];
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [bgView addSubview:titleLabel];
        }
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(KLEFT, 350/2.0, 320 - KLEFT * 2, 45);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [cancelButton setBackgroundImage:[UIImage imageNamed:@"quxiao_button600_90"] forState:UIControlStateNormal];
        [bgView addSubview:cancelButton];
        
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
        aFrame.origin.y = [UIApplication sharedApplication].keyWindow.bottom - VIEW_HEIGHT;
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
    
    if (button.tag - 100 < items.count) {
        actionBlock(button.tag,[items objectAtIndex:button.tag - 100]);
    }
    
    [self hidden];
}

- (void)hidden
{
    [self removeFromSuperview];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    NSLog(@"touch view %@",touch.view);
    
    if ([touch.view isKindOfClass:[LShareSheetView class]]) {
        [self hidden];
        
    }
}

@end

