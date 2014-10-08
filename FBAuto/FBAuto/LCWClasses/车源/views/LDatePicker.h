//
//  LDatePicker.h
//  FBAuto
//
//  Created by lichaowei on 14-8-28.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DateBlock)(NSString *dateString);

@interface LDatePicker : UIView
{
    UIDatePicker *datePicker;
    UIView *bgView;
    DateBlock dateBlock;
}

- (void)showDateBlock:(DateBlock)aBlock;
@end
