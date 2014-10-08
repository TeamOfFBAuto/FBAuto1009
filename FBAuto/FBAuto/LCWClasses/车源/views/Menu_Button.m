//
//  Menu_Button.m
//  FBAuto
//
//  Created by lichaowei on 14-6-30.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "Menu_Button.h"

@implementation Menu_Button

- (id)initWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 42, self.height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = title;
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        
        self.arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(42 + 2, (self.height - 4) / 2.0 + 2, 7, 4)];
        _arrowImageView.image = [UIImage imageNamed:@"xiala_sanjiao_down14_8"];
        [self addSubview:_arrowImageView];
        
        self.menu_Target = target;
        self.menu_Action = action;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor grayColor];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_menu_Target && [_menu_Target respondsToSelector:_menu_Action]) {
        
    #pragma clang diagnostic push

    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
    [_menu_Target performSelector:_menu_Action withObject:self];
            
    #pragma clang diagnostic pop
        
        
    }
    
    if (self.normalColor) {
        self.backgroundColor = [UIColor colorWithHexString:self.normalColor];
    }else
    {
        self.backgroundColor = [UIColor clearColor];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor clearColor];
}

@end
