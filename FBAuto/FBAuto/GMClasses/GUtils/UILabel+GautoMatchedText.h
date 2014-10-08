//
//  UILabel+GautoMatchedText.h
//  FBCircle
//
//  Created by gaomeng on 14-5-27.
//  Copyright (c) 2014年 szk. All rights reserved.
//


//UILabel 文字自适应高度

#import <UIKit/UIKit.h>

@interface UILabel (GautoMatchedText)

-(CGRect)matchedRectWithWidth:(CGFloat)width;

-(void)setMatchedFrame4LabelWithOrigin:(CGPoint)o width:(CGFloat)theWidth;

@end
