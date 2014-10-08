//
//  MenuCell.h
//  FBAuto
//
//  Created by lichaowei on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  menu 高级中使用
 */

typedef enum{
    Seg_none = 0,//无分割线
    Seg_left,//左边分割线
    Seg_right,//右边分割线
}SEG_STYLE;

@interface MenuCell : UITableViewCell

@property (nonatomic,assign)SEG_STYLE seg_style;
@property (strong, nonatomic) IBOutlet UIView *left_seg_View;
@property (strong, nonatomic) IBOutlet UIView *right_seg_View;
@property (strong, nonatomic) IBOutlet UILabel *contenLabel;

@end
