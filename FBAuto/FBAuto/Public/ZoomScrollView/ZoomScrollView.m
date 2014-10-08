//
//  ZoomImageView.m
//  TestImageAlbum
//
//  Created by lichaowei on 14-6-23.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "ZoomScrollView.h"

@implementation ZoomScrollView
{
    BOOL _isZoomed;//当前是否处于放大状态
    
    NSTimer * _tapTimer;//计时点击时间
    
    UIButton * placeHolderButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        self.delegate = self;
        self.contentMode = UIViewContentModeCenter;
        self.maximumZoomScale = 3.0;
        self.minimumZoomScale = 1.0;
        self.decelerationRate = .85;
        self.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        
        self.showsHorizontalScrollIndicator = NO;
        
        self.showsVerticalScrollIndicator = NO;
        
        
        
        // create the image view
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
//        _imageView.image = theImage;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];

    }
    return self;
}

- (void)setFrame:(CGRect)theFrame
{
	// store position of the image view if we're scaled or panned so we can stay at that point
	CGPoint imagePoint = _imageView.frame.origin;
	
	[super setFrame:theFrame];
	
	// update content size
	self.contentSize = CGSizeMake(theFrame.size.width * self.zoomScale, theFrame.size.height * self.zoomScale );
	
    NSLog(@"contentSize %f %f",self.contentSize.width,self.contentSize.height);
	// resize image view and keep it proportional to the current zoom scale
	_imageView.frame = CGRectMake( imagePoint.x, imagePoint.y, theFrame.size.width * self.zoomScale, theFrame.size.height * self.zoomScale);
}

#pragma - mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
	return _imageView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	
	if (touch.tapCount == 2) {
		[self stopTapTimer];
		
		if( _isZoomed )
		{
			_isZoomed = NO;
			[self setZoomScale:self.minimumZoomScale animated:YES];
		}
		else {
			
			_isZoomed = YES;
            
			// define a rect to zoom to.
			CGPoint touchCenter = [touch locationInView:self];
            
            //1/3 区域要放大
            
			CGSize zoomRectSize = CGSizeMake(self.frame.size.width / self.maximumZoomScale, self.frame.size.height / self.maximumZoomScale );
       
            //1/3 区域中心点
            
			CGRect zoomRect = CGRectMake( touchCenter.x - zoomRectSize.width * .5, touchCenter.y - zoomRectSize.height * .5, zoomRectSize.width, zoomRectSize.height );
            
            //下面四个判断 暂未发现什么用处
			
			// correct too far left
			if( zoomRect.origin.x < 0 )
				zoomRect = CGRectMake(0, zoomRect.origin.y, zoomRect.size.width, zoomRect.size.height );
			
			// correct too far up
			if( zoomRect.origin.y < 0 )
				zoomRect = CGRectMake(zoomRect.origin.x, 0, zoomRect.size.width, zoomRect.size.height );
			
			// correct too far right
			if( zoomRect.origin.x + zoomRect.size.width > self.frame.size.width )
				zoomRect = CGRectMake(self.frame.size.width - zoomRect.size.width, zoomRect.origin.y, zoomRect.size.width, zoomRect.size.height );
			
			// correct too far down
			if( zoomRect.origin.y + zoomRect.size.height > self.frame.size.height )
				zoomRect = CGRectMake( zoomRect.origin.x, self.frame.size.height - zoomRect.size.height, zoomRect.size.width, zoomRect.size.height );
			
			// zoom to it.
			[self zoomToRect:zoomRect animated:YES];
		}
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if([[event allTouches] count] == 1 ) {
		UITouch *touch = [[event allTouches] anyObject];
		if( touch.tapCount == 1 ) {
			if(_tapTimer ) [self stopTapTimer];
			[self startTapTimer];
		}
	}
}

#pragma - mark tap事件、区分单击和双击事件

- (void)startTapTimer
{
	_tapTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:.5] interval:.5 target:self selector:@selector(handleTap) userInfo:nil repeats:NO];
	[[NSRunLoop currentRunLoop] addTimer:_tapTimer forMode:NSDefaultRunLoopMode];
	
}
- (void)stopTapTimer
{
	if([_tapTimer isValid])
		[_tapTimer invalidate];
	
	_tapTimer = nil;
}

- (void)handleTap
{
    
//    if (_aDelegate && [_aDelegate respondsToSelector:@selector(singleClicked)]) {
//        [_aDelegate singleClicked];
//    }
    
//			[photoDelegate didTapPhotoView:self];
}



- (void)resetImageView:(UIImage *)theImage;
{
    self.imageView.image = theImage;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
