//
//  ClickImageView.h
//  FBAuto
//
//  Created by lichaowei on 14-7-17.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClickImageView : UIImageView

@property(nonatomic,assign)id image_target;
@property(nonatomic,assign)SEL image_action;

@property(nonatomic,assign)BOOL selected;

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;

@end
