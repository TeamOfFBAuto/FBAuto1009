/*
 Copyright (c) 2013 Katsuma Tanaka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "QBImagePickerAssetView.h"

// Views
#import "QBImagePickerVideoInfoView.h"

@interface QBImagePickerAssetView ()

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) QBImagePickerVideoInfoView *videoInfoView;

- (UIImage *)thumbnail;
- (UIImage *)tintedThumbnail;

@end

@implementation QBImagePickerAssetView
@synthesize overlayImageView = _overlayImageView;
@synthesize translucentLayer = _translucentLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        /* Initialization */
        // Image View
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        self.imageView = imageView;
        [imageView release];
        
        // Video Info View
        QBImagePickerVideoInfoView *videoInfoView = [[QBImagePickerVideoInfoView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 17, self.bounds.size.width, 17)];
        videoInfoView.hidden = YES;
        videoInfoView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        [self addSubview:videoInfoView];
        self.videoInfoView = videoInfoView;
        [videoInfoView release];
        
        
        _translucentLayer = [[UIImageView alloc] initWithFrame:self.bounds];
        _translucentLayer.contentMode = UIViewContentModeScaleAspectFill;
        _translucentLayer.clipsToBounds = YES;
        _translucentLayer.backgroundColor = [UIColor clearColor];
        _translucentLayer.hidden = YES;
        _translucentLayer.image = [UIImage imageNamed:@"bantoumingLayer.png"];
        _translucentLayer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:_translucentLayer];
        
        
        // Overlay Image View
        UIImageView *overlayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(49,3,23,23)];
//        overlayImageView.contentMode = UIViewContentModeScaleAspectFill;
        overlayImageView.clipsToBounds = YES;
        overlayImageView.userInteractionEnabled = YES;
//        overlayImageView.backgroundColor = [UIColor clearColor];
        overlayImageView.image = [UIImage imageNamed:@"duihao-up-46_46.png"];
//        overlayImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // Overlay Image View
//        UIButton *overlayImageView = [UIButton buttonWithType:UIButtonTypeCustom];
//        overlayImageView.frame = CGRectMake(42,3,30,30);
//        overlayImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
//        overlayImageView.imageView.clipsToBounds = YES;
//        overlayImageView.backgroundColor = [UIColor clearColor];
//        [overlayImageView setImage:[UIImage imageNamed:@"duihaochoosePhotoMarkNo.png"] forState:UIControlStateNormal];
//        overlayImageView.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        [overlayImageView addTarget:self action:@selector(selectedPictures:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:overlayImageView];
        self.overlayImageView = overlayImageView;
        [overlayImageView release];
    
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        
        [imageView addGestureRecognizer:tap];
        
        
        UITapGestureRecognizer * selectedTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedPictures)];
        
        [overlayImageView addGestureRecognizer:selectedTap];
    }
    
    return self;
}

- (void)setAsset:(ALAsset *)asset
{
    [_asset release];
    _asset = [asset retain];
    
    // Set thumbnail image
    self.imageView.image = [self thumbnail];
    
    if([self.asset valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo) {
        double duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
        
        self.videoInfoView.hidden = NO;
        self.videoInfoView.duration = round(duration);
    } else {
        self.videoInfoView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected
{
//    [self.overlayImageView setImage:[UIImage imageNamed:selected?@"duihaochoosePhotoMarkOk.png":@"duihaochoosePhotoMarkNo.png"] forState:UIControlStateNormal];
    self.overlayImageView.image = [UIImage imageNamed:selected?@"duihao-doun-46_46.png":@"duihao-up-46_46.png"];
    self.translucentLayer.hidden = !selected;
    
}

- (BOOL)selected
{
    return !self.translucentLayer.hidden;
}

- (void)dealloc
{
    [_asset release];
    
    [_imageView release];
    [_videoInfoView release];
    [_overlayImageView release];
    
    [super dealloc];
}


//#pragma mark - Touch Events
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if([self.delegate assetViewCanBeSelected:self] && !self.allowsMultipleSelection) {
//        self.imageView.image = [self tintedThumbnail];
//    }
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if([self.delegate assetViewCanBeSelected:self]) {
//        self.selected = !self.selected;
//
//        if(self.allowsMultipleSelection) {
//            self.imageView.image = [self thumbnail];
//        } else {
//            self.imageView.image = [self tintedThumbnail];
//        }
//
//        [self.delegate assetView:self didChangeSelectionState:self.selected];
//    } else {
//        if(self.allowsMultipleSelection && self.selected) {
//            self.selected = !self.selected;
//            self.imageView.image = [self thumbnail];
//
//            [self.delegate assetView:self didChangeSelectionState:self.selected];
//        } else {
//            self.imageView.image = [self thumbnail];
//        }
//
//        [self.delegate assetView:self didChangeSelectionState:self.selected];
//    }
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    self.imageView.image = [self thumbnail];
//}


#pragma mark - Instance Methods

- (UIImage *)thumbnail
{
    return [UIImage imageWithCGImage:[self.asset thumbnail]];
}

- (UIImage *)tintedThumbnail
{
    UIImage *thumbnail = [self thumbnail];
    
    UIGraphicsBeginImageContext(thumbnail.size);
    
    CGRect rect = CGRectMake(0, 0, thumbnail.size.width, thumbnail.size.height);
    [thumbnail drawInRect:rect];
    
    [[UIColor colorWithWhite:0 alpha:0] set];
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceAtop);
    
    UIImage *tintedThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tintedThumbnail;
}


-(void)doTap:(UITapGestureRecognizer *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToPreViewControllerWith:)]) {
        [self.delegate pushToPreViewControllerWith:self];
    }
}

-(void)selectedPictures
{
    self.selected = !self.selected;
    
    if(self.allowsMultipleSelection) {
        self.imageView.image = [self thumbnail];
    } else {
        self.imageView.image = [self tintedThumbnail];
    }
    
    [self.delegate assetView:self didChangeSelectionState:self.selected];
}




@end
