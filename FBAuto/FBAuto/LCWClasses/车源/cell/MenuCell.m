//
//  MenuCell.m
//  FBAuto
//
//  Created by lichaowei on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if (_seg_style == Seg_left) {
        self.left_seg_View.hidden = !selected;
    }
    
    if (_seg_style == Seg_right) {
        self.right_seg_View.hidden = !selected;
    }
    
    if (_seg_style == Seg_none) {
        self.right_seg_View.hidden = YES;
        self.left_seg_View.hidden = YES;
    }
}

@end
