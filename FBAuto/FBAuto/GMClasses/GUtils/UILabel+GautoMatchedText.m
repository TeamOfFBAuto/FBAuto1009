//
//  UILabel+GautoMatchedText.m
//  FBCircle
//
//  Created by gaomeng on 14-5-27.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "UILabel+GautoMatchedText.h"

@implementation UILabel (GautoMatchedText)

-(CGRect)matchedRectWithWidth:(CGFloat)width{
    self.numberOfLines = 0;
    CGRect r = CGRectZero;
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        r = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font} context:nil];
    }
    return r;
    
}
-(void)setMatchedFrame4LabelWithOrigin:(CGPoint)o width:(CGFloat)theWidth{
    CGRect r = [self matchedRectWithWidth:theWidth];
    [self setFrame:CGRectMake(o.x, o.y, r.size.width, r.size.height)];
    
}


@end
