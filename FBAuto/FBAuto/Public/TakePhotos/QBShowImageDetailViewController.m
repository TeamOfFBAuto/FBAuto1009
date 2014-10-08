//
//  QBShowImageDetailViewController.m
//  FBCircle
//
//  Created by soulnear on 14-5-13.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "QBShowImageDetailViewController.h"

@interface QBShowImageDetailViewController ()

@end

@implementation QBShowImageDetailViewController
@synthesize AllImagesArray = _AllImagesArray;
@synthesize selectedAssets = _selectedAssets;
@synthesize myScrollView = _myScrollView;
@synthesize currentPage = _currentPage;
@synthesize allImages = _allImages;
@synthesize delegate = _delegate;
@synthesize SelectedCount = _SelectedCount;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


-(void)back
{
    [self ChangeSelectedData];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    
}

-(void)finishTap:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(returnSelectedImagesWith:)]) {
        [_delegate returnSelectedImagesWith:self.selectedAssets];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)PreviewChooseTap:(UIButton *)sender
{
    
    if (self.selectedAssets.count + self.SelectedCount == 9) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"最多只能选择9张照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        
        [alertView show];
        
        return;
    }
    
    
    BOOL isContains = [self.selectedAssets containsObject:[self.AllImagesArray objectAtIndex:_currentPage]];
    
    if (isContains) {
        [chooseButton setImage:[UIImage imageNamed:@"duihao-detail-up-46_46.png"] forState:UIControlStateNormal];
        
        [self.selectedAssets removeObject:[self.AllImagesArray objectAtIndex:_currentPage]];
    }else
    {
        [chooseButton setImage:[UIImage imageNamed:@"duihao-doun-46_46.png"] forState:UIControlStateNormal];
        
        [self.selectedAssets addObject:[self.AllImagesArray objectAtIndex:_currentPage]];
    }
    
    [self setFinishButtonState];
}


-(void)setNavgationBar
{
    
    navImageView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,70)];
    
    navImageView.backgroundColor = RGBCOLOR(229,229,229);
    
    [self.view addSubview:navImageView];
    
    
    UIImageView * daohangView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,64)];
    
    daohangView.image = FBAUTO_NAVIGATION_IMAGE;
    
    daohangView.userInteractionEnabled = YES;
    
    [navImageView addSubview:daohangView];
    
    
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(0,20,50,44)];
    
    [button_back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    //    [button_back setBackgroundImage:[UIImage imageNamed:@"FBQuanBackImage.png"] forState:UIControlStateNormal];
    
    [button_back setImage:FBAUTO_BACK_IMAGE forState:UIControlStateNormal];
    
    button_back.center = CGPointMake(16,42);
    
    [daohangView addSubview:button_back];
    
    title_label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,64)];
    
    title_label.text = [NSString stringWithFormat:@"%d/%lu",_currentPage+1,(unsigned long)self.AllImagesArray.count];
    
    title_label.font = [UIFont systemFontOfSize:14];
    
    title_label.textAlignment = NSTextAlignmentCenter;
    
    title_label.textColor = RGBCOLOR(91,138,59);
    
    title_label.center = CGPointMake(160,42);
    
    [daohangView addSubview:title_label];
    
    
    
    chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    chooseButton.frame = CGRectMake(0,0,30,30);
    
    [chooseButton setImage:[UIImage imageNamed:@"duihao-doun-46_46.png"] forState:UIControlStateNormal];
    
    [chooseButton addTarget:self action:@selector(PreviewChooseTap:) forControlEvents:UIControlEventTouchUpInside];
    
    chooseButton.center = CGPointMake(300,42);
    
    [daohangView addSubview:chooseButton];
    
    
    BOOL isContains = [self.selectedAssets containsObject:[self.AllImagesArray objectAtIndex:_currentPage]];
    
    if (isContains) {
        [chooseButton setImage:[UIImage imageNamed:@"duihao-doun-46_46.png"] forState:UIControlStateNormal];
        
    }else
    {
        [chooseButton setImage:[UIImage imageNamed:@"duihao-detail-up-46_46.png"] forState:UIControlStateNormal];
        
    }
    
    
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,(iPhone5?568:480)-44,320,44)];
    
    bottomView.backgroundColor = RGBCOLOR(254,254,254);
    
    [self.view addSubview:bottomView];
    
    
    finish_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    finish_button.frame = CGRectMake(262,9,102/2,54/2);
    
    [finish_button addTarget:self action:@selector(finishTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:finish_button];
    
    UILabel * finish_label = [[UILabel alloc] initWithFrame:finish_button.bounds];
    
    finish_label.backgroundColor = [UIColor clearColor];
    
    finish_label.text = @"完成";
    
    finish_label.textAlignment = NSTextAlignmentCenter;
    
    finish_label.textColor = [UIColor whiteColor];
    
    [finish_button addSubview:finish_label];
    
    
    selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,20,20)];
    
    selectedLabel.textColor = [UIColor whiteColor];
    
    selectedLabel.textAlignment = NSTextAlignmentCenter;
    
    selectedLabel.center = CGPointMake(0,0);
    
    selectedLabel.layer.masksToBounds = YES;
    
    selectedLabel.layer.cornerRadius = 10;
    
    selectedLabel.font = [UIFont systemFontOfSize:16];
    
    selectedLabel.backgroundColor = [UIColor redColor];
    
    [finish_button addSubview:selectedLabel];
    
    [self setFinishButtonState];
    
}

-(void)setFinishButtonState
{
    [finish_button setImage:[UIImage imageNamed:self.selectedAssets.count?@"wnacheng-button-kedian-100_58.png":@"choosePictureFinishNo.png"] forState:UIControlStateNormal];
    
    finish_button.enabled = self.selectedAssets.count?YES:NO;
    
    selectedLabel.text = [NSString stringWithFormat:@"%d",self.selectedAssets.count];
    
    selectedLabel.hidden = self.selectedAssets.count?NO:YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    for (UIView * view in _myScrollView.subviews)
    {
        
        if ([view isKindOfClass:[QBShowImagesScrollView class]])
        {
            [(QBShowImagesScrollView *)view locationImageView].image = nil;
        }
        
        [view removeFromSuperview];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = RGBCOLOR(229,229,229);
    
    _allImages = [NSMutableArray array];
    
    
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,340,iPhone5?568:480)];
    
    _myScrollView.delegate = self;
    
    _myScrollView.pagingEnabled = YES;
    
    _myScrollView.backgroundColor = RGBCOLOR(242,242,242);
    
    _myScrollView.showsHorizontalScrollIndicator = NO;
    
    _myScrollView.showsHorizontalScrollIndicator = NO;
    
    _myScrollView.contentSize = CGSizeMake(340*self.AllImagesArray.count,0);
    
    [self.view addSubview:_myScrollView];
    
    _myScrollView.contentOffset = CGPointMake(340*_currentPage,0);
    
    [self setNavgationBar];
    
    [self loadThreePage];
    
    
}



-(void)getAllImages
{
    __weak typeof(self) bself = self;
    
    __block UIImage * image = nil;
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        
        for (int i = 0;i < bself.currentPage;i++) {
            
            ALAsset *asset = [bself.AllImagesArray objectAtIndex:i];
            
            image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            
            [bself.allImages replaceObjectAtIndex:i withObject:image];
        }
        
        
        for (int i = bself.currentPage;i < bself.AllImagesArray.count;i++) {
            ALAsset *asset = [bself.AllImagesArray objectAtIndex:i];
            
            image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            
            [bself.allImages replaceObjectAtIndex:i withObject:image];
        }
    });
}



-(void)createShowViewWithAsset:(ALAsset *)asset WithFrame:(CGRect)frame WithTag:(int)tag
{
    QBShowImagesScrollView * ScrollView = [[QBShowImagesScrollView alloc] initWithFrame:frame WithLocation:nil];
    
    ScrollView.aDelegate = self;
    
    ScrollView.tag = tag;
    
    ScrollView.backgroundColor = RGBCOLOR(242,242,242);
    
    [_myScrollView addSubview:ScrollView];
    
    UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [ScrollView resetImageView:tempImg];
        
    });
}



-(void)loadThreePage
{
    for (UIView * view in _myScrollView.subviews)
    {
        if ([view isKindOfClass:[QBShowImagesScrollView class]])
        {
            if (fabs((view.tag-1000)-_currentPage) > 3)
            {
                [(QBShowImagesScrollView *)view locationImageView].image = nil;
                
                [view removeFromSuperview];
            }
        }
    }
    
    
    for (int i = _currentPage-1;i < _currentPage+2;i++)
    {
        QBShowImagesScrollView * view = (QBShowImagesScrollView *)[_myScrollView viewWithTag:(1000+i)];
        
        if (!view)
        {
            if (i >= 0 && i < self.AllImagesArray.count)
            {
                __weak typeof(self) bself = self;
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                    });
                    
                    ALAsset *asset= bself.AllImagesArray[i];
                    
                    [bself createShowViewWithAsset:asset WithFrame:CGRectMake(340*i,0,320,_myScrollView.frame.size.height) WithTag:(1000+i)];
                });
            }
        }
    }
    
}


- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = _myScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * 10);
    pageFrame.origin.x = (bounds.size.width * index) + 10;
    return pageFrame;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    _currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    title_label.text = [NSString stringWithFormat:@"%d/%lu",_currentPage+1,(unsigned long)self.AllImagesArray.count];
    
    if ([self.selectedAssets containsObject:[self.AllImagesArray objectAtIndex:_currentPage]]) {
        
        [chooseButton setImage:[UIImage imageNamed:@"duihao-doun-46_46.png"] forState:UIControlStateNormal];
    }else
    {
        [chooseButton setImage:[UIImage imageNamed:@"duihao-detail-up-46_46.png"] forState:UIControlStateNormal];
    }
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self loadThreePage];
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}



-(void)ChangeSelectedData
{
    for (int i = 0;i < self.selectedAssets.count;i++) {
        if (identifier[i]) {
            [self.selectedAssets removeObjectAtIndex:i];
        }
    }
}



#pragma mark-QBShowImagesScrollViewDelegate

-(void)singleClicked
{
    UIApplication * app = [UIApplication sharedApplication];
    
    [self hiddenToolBar:!app.statusBarHidden];
}



-(void)hiddenToolBar:(BOOL)isHidden
{
    [[UIApplication sharedApplication] setStatusBarHidden:isHidden withAnimation:UIStatusBarAnimationSlide];
    
    CGRect rect = bottomView.frame;
    
    rect.origin.y = rect.origin.y + (isHidden?rect.size.height:-rect.size.height);
    
    CGRect frame = navImageView.frame;
    
    frame.origin.y = frame.origin.y + (isHidden?-frame.size.height:frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        bottomView.frame = rect;
        navImageView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dealloc
{
    
    
}


- (BOOL)shouldAutorotate
{
    return NO;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
