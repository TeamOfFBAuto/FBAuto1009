//
//  LShareSheetView.h
//  FBAuto
//
//  Created by lichaowei on 14-7-24.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  分享 sheetView
 */

typedef void(^ ActionBlock) (NSInteger buttonIndex,NSString *shareStyle);

@interface LShareSheetView : UIView
{
    ActionBlock actionBlock;
    UIView *bgView;
    NSArray *items;
}

- (void)actionBlock:(ActionBlock)aBlock;

@end
