//
//  Menu_Button.h
//  FBAuto
//
//  Created by lichaowei on 14-6-30.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  车源 自定义button
 */

@interface Menu_Button : UIView

@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UIImageView *arrowImageView;
@property(nonatomic,retain)UIButton *button;

@property(nonatomic,assign)id menu_Target;
@property(nonatomic,assign)SEL menu_Action;

@property(nonatomic,assign)BOOL selected;
@property(nonatomic,assign)NSString *normalColor;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;

@end
