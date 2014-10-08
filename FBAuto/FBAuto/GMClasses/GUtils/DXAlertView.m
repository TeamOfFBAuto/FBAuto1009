//
//  ILSMLAlertView.m
//  MoreLikers
//
//  Created by xiekw on 13-9-9.
//  Copyright (c) 2013年 谢凯伟. All rights reserved.
//

#import "DXAlertView.h"
#import <QuartzCore/QuartzCore.h>


#define kAlertWidth 275.0f
#define kAlertHeight 90.0f

@interface DXAlertView ()
{
    BOOL _leftLeave;
    CGFloat newHeight;
}

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *backImageView;

@end

@implementation DXAlertView

+ (CGFloat)alertWidth
{
    return kAlertWidth;
}

+ (CGFloat)alertHeight
{
    return kAlertHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define kTitleYOffset 15.0f
#define kTitleHeight 18.0f

#define kContentOffset 30.0f
#define kBetweenLabelOffset 20.0f

- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
{
    if (self = [super init]) {
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTitleYOffset, kAlertWidth, kTitleHeight)];
        self.alertTitleLabel.font = [UIFont systemFontOfSize:17];
        self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.alertTitleLabel.textColor = [UIColor blackColor];
        [self addSubview:self.alertTitleLabel];
        
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
        
        if (!leftTitle) {
            rightBtnFrame = CGRectMake(74, 47, 114, 35);
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn.frame = rightBtnFrame;
            
        }else {
            leftBtnFrame = CGRectMake(15, 47, 114, 35);
            rightBtnFrame = CGRectMake(144, 47, 114, 35);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
        }
        
        [self.rightBtn setBackgroundColor:[UIColor orangeColor]];
        [self.leftBtn setBackgroundColor:[UIColor orangeColor]];
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        
        newHeight = 0.f;
        
        self.alertTitleLabel.text = title;
        self.alertContentLabel.text = content;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
            isInput:(BOOL)isInput
{
    if (self = [self initWithTitle:title contentText:content leftButtonTitle:leftTitle rightButtonTitle:rigthTitle]) {
        
        if (isInput) {
            
            newHeight = 50.f;
            self.inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10 + newHeight - 20, kAlertWidth - 20, 30 + 20)];
            _inputTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            _inputTextView.layer.borderWidth = 1.0;
            _inputTextView.font = [UIFont systemFontOfSize:14];
            [self addSubview:_inputTextView];
            
            _inputTextView.text = content;
            _alertTitleLabel.text = @"站内分享";
            
            CGRect leftFrame = _leftBtn.frame;
            leftFrame.origin.y += newHeight;
            _leftBtn.frame = leftFrame;
            
            CGRect rightFrame = _rightBtn.frame;
            rightFrame.origin.y += newHeight;
            _rightBtn.frame = rightFrame;
            
        }
    }
    return self;
}



- (void)leftBtnClicked:(id)sender
{
    _leftLeave = YES;
    
    [self dismissAlert];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightBtnClicked:(id)sender
{
    _leftLeave = NO;
    [self dismissAlert];
    if (self.rightBlock) {
        self.rightBlock();
    }
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, - kAlertHeight - 30, kAlertWidth, kAlertHeight + newHeight);
    [topVC.view addSubview:self];
}

- (void)dismissAlert
{
    [self removeFromSuperview];
    
    [self resignTextViewFirstResponder:nil];
    
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview
{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kAlertWidth, kAlertHeight + newHeight);
    
//    //带动画
//    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.frame = afterFrame;
//        if (_leftLeave) {
//            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
//        }else {
//            self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
//        }
//    } completion:^(BOOL finished) {
//        [super removeFromSuperview];
//    }];
    
    //无动画
    self.frame = afterFrame;
    
    
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];

    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.6f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignTextViewFirstResponder:)];
        [_backImageView addGestureRecognizer:tap];
    }
    [topVC.view addSubview:self.backImageView];
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kAlertHeight) * 0.5, kAlertWidth, kAlertHeight + newHeight);
    
    //无动画
    self.transform = CGAffineTransformMakeRotation(0);
    self.frame = afterFrame;
    
    //带动画
//    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        self.transform = CGAffineTransformMakeRotation(0);
//        self.frame = afterFrame;
//    } completion:^(BOOL finished) {
//    }];
    
    
    [super willMoveToSuperview:newSuperview];
}

-(void)resignTextViewFirstResponder:(UIGestureRecognizer *)gesture
{
   [self.inputTextView resignFirstResponder];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.inputTextView resignFirstResponder];
}

@end

//@implementation UIImage (colorful)
//
//+ (UIImage *)imageWithColor:(UIColor *)color
//{
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return image;
//}

//@end
