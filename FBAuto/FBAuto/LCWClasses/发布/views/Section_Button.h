//
//  Section_Button.h
//  FBAuto
//
//  Created by lichaowei on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  发布车源、好友列表、添加好友，自定义button
 */

typedef enum {
    Section_Normal = 0,//左侧无图片
    Section_Image,//左侧有图
}SectionStyle;

@interface Section_Button : UIView
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UILabel *contentLabel;//选择参数
@property(nonatomic,retain)UIImageView *arrowImageView;

@property(nonatomic,assign)id menu_Target;
@property(nonatomic,assign)SEL menu_Action;

@property(nonatomic,assign)BOOL selected;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action sectionStyle:(SectionStyle)style image:(UIImage *)aImage;

@end
