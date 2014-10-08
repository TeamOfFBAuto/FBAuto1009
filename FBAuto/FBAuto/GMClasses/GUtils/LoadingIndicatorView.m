//
//  LoadingIndicatorView.m
//  FBCircle
//
//  Created by gaomeng on 14-5-27.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "LoadingIndicatorView.h"

#import <QuartzCore/QuartzCore.h>


@interface LoadingIndicatorView()
@property (nonatomic, strong) UIView *maskView;
@end

@implementation LoadingIndicatorView

@synthesize loadingIndicator = _loadingIndicator, loadingLabel = _loadingLabel, normalLabel = _normalLabel, type;
@synthesize maskView = _maskView;

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [_maskView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1]];
        [_maskView setUserInteractionEnabled:NO];
    }
    
    return _maskView;
}

- (UIActivityIndicatorView*)loadingIndicator
{
    if (!_loadingIndicator) {
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingIndicator.hidden = YES;
        _loadingIndicator.backgroundColor = [UIColor clearColor];
        _loadingIndicator.hidesWhenStopped = YES;
        //        _loadingIndicator.frame = CGRectMake(self.frame.size.width/2-70 , 0 , 24, 24);
        _loadingIndicator.frame = CGRectMake(self.frame.size.width/2 - 70 ,self.frame.size.height/2 - 12 , 24, 24);
    }
    return _loadingIndicator;
}

- (UILabel*)normalLabel
{
    if (!_normalLabel) {
        _normalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _normalLabel.text = NSLocalizedString(@"上拉加载更多", nil);
        _normalLabel.backgroundColor = [UIColor clearColor];
        [_normalLabel setFont:[UIFont systemFontOfSize:14]];
        _normalLabel.textAlignment = NSTextAlignmentCenter;
        [_normalLabel setTextColor:[UIColor darkGrayColor]];
    }
    
    return _normalLabel;
    
}

- (UILabel*)loadingLabel
{
    if (!_loadingLabel) {
        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-80, 0, self.frame.size.width/2+30, self.frame.size.height)];
        _loadingLabel.text = NSLocalizedString(@"加载中...", nil);
        _loadingLabel.backgroundColor = [UIColor clearColor];
        [_loadingLabel setFont:[UIFont systemFontOfSize:14]];
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        [_loadingLabel setTextColor:[UIColor darkGrayColor]];
        [_loadingLabel setHidden:YES];
    }
    
    return _loadingLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.type = 1;
        [self addSubview:self.loadingLabel];
        [self addSubview:self.normalLabel];
        [self addSubview:self.loadingIndicator];
    }
    
    return self;
}

- (void)setType:(int)indicatorType
{
    if (indicatorType == 3) {
        // set 3 type
        [self setFrame:CGRectMake(0, 0, 320, 480)];
        [self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]];
        
        UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(120, 180, 100, 120)];
        loadingView.layer.masksToBounds = YES;
        loadingView.layer.cornerRadius = 10;
        [loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        
        [self.loadingIndicator removeFromSuperview];
        [self.loadingIndicator setFrame:CGRectMake(0, 0, loadingView.frame.size.width, loadingView.frame.size.height-20)];
        [self.loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [self.loadingLabel removeFromSuperview];
        [self.loadingLabel setFrame:CGRectMake(0, 80, 100, 50)];
        [self.loadingLabel setTextAlignment:NSTextAlignmentCenter];
        [self.loadingLabel setTextColor:[UIColor whiteColor]];
        [self.loadingLabel setFont:[UIFont systemFontOfSize:16]];
        [self.loadingLabel setText:NSLocalizedString(@"Saving", nil)];
        
        [loadingView addSubview:self.loadingIndicator];
        [loadingView addSubview:self.loadingLabel];
        
        [self addSubview:loadingView];
        [self.normalLabel setHidden:YES];
    }
}

- (void)startLoading
{
    [self setHidden:NO];
    [self.loadingIndicator startAnimating];
    [self.loadingLabel setHidden:NO];
    [self.normalLabel setHidden:YES];
    
    [[self superview] bringSubviewToFront:self];
}

- (void)stopLoading:(int)loadingType
{
    [self.loadingIndicator stopAnimating];
    switch (loadingType) {
        case 1:
            [self.normalLabel setHidden:NO];
            [self.normalLabel setText:NSLocalizedString(@"上拉加载更多", nil)];
            [self.loadingLabel setHidden:YES];
            break;
        case 2:
            [self setHidden:YES];
            break;
        case 3:
            [self.normalLabel setHidden:NO];
            [self.normalLabel setText:NSLocalizedString(@"没有更多了", nil)];
            [self.loadingLabel setHidden:YES];
            break;
        case 4:
            [self.normalLabel setHidden:NO];
            [self.normalLabel setText:NSLocalizedString(@"非好友最多显示十条信息", nil)];
            [self.loadingLabel setHidden:YES];
            break;
        default:
            break;
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 }
 */

@end
