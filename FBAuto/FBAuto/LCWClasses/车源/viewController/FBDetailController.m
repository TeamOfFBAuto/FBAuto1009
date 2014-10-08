//
//  FBDetailController.m
//  FBAuto
//
//  Created by lichaowei on 14-7-2.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBDetailController.h"
#import "DDPageControl.h"
#import "FBPhotoBrowserController.h"
#import "DetailCell.h"
#define KFistSectionHeight 114 //上部分高度

@interface FBDetailController ()<UIScrollViewDelegate>
{
    UIScrollView *bigBgScroll;//背景scroll
    UIView *firstBgView;
    UIScrollView *photosScroll;//图片底部scrollView
    DDPageControl *pageControl;
}

@end

@implementation FBDetailController

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
    
    bigBgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - 20 - 75)];
    bigBgScroll.backgroundColor = [UIColor clearColor];
    bigBgScroll.showsHorizontalScrollIndicator = NO;
    bigBgScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bigBgScroll];
    
    self.imagesArray = @[@"geren_down46_46",@"haoyou_dianhua40_46",@"geren_down46_46",@"haoyou_dianhua40_46",@"haoyou_dianhua40_46",@"geren_down46_46",@"haoyou_dianhua40_46",@"haoyou_dianhua40_46",@"geren_down46_46",@"haoyou_dianhua40_46"];
    
    [self createFirstSection];
    [self createSecondSection];
    [self createThirdSection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 图片部分

- (void)createFirstSection
{
    firstBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, KFistSectionHeight)];
    firstBgView.backgroundColor = [UIColor clearColor];
    [bigBgScroll addSubview:firstBgView];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, firstBgView.bottom - 1, 320, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"b4b4b4"];
    [firstBgView addSubview:line];
    
    photosScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 10, 300, 80)];//和图片一样高
    photosScroll.backgroundColor = [UIColor clearColor];
    photosScroll.showsHorizontalScrollIndicator = NO;
    photosScroll.pagingEnabled = YES;
    photosScroll.delegate = self;
    [firstBgView addSubview:photosScroll];
    
    CGFloat aWidth = (photosScroll.width - 14)/ 3;
    for (int i = 0; i < self.imagesArray.count; i ++) {
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [imageBtn setImage:[UIImage imageNamed:[_imagesArray objectAtIndex:i]] forState:UIControlStateNormal];
        imageBtn.tag = 100 + i;
        imageBtn.layer.borderWidth = 2;
        [imageBtn addTarget:self action:@selector(clickToBigPhoto:) forControlEvents:UIControlEventTouchUpInside];
        imageBtn.frame = CGRectMake((aWidth + 7) * i, 0, aWidth, 80);
        [photosScroll addSubview:imageBtn];
    }
    
    photosScroll.contentSize = CGSizeMake(aWidth * _imagesArray.count + 7 * (_imagesArray.count - 1), 80);
    
    [self createPageControlSumPages:(int)_imagesArray.count];
}


#pragma - mark 创建 PageControl

- (void)createPageControlSumPages:(int)sum
{
    if (sum % 3 == 0) {
        sum = sum / 3;
    }else
    {
        sum = (sum / 3) + 1;
    }

    
    pageControl = [[DDPageControl alloc] init] ;
	[pageControl setCenter: CGPointMake(firstBgView.center.x, firstBgView.height-10.0f)] ;
    //	[pageControl addTarget: self action: @selector(pageControlClicked:) forControlEvents: UIControlEventValueChanged] ;
	[pageControl setDefersCurrentPageDisplay: YES] ;
	[pageControl setType: DDPageControlTypeOnFullOffEmpty] ;
	[pageControl setOnColor: [UIColor colorWithHexString:@"ff9c00"]];
	[pageControl setOffColor: [UIColor colorWithHexString:@"b4b4b4"]] ;
	[pageControl setIndicatorDiameter: 9.0f] ;
	[pageControl setIndicatorSpace: 5.0f] ;
	[firstBgView addSubview: pageControl] ;
    
//    pageControl.hidden = YES;
    
    [pageControl setNumberOfPages:sum];
	[pageControl setCurrentPage: 0];
}

#pragma - mark click 事件

- (void)clickToBigPhoto:(UIButton *)btn
{
    FBPhotoBrowserController *browser = [[FBPhotoBrowserController alloc]init];
    browser.imagesArray = @[[UIImage imageNamed:@"geren_down46_46"],[UIImage imageNamed:@"haoyou_dianhua40_46"]];
    browser.showIndex = 1;
    browser.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark -
#pragma mark UIScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
	CGFloat pageWidth = photosScroll.bounds.size.width ;
    float fractionalPage = photosScroll.contentOffset.x / pageWidth ;
	NSInteger nearestNumber = lround(fractionalPage) ;
	
	if (pageControl.currentPage != nearestNumber)
	{
		pageControl.currentPage = nearestNumber ;
		
		// if we are dragging, we want to update the page control directly during the drag
		if (photosScroll.dragging)
			[pageControl updateCurrentPageDisplay] ;
	}
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.x);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
	// if we are animating (triggered by clicking on the page control), we update the page control
	[pageControl updateCurrentPageDisplay] ;
    
    NSLog(@"%f",aScrollView.contentOffset.x);
}

#pragma - mark 创建第二部分参数列表

- (void)createSecondSection
{
    NSArray *titles = @[@"车型:",@"价格:",@"库存:",@"外观颜色:",@"内饰颜色:",@"版本:",@"日期:",@"车辆详情:"];
    NSArray *titles2 = @[@"14款宝马740豪华型",@"120万 (指导价130万)",@"现车",@"红色",@"黑色",@"美规",@"2013.11.22",@"有车急售"];
    
    for (int i = 0; i < titles.count; i ++) {
        
        NSString *str = [titles objectAtIndex:i];
        NSString *str2 = [titles2 objectAtIndex:i];
        
        [self createLabelWithFrame:CGRectMake(10,firstBgView.bottom + 20 + (20 + 10)* i, 68, 20) normalTile:nil attributedTitle:[self richTextWithString:str] font:[UIFont boldSystemFontOfSize:14]];
        
        NSAttributedString *attribedStr = nil;
        if (i == 1) {
            attribedStr = [self priceString:str2];
            str2 = nil;
        }
        
        [self createLabelWithFrame:CGRectMake(90, firstBgView.bottom + 20 + (20 + 10)* i, 200, 20) normalTile:str2 attributedTitle:attribedStr font:[UIFont systemFontOfSize:14]];
    }
}

- (UILabel *)createLabelWithFrame:(CGRect)frame normalTile:(NSString *)normalTitle attributedTitle:(NSAttributedString *)attributedTitle font:(UIFont *)font
{
    UILabel *aLabel = [[UILabel alloc]initWithFrame:frame];
    aLabel.backgroundColor = [UIColor clearColor];

    if (attributedTitle) {
        [aLabel setAttributedText:attributedTitle];
    }
    if (normalTitle) {
        aLabel.text = normalTitle;
        aLabel.textColor = [UIColor lightGrayColor];
    }
    
    aLabel.textAlignment = NSTextAlignmentLeft;
    aLabel.font = font;
    [bigBgScroll addSubview:aLabel];
    
    return aLabel;
}


//处理两个字和四个字一样长

- (NSAttributedString *)richTextWithString:(NSString *)string
{
    NSMutableString *str = [NSMutableString stringWithString:string];
    NSString *keyStr = @"呵呵";
    
    //两个字的时候 中间插入两个字,然后设置为透明色
    if (str.length == 3) {
        [str insertString:keyStr atIndex:1];
    }
    
    NSMutableAttributedString *attibutedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",str]];
    
    [attibutedStr addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:[str rangeOfString:keyStr]];
    return attibutedStr;
}

- (NSAttributedString *)priceString:(NSString *)string
{
    NSRange left = [string rangeOfString:@"("];
    NSRange right = [string rangeOfString:@")"];
    NSRange new = NSMakeRange(left.location, right.location - left.location + 1);
    
    
    NSMutableString *str = [NSMutableString stringWithString:string];
    
    
    NSMutableAttributedString *attibutedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",str]];
    
    [attibutedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:new];
    [attibutedStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, left.location)];
    
    NSDictionary *attribs = @{NSFontAttributeName:[UIFont systemFontOfSize:25]};
    
    [attibutedStr addAttributes:attribs range:NSMakeRange(0, left.location)];
    
    return attibutedStr;
}

#pragma - mark 创建第三部分个人信息

- (void)createThirdSection
{
    UIView *thirdView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bottom - 75 - 44 - 20, 320, 75)];
    thirdView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:thirdView];
    
    DetailCell *cell = [[DetailCell alloc]initWithFrame:CGRectMake(0, 0, thirdView.width, thirdView.height)];
    cell.backgroundColor = [UIColor orangeColor];
    [thirdView addSubview:cell];
}


@end
