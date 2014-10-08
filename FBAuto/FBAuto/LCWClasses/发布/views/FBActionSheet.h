//
//  FBActionSheet.h
//  FBAuto
//
//  Created by lichaowei on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  自定义actionSheet,目前是固定个数
 */

typedef void(^ ActionBlock) (NSInteger buttonIndex);

@interface FBActionSheet : UIView
{
    ActionBlock actionBlock;
    UIView *bgView;
}

- (void)actionBlock:(ActionBlock)aBlock;

@end
