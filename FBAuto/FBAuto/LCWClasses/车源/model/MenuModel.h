//
//  MenuModel.h
//  FBAuto
//
//  Created by lichaowei on 14-6-30.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuModel : NSObject

@property(nonatomic,retain)NSString *title;
@property(nonatomic,assign)BOOL haveSub;//是否含有下一级

- (id)initWithTitle:(NSString *)title haveSub:(BOOL)isHave;

@end
