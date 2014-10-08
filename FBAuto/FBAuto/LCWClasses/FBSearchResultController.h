//
//  FBSearchResultController.h
//  FBAuto
//
//  Created by lichaowei on 14-7-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBBaseViewController.h"

//车源、寻车搜索结果

typedef enum{
    
    Search_carSource = 0,//车源
    search_findCar //寻车
    
}SearchContentStyle;

@interface FBSearchResultController : FBBaseViewController<UITableViewDataSource>

@property (nonatomic,retain)NSString *searchKeyword;

-(id)initWithStyle:(SearchContentStyle)searchStyle;

@end
