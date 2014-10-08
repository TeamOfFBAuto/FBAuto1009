//
//  LDatePicker.m
//  FBAuto
//
//  Created by lichaowei on 14-8-28.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "LDatePicker.h"

@implementation LDatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.frame = [UIScreen mainScreen].bounds;
        self.window.windowLevel = UIWindowLevelAlert;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.alpha = 0.0;
        
        
        bgView = [[UIView alloc]init];
        [self addSubview:bgView];
        
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320.0, 216)];
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.date = [NSDate date];
        [bgView addSubview:datePicker];
        
        [datePicker addTarget:self action:@selector(updatetime:) forControlEvents:UIControlEventValueChanged];
        
        
        UIView *toolsBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolsBarView.backgroundColor = [UIColor colorWithRed:223/255. green:223/255. blue:223/255. alpha:1];
        [bgView addSubview:toolsBarView];
        
        UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [finishButton setTitle:@"确定" forState:UIControlStateNormal];
        [finishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        finishButton.frame = CGRectMake(320 - 50 - 10, 0, 50, 44);
        [finishButton addTarget:self action:@selector(clickDoneButton:) forControlEvents:UIControlEventTouchUpInside];
        [toolsBarView addSubview:finishButton];
        
        UIImageView *aImage = [[UIImageView alloc]initWithFrame:CGRectMake(finishButton.right, 0, 1, 44)];
        [aImage setImage:[UIImage imageNamed:@"topSeg.png"]];
        [toolsBarView addSubview:aImage];
        
        
        bgView.frame = CGRectMake(0, self.height, 320, datePicker.height + toolsBarView.height);
        
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

- (void)showDateBlock:(DateBlock)aBlock
{
    dateBlock = aBlock;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        bgView.top = self.height - bgView.height;
        self.alpha = 1.0;
    }];
}

-(void)hidden
{
    [UIView animateWithDuration:0.5 animations:^{
        bgView.top = self.height;
        self.alpha = 0.0;
    }];
    
    [self removeFromSuperview];
}

- (NSString *)selectTime:(NSDate *)date
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
    [outputFormatter setDateFormat:@"yyyy.MM.dd"];
    
    NSString *dateStr = [outputFormatter stringFromDate:date];

    return dateStr;
}

- (void)clickDoneButton:(UIButton *)sender
{
    if (dateBlock) {
        dateBlock([self selectTime:datePicker.date]);
    }
    
    [self hidden];
}

- (void)clickCancelButton:(UIButton *)sender
{
    
}

- (void)updatetime:(UIDatePicker *)sender
{
    
    if (dateBlock) {
        dateBlock([self selectTime:sender.date]);
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    UITouch *touch = [touches anyObject];
    if (touch.view != self) {
        return;
    }
    
    [self hidden];
}

@end
