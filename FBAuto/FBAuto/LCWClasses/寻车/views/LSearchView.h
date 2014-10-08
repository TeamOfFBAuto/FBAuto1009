//
//  LSearchView.h
//  FBAuto
//
//  Created by lichaowei on 14-7-18.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    Search_BeginEdit = 0,//编辑
    Search_Search,//点击搜索
    Search_Cancel//取消
}SearchStyle;

typedef void(^ SearchBlock) (SearchStyle actionStyle,NSString *searchText);

@interface LSearchView : UIView<UITextFieldDelegate>
{
    SearchBlock searchBlock;
    
    UIView *maskView;//遮罩
}

@property (nonatomic,retain)UITextField *searchField;

- (id)initWithFrame:(CGRect)frame
        placeholder:(NSString *)placeholder
          logoImage:(UIImage *)logoImage
 maskViewShowInView:(UIView *)aView
        searchBlock:(SearchBlock)aBlock;

- (void)cancelSearch;

@end
