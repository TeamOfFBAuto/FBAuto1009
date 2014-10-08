//
//  QBShowImagesScrollView.m
//  FBCircle
//
//  Created by soulnear on 14-5-13.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "QBShowImagesScrollView.h"



#define kMaxZoom 3.0



@implementation QBShowImagesScrollView
@synthesize locationImageView = _locationImageView;
@synthesize asyImageView = _asyImageView;
@synthesize aDelegate = _aDelegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


-(QBShowImagesScrollView *)initWithFrame:(CGRect)frame WithLocation:(UIImage *)theImage
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
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
        
        // create outline
        //        [self.layer setBorderWidth:1.0];
        //        [self.layer setBorderColor:[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:.25] CGColor]];
        
        
        
        // create the image view
        _locationImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        _locationImageView.image = theImage;
        _locationImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_locationImageView];
        
    }
    
    return self;
}


- (void)setFrame:(CGRect)theFrame
{
	// store position of the image view if we're scaled or panned so we can stay at that point
	CGPoint imagePoint = _locationImageView.frame.origin;
	
	[super setFrame:theFrame];
	
	// update content size
	self.contentSize = CGSizeMake(theFrame.size.width * self.zoomScale, theFrame.size.height * self.zoomScale );
	
	// resize image view and keep it proportional to the current zoom scale
	_locationImageView.frame = CGRectMake( imagePoint.x, imagePoint.y, theFrame.size.width * self.zoomScale, theFrame.size.height * self.zoomScale);
}



-(QBShowImagesScrollView *)initWithFrame:(CGRect)frame WithUrl:(NSString *)theUrl
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
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
        
        
        _locationImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        _locationImageView.contentMode = UIViewContentModeScaleAspectFit;
        _locationImageView.delegate = self;
        //张少南 默认图
        NSLog(@"什么情况呢-=-=-=-=-=----   %@",theUrl);
        [_locationImageView loadImageFromURL:theUrl withPlaceholdImage:nil];
        
        [self addSubview:_locationImageView];
        
                
        if (theUrl.length > 0) {
            placeHolderButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            placeHolderButton.userInteractionEnabled = NO;
            
            placeHolderButton.backgroundColor = RGBCOLOR(229,229,229);
            
            placeHolderButton.frame =  [UIScreen mainScreen].bounds;
            
            placeHolderButton.center = CGPointMake(160,(iPhone5?568:480)/2);
            
            [placeHolderButton setImage:[UIImage imageNamed:@"bigImagesPlaceHolder.png"] forState:UIControlStateNormal];
            
            [self addSubview:placeHolderButton];
        }
        
    }
    
    return self;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
	return _locationImageView;
}

-(void)handleImageLayout:(AsyncImageView *)tag
{
    
}

-(void)seccesDownLoad:(UIImage *)image
{
    
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
			CGSize zoomRectSize = CGSizeMake(self.frame.size.width / self.maximumZoomScale, self.frame.size.height / self.maximumZoomScale );
			CGRect zoomRect = CGRectMake( touchCenter.x - zoomRectSize.width * .5, touchCenter.y - zoomRectSize.height * .5, zoomRectSize.width, zoomRectSize.height );
			
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
    
    if (_aDelegate && [_aDelegate respondsToSelector:@selector(singleClicked)]) {
        [_aDelegate singleClicked];
    }
    
	// tell the controller
    //	if([photoDelegate respondsToSelector:@selector(didTapPhotoView:)])
    //		[photoDelegate didTapPhotoView:self];
}



-(void)resetImageView:(UIImage *)theImage;
{
    self.locationImageView.image = theImage;
}


-(void)dealloc
{
    _locationImageView.delegate = nil;
    
    _locationImageView.image = nil;
    
    _locationImageView = nil;
    
}


#pragma mark-AsyncImageDelegte


-(void)succesDownLoadWithImageView:(UIImageView *)imageView Image:(UIImage *)image
{
    placeHolderButton.hidden = YES;
}



@end
















