/*
 Copyright (c) 2013 Katsuma Tanaka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "QBAssetCollectionViewController.h"

// Views
#import "QBImagePickerAssetCell.h"
#import "QBImagePickerFooterView.h"
#import "QBImagePickerAssetView.h"

@interface QBAssetCollectionViewController ()
{
    UILabel * preview_label;
    UIButton * tishi_button;
    UIButton * preview_button;
}


@property (nonatomic, retain) NSMutableOrderedSet *selectedAssets;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIBarButtonItem *doneButton;
@property(nonatomic,strong)UITableView * showTableView;

- (void)reloadData;
- (void)updateRightBarButtonItem;
- (void)updateDoneButton;
- (void)done;
- (void)cancel;

@end

@implementation QBAssetCollectionViewController
@synthesize assets = _assets;
@synthesize selectedArray = _selectedArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self)
    {
        
  
    }
    
    return self;
}

-(void)backH
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //    [MobClick endEvent:@"QBAssetCollectionViewController"];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:FBAUTO_NAVIGATION_IMAGE forBarMetrics: UIBarMetricsDefault];
    
    UIBarButtonItem * spaceBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    spaceBar.width = -5;
    
    
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(10,8,10,19)];
    
    [button_back addTarget:self action:@selector(backH) forControlEvents:UIControlEventTouchUpInside];
    
    [button_back setBackgroundImage:FBAUTO_NAVIGATION_IMAGE forState:UIControlStateNormal];
    
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
    
    self.navigationItem.leftBarButtonItems=@[spaceBar,back_item];
    
    [back_item release];
    
    [button_back release];
    
    
    
    self.title = @"存储的照片";
    
    
    /* Initialization */
    self.assets = [NSMutableArray array];
    self.selectedAssets = [NSMutableOrderedSet orderedSet];
    
    self.imageSize = CGSizeMake(75, 75);
    
    // Table View
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,6,320,(iPhone5?568:480)-6-20-44-89/2) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = YES;
    //        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.tag = 100;
    [tableView release];
    
    
    
    image_array = [[NSMutableArray alloc] init];
    
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,(iPhone5?568:480)-64-89/2,320,89/2)];
    
    imageView.image = [UIImage imageNamed:@"ChoosePictureBackGroundImage.png"];
    
    imageView.userInteractionEnabled = YES;
    
    imageView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:imageView];
    
    tishi_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    tishi_button.frame = CGRectMake(266,11,100/2,58/2);
    
    [tishi_button addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    
    
    [imageView addSubview:tishi_button];
    
    
    
    UILabel * finish_label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100/2,58/2)];
    
    finish_label.text = @"完成";
    
    finish_label.textAlignment = NSTextAlignmentCenter;
    
    finish_label.backgroundColor = [UIColor clearColor];
    
    finish_label.textAlignment = NSTextAlignmentCenter;
    
    finish_label.textColor = [UIColor whiteColor];
    
    finish_label.font = [UIFont systemFontOfSize:14];
    
    [tishi_button addSubview:finish_label];
    
    
    
    preview_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    preview_button.frame = CGRectMake(4,11,100/2,58/2);
    
    [preview_button addTarget:self action:@selector(PreviewTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:preview_button];
    
    
    
    preview_label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100/2,58/2)];
    
    preview_label.backgroundColor = [UIColor clearColor];
    
    preview_label.textAlignment = NSTextAlignmentCenter;
    
    preview_label.textColor = RGBCOLOR(153,153,153);
    
    preview_label.font = [UIFont systemFontOfSize:13];
    
    [preview_button addSubview:preview_label];
    
    
    preview_label.text = @"预览";
    
    [preview_button setImage:[UIImage imageNamed:@"yulan-button-bukedian-100_58.png"] forState:UIControlStateNormal];
    
    [tishi_button setImage:[UIImage imageNamed:@"wnacheng-button-bukedian-100_58.png"] forState:UIControlStateNormal];
    
    
    [self reloadData];
    
    
    
    if(self.fullScreenLayoutEnabled) {
        // Set bar styles
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.translucent = YES;
        
        CGFloat top = 0;
        if(![[UIApplication sharedApplication] isStatusBarHidden]) top = top + 20;
        if(!self.navigationController.navigationBarHidden) top = top + 44;
    }
    
    if (self.selectedAssets.count == 0) {
        preview_label.text = @"预览";
    }else
    {
        preview_label.text = [NSString stringWithFormat:@"预览(%d)",self.selectedAssets.count];
    }
    
    
    
    // Scroll to bottom
    //    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    NSUInteger sectionCount = [self.tableView numberOfSections];
    if (sectionCount) {
        
        NSUInteger rowCount = [self.tableView numberOfRowsInSection:sectionCount-1];
        if (rowCount) {
            
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:rowCount-1 inSection:sectionCount-1];
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    [MobClick beginEvent:@"QBAssetCollectionViewController"];
    
    // Reloads
    
    [self.tableView reloadData];
   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Flash scroll indicators
    [self.tableView flashScrollIndicators];
}

- (void)setShowsCancelButton:(BOOL)showsCancelButton
{
    _showsCancelButton = showsCancelButton;
    
    [self updateRightBarButtonItem];
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    _allowsMultipleSelection = allowsMultipleSelection;
    
    [self updateRightBarButtonItem];
}

- (void)dealloc
{
    [_assetsGroup release];
    
    [_assets release];
    [_selectedAssets release];
    
    [_tableView release];
    [_doneButton release];
    
    [super dealloc];
}


#pragma mark - Instance Methods

- (void)reloadData
{
    
    if (self.assets) {
        [self.assets removeAllObjects];
    }
    
    // Reload assets
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result) {
            [self.assets addObject:result];
            //            [self.assets insertObject:result atIndex:0];
        }
    }];
    
    [self.tableView reloadData];
    
    // Set footer view
    if(self.showsFooterDescription) {
        [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
        NSUInteger numberOfPhotos = self.assetsGroup.numberOfAssets;
        
        [self.assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
        NSUInteger numberOfVideos = self.assetsGroup.numberOfAssets;
        
        switch(self.filterType) {
            case QBImagePickerFilterTypeAllAssets:
                [self.assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
                break;
            case QBImagePickerFilterTypeAllPhotos:
                [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
                break;
            case QBImagePickerFilterTypeAllVideos:
                [self.assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
                break;
        }
        
        QBImagePickerFooterView *footerView = [[QBImagePickerFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 48)];
        
        if(self.filterType == QBImagePickerFilterTypeAllAssets) {
            footerView.titleLabel.text = [self.delegate assetCollectionViewController:self descriptionForNumberOfPhotos:numberOfPhotos numberOfVideos:numberOfVideos];
        } else if(self.filterType == QBImagePickerFilterTypeAllPhotos) {
            footerView.titleLabel.text = [self.delegate assetCollectionViewController:self descriptionForNumberOfPhotos:numberOfPhotos];
        } else if(self.filterType == QBImagePickerFilterTypeAllVideos) {
            footerView.titleLabel.text = [self.delegate assetCollectionViewController:self descriptionForNumberOfVideos:numberOfVideos];
        }
        
        self.tableView.tableFooterView = footerView;
        [footerView release];
    } else {
        QBImagePickerFooterView *footerView = [[QBImagePickerFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 4)];
        
        self.tableView.tableFooterView = footerView;
        [footerView release];
    }
}



- (void)updateRightBarButtonItem
{
    UIBarButtonItem * spaceBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    spaceBar.width = -5;
    
    
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(10,8,31/2,32/2)];
    
    [button_back addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    [button_back setBackgroundImage:[UIImage imageNamed:@"logIn_close.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
    
    self.navigationItem.rightBarButtonItems=@[spaceBar,back_item];
    
    [back_item release];
    
    [button_back release];
}

- (void)updateDoneButton
{
    if(self.limitsMinimumNumberOfSelection) {
        self.doneButton.enabled = (self.selectedAssets.count >= self.minimumNumberOfSelection);
    } else {
        self.doneButton.enabled = (self.selectedAssets.count > 0);
    }
}


-(void)PreviewTap:(UIButton *)sender
{
    if (self.selectedAssets.count == 0) {
        return;
    }
    
    QBShowImageDetailViewController * showImageV = [[QBShowImageDetailViewController alloc] init];
    
    showImageV.selectedAssets = self.selectedAssets;
    
    showImageV.SelectedCount = self.selectedArray.count;
    
    showImageV.AllImagesArray = [NSMutableArray arrayWithArray:self.selectedAssets.array];
    
    showImageV.delegate = self;
    
    [self.navigationController pushViewController:showImageV animated:YES];
    
}


- (void)done
{
    [self.delegate assetCollectionViewController:self didFinishPickingAssets:self.selectedAssets.array];
}

- (void)cancel
{
    [self.delegate assetCollectionViewControllerDidCancel:self];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 100)
    {
        return 3;
    }else
    {
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 100)
    {
        NSInteger numberOfRowsInSection = 0;
        
        switch(section) {
            case 0: case 1:
            {
                if(self.allowsMultipleSelection && !self.limitsMaximumNumberOfSelection && self.showsHeaderButton) {
                    numberOfRowsInSection = 1;
                }
            }
                break;
            case 2:
            {
                NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
                numberOfRowsInSection = self.assets.count / numberOfAssetsInRow;
                if((self.assets.count - numberOfRowsInSection * numberOfAssetsInRow) > 0) numberOfRowsInSection++;
            }
                break;
        }
        
        return numberOfRowsInSection;
        
    }else
    {
        
        return self.selectedAssets.array.count;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100)
    {
        UITableViewCell *cell = nil;
        
        switch(indexPath.section) {
            case 0:
            {
                NSString *cellIdentifier = @"HeaderCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if(cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                }
                
            }
                break;
            case 1:
            {
                NSString *cellIdentifier = @"SeparatorCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if(cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    // Set background view
                    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
                    backgroundView.backgroundColor = [UIColor colorWithWhite:0.878 alpha:1.0];
                    
                    cell.backgroundView = backgroundView;
                    [backgroundView release];
                }
            }
                break;
            case 2:
            {
                NSString *cellIdentifier = @"AssetCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if(cell == nil)
                {
                    NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
                    CGFloat margin = round((self.view.bounds.size.width - self.imageSize.width * numberOfAssetsInRow) / (numberOfAssetsInRow + 1));
                    
                    cell = [[[QBImagePickerAssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier imageSize:self.imageSize numberOfAssets:numberOfAssetsInRow margin:margin indexPath:indexPath] autorelease];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [(QBImagePickerAssetCell *)cell setDelegate:self];
                    [(QBImagePickerAssetCell *)cell setAllowsMultipleSelection:self.allowsMultipleSelection];
                    [(QBImagePickerAssetCell *)cell setSelected_array:self.selectedArray];
                    
                }
                
                [(QBImagePickerAssetCell *)cell theIndexPath:indexPath];
                
                // Set assets
                NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
                NSInteger offset = numberOfAssetsInRow * indexPath.row;
                NSInteger numberOfAssetsToSet = (offset + numberOfAssetsInRow + 1 > self.assets.count) ? (self.assets.count - offset) : numberOfAssetsInRow;
                
                NSMutableArray *assets = [NSMutableArray array];
                
                
                for(NSUInteger i = 0; i < numberOfAssetsToSet; i++)
                {
                    ALAsset *asset = [self.assets objectAtIndex:(offset + i)];
                    
                    [assets addObject:asset];
                }
                
                [(QBImagePickerAssetCell *)cell setAssets:assets WithSelected:self.selectedAssets];
            }
                break;
        }
        
        return cell;
    }else
    {
        UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
        
        if (cell==nil) {
            cell=[[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            UIView* rotateView=[[UIView alloc] initWithFrame:CGRectMake(2, 3, 44,44)];
            [rotateView setBackgroundColor:[UIColor blueColor]];
            rotateView.userInteractionEnabled = YES;
            rotateView.transform=CGAffineTransformMakeRotation(M_PI * 90 / 180);
            [cell.contentView addSubview:rotateView];
            [rotateView release];
            
            
            ALAsset *asset = [self.selectedAssets.array objectAtIndex:indexPath.row];
            
            NSMutableDictionary *mediaInfo = [NSMutableDictionary dictionary];
            [mediaInfo setObject:[asset valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
            
            UIImage * image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            [mediaInfo setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:@"UIImagePickerControllerReferenceURL"];
            
            
            UIButton * imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            imageButton.frame = CGRectMake(0, 0, 44, 44);
            imageButton.tag = indexPath.row;
            [imageButton setImage:image forState:UIControlStateNormal];
            [imageButton addTarget:self action:@selector(reomveSelf:) forControlEvents:UIControlEventTouchUpInside];
            [rotateView addSubview:imageButton];
        }
        return cell;
    }
    
}


-(void)reomveSelf:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self.selectedAssets removeObjectAtIndex:button.tag];
    [self.showTableView reloadData];
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100)
    {
        CGFloat heightForRow = 0;
        
        switch(indexPath.section) {
            case 0:
            {
                heightForRow = 0;
            }
                break;
            case 1:
            {
                heightForRow = 1;
            }
                break;
            case 2:
            {
                NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
                CGFloat margin = round((self.view.bounds.size.width - self.imageSize.width * numberOfAssetsInRow) / (numberOfAssetsInRow + 1));
                heightForRow = margin + self.imageSize.height;
            }
                break;
        }
        
        return heightForRow;
    }else
    {
        return 50;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100)
    {
        if(indexPath.section == 0 && indexPath.row == 0) {
            if(self.selectedAssets.count == self.assets.count) {
                // Deselect all assets
                [self.selectedAssets removeAllObjects];
            } else {
                // Select all assets
                [self.selectedAssets addObjectsFromArray:self.assets];
            }
            
            // Set done button state
            [self updateDoneButton];
            
            // Update assets
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            
            // Update header text
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            
            // Cancel table view selection
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    
}


#pragma mark - QBImagePickerAssetCellDelegate


- (BOOL)assetCell:(QBImagePickerAssetCell *)assetCell canSelectAssetAtIndex:(NSUInteger)index
{
    BOOL canSelect = YES;
    
    if(self.allowsMultipleSelection && self.limitsMaximumNumberOfSelection) {
        canSelect = (self.selectedAssets.count < self.maximumNumberOfSelection);
    }
    
    return canSelect;
}

- (void)assetCell:(QBImagePickerAssetCell *)assetCell didChangeAssetSelectionState:(BOOL)selected atIndex:(NSUInteger)index withAssetView:(QBImagePickerAssetView *)asset1111
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:assetCell];
    
    NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
    NSInteger assetIndex = indexPath.row * numberOfAssetsInRow + index;
    ALAsset *asset = [self.assets objectAtIndex:assetIndex];
    
    
    NSMutableDictionary *mediaInfo = [NSMutableDictionary dictionary];
    [mediaInfo setObject:[asset valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
    
//    UIImage * image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
    [mediaInfo setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:@"UIImagePickerControllerReferenceURL"];
    
    if(self.allowsMultipleSelection)
    {
        if(selected)
        {
            if (self.selectedAssets.count >= 9-self.selectedArray.count)
            {
                asset1111.selected = NO;
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"最多选择%d张图片",9-(int)self.selectedArray.count] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                
                currentPage++;
            }else
            {
                [self.selectedAssets addObject:asset];
            }
            
        }else
        {
            currentPage--;
            
//            NSLog(@"self.selected -----   %d",self.selectedAssets.count);
            
            [self.selectedAssets removeObject:asset];
            
        }
        // Set done button state
        [self updateDoneButton];
        
        [preview_button setImage:[UIImage imageNamed:self.selectedAssets.count?@"yulan-button-kedian-100_58.png":@"yulan-button-bukedian-100_58.png"] forState:UIControlStateNormal];
        
        
        [tishi_button setImage:[UIImage imageNamed:self.selectedAssets.count?@"wnacheng-button-kedian-100_58.png":@"wnacheng-button-bukedian-100_58.png"] forState:UIControlStateNormal];
        
        if (self.selectedAssets.count == 0) {
            preview_label.text = @"预览";
            preview_label.textColor = RGBCOLOR(153,153,153);
        }else
        {
            preview_label.textColor = RGBCOLOR(95,95,95);
            preview_label.text = [NSString stringWithFormat:@"预览(%d)",self.selectedAssets.count];
        }
        
        
    } else
    {
        [self.delegate assetCollectionViewController:self didFinishPickingAsset:asset];
    }
}



-(void)PushToPreviewControllerAtIndex:(int)index WitCell:(QBImagePickerAssetCell *)assetCell
{
    QBShowImageDetailViewController * QBShowImageV = [[QBShowImageDetailViewController alloc] init];
    
    QBShowImageV.delegate = self;
    
    QBShowImageV.SelectedCount = self.selectedArray.count;
    
    QBShowImageV.selectedAssets = self.selectedAssets;
    
    QBShowImageV.AllImagesArray = self.assets;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:assetCell];
    
    int page = indexPath.row*4 + index;
    
    QBShowImageV.currentPage = page;
    
    [self.navigationController pushViewController:QBShowImageV animated:YES];
    
}



-(void)returnSelectedImagesWith:(NSMutableOrderedSet *)assets
{
    if (_delegate && [_delegate respondsToSelector:@selector(assetCollectionViewController:didFinishPickingAssets:)]) {
        [_delegate assetCollectionViewController:self didFinishPickingAssets:assets.array];
    }
}




@end


















