//
//  Section_Button.m
//  FBAuto
//
//  Created by lichaowei on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "Section_Button.h"
#define kLEFT 10

@implementation Section_Button

- (id)initWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action sectionStyle:(SectionStyle)style image:(UIImage *)aImage
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat left = kLEFT;
        if (style == Section_Image) {
            UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(kLEFT, (self.height - 18) / 2.0, 18, 18)];
            leftImage.image = aImage;
            [self addSubview:leftImage];
            
            left = leftImage.right + 5;
        }
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(left, 0, 100, self.height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = title;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
        
        self.arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width - 5 - 10, (self.height - 9) / 2.0, 5, 9)];
        _arrowImageView.image = [UIImage imageNamed:@"jiantou_hui10_18"];
        [self addSubview:_arrowImageView];
        
        _arrowImageView.center = CGPointMake(_arrowImageView.center.x, _titleLabel.center.y);
        
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_arrowImageView.left - 150 - 10, 0, 150, self.height)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_contentLabel];

        
        self.menu_Target = target;
        self.menu_Action = action;
        
        self.layer.borderColor = [UIColor colorWithHexString:@"b4b4b4"].CGColor;
        self.layer.borderWidth = 0.5f;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    if (point.x < 100) {
        
        return;
    }
    self.backgroundColor = [UIColor lightGrayColor];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    if (point.x < 100) {
        
        return;
    }
    
    
    if (_menu_Target && [_menu_Target respondsToSelector:_menu_Action]) {
        
#pragma clang diagnostic push
        
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        [_menu_Target performSelector:_menu_Action withObject:self];
        
#pragma clang diagnostic pop
        
        
    }
    self.backgroundColor = [UIColor clearColor];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor clearColor];
}

@end
