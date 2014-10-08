/*
 Copyright (c) 2013 Katsuma Tanaka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "QBImagePickerAssetCell.h"

// Views
#import "QBImagePickerAssetView.h"

@interface QBImagePickerAssetCell ()

- (void)addAssetViews:(NSIndexPath *)indexPath;

@end

@implementation QBImagePickerAssetCell
@synthesize nowIndexPath = _nowIndexPath;
@synthesize selected_array = _selected_array;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageSize:(CGSize)imageSize numberOfAssets:(NSUInteger)numberOfAssets margin:(CGFloat)margin indexPath:(NSIndexPath *)indexPath
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        totalPage = 0;
        self.imageSize = imageSize;
        self.numberOfAssets = numberOfAssets;
        self.margin = margin;
        
        
    }
    
    return self;
}

- (void)setAssets:(NSArray *)assets WithSelected:(NSMutableOrderedSet *)theSelected
{
    [_assets release];
    _assets = [assets retain];
    
    // Set assets
    for(NSUInteger i = 0; i < self.numberOfAssets; i++)
    {
        QBImagePickerAssetView *assetView = (QBImagePickerAssetView *)[self.contentView viewWithTag:(1 + i)];
        
        if(i < self.assets.count)
        {
            assetView.hidden = NO;
            
            assetView.asset = [self.assets objectAtIndex:i];
            
            for (ALAsset * temp in theSelected) {
                
                if ([temp.defaultRepresentation.url isEqual:assetView.asset.defaultRepresentation.url]) {
                    
                    assetView.selected = YES;
                }
            }
            
        } else
        {
            assetView.hidden = YES;
        }
    }
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    _allowsMultipleSelection = allowsMultipleSelection;
    
    // Set property
    for(UIView *subview in self.contentView.subviews) {
        if([subview isMemberOfClass:[QBImagePickerAssetView class]]) {
            [(QBImagePickerAssetView *)subview setAllowsMultipleSelection:self.allowsMultipleSelection];
        }
    }
}

- (void)dealloc
{
    [_assets release];
    
    [super dealloc];
}


#pragma mark - Instance Methods

-(void)theIndexPath:(NSIndexPath *)indexPath
{
    self.nowIndexPath = indexPath;
    [self addAssetViews:indexPath];
}

- (void)addAssetViews:(NSIndexPath *)indexPath
{
    // Remove all asset views
    for(UIView *subview in self.contentView.subviews)
    {
        if([subview isMemberOfClass:[QBImagePickerAssetView class]])
        {
            [subview removeFromSuperview];
        }
    }
    
    // Add asset views
    for(NSUInteger i = 0; i < self.numberOfAssets ; i++)
    {
        // Calculate frame
        CGFloat offset = (self.margin + self.imageSize.width) * i;
        CGRect assetViewFrame = CGRectMake(offset + self.margin, self.margin, self.imageSize.width, self.imageSize.height);
        // Add asset view
        QBImagePickerAssetView *assetView = [[QBImagePickerAssetView alloc] initWithFrame:assetViewFrame];
        assetView.delegate = self;
        assetView.tag = 1 + i;
        //            NSLog(@"assetView.tag ----  %d",assetView.tag);
        assetView.autoresizingMask = UIViewAutoresizingNone;
        
        [self.contentView addSubview:assetView];
        [assetView release];
        
    }
    
    
}

- (void)selectAssetAtIndex:(NSUInteger)index
{
    QBImagePickerAssetView *assetView = (QBImagePickerAssetView *)[self.contentView viewWithTag:(index + 1)];
    assetView.selected = YES;
}

- (void)deselectAssetAtIndex:(NSUInteger)index
{
    QBImagePickerAssetView *assetView = (QBImagePickerAssetView *)[self.contentView viewWithTag:(index + 1)];
    assetView.selected = NO;
}

- (void)selectAllAssets
{
    
    for(UIView *subview in self.contentView.subviews) {
        if([subview isMemberOfClass:[QBImagePickerAssetView class]]) {
            if(![(QBImagePickerAssetView *)subview isHidden]) {
                [(QBImagePickerAssetView *)subview setSelected:YES];
            }
        }
    }
}

- (void)deselectAllAssets
{
    
    for(UIView *subview in self.contentView.subviews) {
        if([subview isMemberOfClass:[QBImagePickerAssetView class]]) {
            if(![(QBImagePickerAssetView *)subview isHidden]) {
                [(QBImagePickerAssetView *)subview setSelected:NO];
            }
        }
    }
}


#pragma mark - QBImagePickerAssetViewDelegate

- (BOOL)assetViewCanBeSelected:(QBImagePickerAssetView *)assetView
{
    return [self.delegate assetCell:self canSelectAssetAtIndex:(assetView.tag - 1)];
}

- (void)assetView:(QBImagePickerAssetView *)assetView didChangeSelectionState:(BOOL)selected
{
    if (totalPage>9)
    {
        assetView.selected = NO;
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"最多选择9张图片"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    [self.delegate assetCell:self didChangeAssetSelectionState:selected atIndex:(assetView.tag - 1) withAssetView:assetView];
}


-(void)pushToPreViewControllerWith:(QBImagePickerAssetView *)assetView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(PushToPreviewControllerAtIndex:WitCell:)]) {
        [self.delegate PushToPreviewControllerAtIndex:((int)assetView.tag-1) WitCell:self];
    }
}



@end








