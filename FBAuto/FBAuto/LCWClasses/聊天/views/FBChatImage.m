//
//  FBChatImage.m
//  FBAuto
//
//  Created by lichaowei on 14-7-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBChatImage.h"

@implementation FBChatImage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        maskView = [UIButton buttonWithType:UIButtonTypeCustom];
        maskView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [maskView addTarget:self action:@selector(clickToDo:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:maskView];
        
        indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [maskView addSubview:indicator];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    maskView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    indicator.center = CGPointMake(maskView.width / 2.0, maskView.height / 2.0);
}

//显示、隐藏 菊花

- (void)startLoading
{
    maskView.hidden = NO;
    [indicator startAnimating];
}

- (void)stopLoadingWithFailBlock:(LoadFailBlock)failBlock
{
    aFailBlock = failBlock;
    
    if (failBlock) {
        maskView.hidden = NO;
    }else
    {
        maskView.hidden = YES;
    }
    
    [indicator stopAnimating];
}

- (void)clickToDo:(UIButton *)sender
{
    NSLog(@"clickToDo");
    if (aFailBlock) {
        
        aFailBlock(self);
    }
}

- (void)showBigImage:(ClickBlock)clickBlock
{
    aBlock = clickBlock;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
    aBlock(self);
}

@end
