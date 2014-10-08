//
//  GHolderTextView.m
//  FBCircle
//
//  Created by gaomeng on 14-5-26.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GHolderTextView.h"


@implementation GHolderTextView

- (id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder holderSize:(CGFloat)holderSizeFloat;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.TV = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.TV.text = placeholder;
        self.TV.font = [UIFont systemFontOfSize:holderSizeFloat];
        self.TV.textColor = [UIColor grayColor];
        self.TV.backgroundColor = [UIColor clearColor];
        self.TV.editable = NO;
        [self addSubview:self.TV];
        [self sendSubviewToBack:self.TV];
        self.delegate = self;
    }
    return self;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    //self.gxqmVC.lastLength.text = [NSString stringWithFormat:@"%ld",last];
    
    //placeholder
    if (self.text.length == 0) {
        self.TV.hidden = NO;
    }
    else {
        self.TV.hidden = YES;
    }
    
    NSRange range;
    range.location = 0;
    range.length = 30;
    NSString *tmp = [[NSString alloc]init];
    if (self.text.length > 30) {
        tmp = [self.text substringWithRange:range];
        
    }
    //
    //    self.text = tmp;
    NSLog(@"%@",self.text);
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    BOOL edit = YES;
    if (range.location>30)
    {
        edit = NO;
    }
    else
    {
        edit = YES;
    }
    
    NSRange r;
    r.location = 0;
    r.length = 31;
    NSString *tmp = [[NSString alloc]init];
    if (self.text.length > 30) {
        tmp = [self.text substringWithRange:r];
        self.text = tmp;
        edit = YES;
    }
    
    
    
    return edit;
}

@end
