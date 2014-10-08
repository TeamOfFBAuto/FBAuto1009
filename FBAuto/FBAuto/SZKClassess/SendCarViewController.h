//
//  SendCarViewController.h
//  FBAuto
//
//  Created by 史忠坤 on 14-6-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    Action_Add = 1,//发布车源
    Action_Edit //修改车源
    
}ActionStyle;

@interface SendCarViewController : FBBaseViewController

@property(nonatomic,assign)ActionStyle actionStyle;
@property(nonatomic,retain)NSString *infoId;//信息id

-(id)initWithStyle:(ActionStyle)aStyle;

@end
