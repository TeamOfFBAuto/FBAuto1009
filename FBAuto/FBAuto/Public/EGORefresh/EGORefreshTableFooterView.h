//
//  EGORefreshTableFooterView.h
//  Anteater
//
//  Created by 浩 张 on 12-7-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EGORefreshTableHeaderView.h"
@class SCGIFImageView;

@interface EGORefreshTableFooterView : UIView
{
    id _delegate;
	EGOPullRefreshState _state;
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
    SCGIFImageView  *loadingView;

}

@property(nonatomic,assign) id <EGORefreshTableDelegate> delegate;


- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
