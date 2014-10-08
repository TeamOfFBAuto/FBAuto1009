//
//  ClickImageView.m
//  FBAuto
//
//  Created by lichaowei on 14-7-17.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "ClickImageView.h"

@implementation ClickImageView


- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.userInteractionEnabled = YES;
        
        self.image_target = target;
        self.image_action = action;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor grayColor];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_image_target && [_image_target respondsToSelector:_image_action]) {
        
#pragma clang diagnostic push
        
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        [_image_target performSelector:_image_action withObject:self];
        
#pragma clang diagnostic pop
        
        
    }
    self.backgroundColor = [UIColor clearColor];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor clearColor];
}


@end
