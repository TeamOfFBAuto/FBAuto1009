//
//  FBPhotoBrowserController.m
//  FBAuto
//
//  Created by lichaowei on 14-7-2.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBPhotoBrowserController.h"
#import "ZoomScrollView.h"

@interface FBPhotoBrowserController ()<UIScrollViewDelegate>
{
    UIScrollView *bgScroll;
}

@end

@implementation FBPhotoBrowserController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    bgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - 20)];//和图片一样高
    bgScroll.backgroundColor = [UIColor clearColor];
    bgScroll.showsHorizontalScrollIndicator = NO;
    bgScroll.pagingEnabled = YES;
    bgScroll.delegate = self;
    [self.view addSubview:bgScroll];
    
    
    bgScroll.contentSize = CGSizeMake(320 * _imagesArray.count, bgScroll.height);
    
    
    for (int i = 0; i < _imagesArray.count; i ++) {
        ZoomScrollView *aImageView = [[ZoomScrollView alloc]initWithFrame:CGRectMake(320 * i, 0, 320, bgScroll.height)];
        
        [aImageView.imageView sd_setImageWithURL:[NSURL URLWithString:[_imagesArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"detail_test.jpg"]];
        
        [bgScroll addSubview:aImageView];
    }
    
    bgScroll.contentOffset = CGPointMake(320 * self.showIndex, 0);
    self.titleLabel.text = [NSString stringWithFormat:@"%d/%lu",self.showIndex + 1,(unsigned long)_imagesArray.count];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / 320 + 1;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)index,(unsigned long)_imagesArray.count];
    NSLog(@"hh");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
