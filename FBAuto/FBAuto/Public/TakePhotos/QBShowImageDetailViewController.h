//
//  QBShowImageDetailViewController.h
//  FBCircle
//
//  Created by soulnear on 14-5-13.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBShowImagesScrollView.h"

@protocol QBShowImageDetailViewControllerDelegate <NSObject>

-(void)returnSelectedImagesWith:(NSMutableOrderedSet *)assets;

@end


@interface QBShowImageDetailViewController : UIViewController<UIScrollViewDelegate,QBShowImagesScrollViewDelegate>
{
    UIView * navgationBar;
    
    UIView * bottomView;
    
    UIButton * chooseButton;
        
    char identifier[20];
    
    UILabel * title_label;
    
    UIView * navImageView;
    
    UIButton * finish_button;
    
    UILabel * selectedLabel;
}

@property(nonatomic,assign)id<QBShowImageDetailViewControllerDelegate> delegate;

@property(nonatomic,assign)int currentPage;

@property(nonatomic,strong)NSMutableArray * AllImagesArray;

@property (nonatomic, retain) NSMutableOrderedSet * selectedAssets;

@property(nonatomic,strong)UIScrollView * myScrollView;

@property(nonatomic,strong)NSMutableArray * allImages;

@property(nonatomic,assign)int SelectedCount;



@end
