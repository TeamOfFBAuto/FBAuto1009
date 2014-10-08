//
//  AsyncImageView.m
//  AirMedia
//
//  Created by Xingzhi Cheng on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"
#import "FullyLoaded.h"
#import <QuartzCore/QuartzCore.h>

@interface AsyncImageView ()
- (void) downloadImage:(NSString *)imageURL WithType:(int)type;
@end

@implementation AsyncImageView
@synthesize request = _request, delegate;

- (void) dealloc {
	self.request.delegate = nil;
    [self cancelDownload];
    [super dealloc];
}

- (void) loadImageFromURL:(NSString*)imageURL
{
    [self loadImageFromURL1:imageURL withPlaceholdImage:nil];
}


- (void) loadImageFromURL:(NSString*)imageURL withPlaceholdImage:(UIImage *)placeholdImage WithAnimation:(BOOL)animation
{
    // 判断imageURL是否为空或为nil
    
    if(!imageURL || [imageURL isEqualToString:@""])
    {
        self.image = placeholdImage;
        return;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            // NSLog(@"load image...");
            if (image)
            {
                self.image = [image copy];
                
                if (animation)
                {
                    [self fadeAnimation:image];
                }
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(succesDownLoadWithImageView:Image:)])
                {
                    [self.delegate succesDownLoadWithImageView:self Image:image];
                }
            }else
            {
                self.image = placeholdImage;
                [self downloadImage:imageURL WithType:0];
            }
        });
    });
    
}



- (void) loadImageFromURL:(NSString*)imageURL withPlaceholdImage:(UIImage *)placeholdImage
{
    // add by stan
    // 判断imageURL是否为空或为nil
    
    
    if(!imageURL || [imageURL isEqualToString:@""])
    {
        self.image = placeholdImage;
        return;
    }
    
    /*
     UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
     if (image)
     self.image = image;
     else
     [self downloadImage:imageURL];
     */
    
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            // NSLog(@"load image...");
            if (image)
            {
                // 如果该图已经加载过，则不再加载
                // #############error!
                /*
                 2012-06-12 16:10:49.716 iClub[34701:11903] -[__NSCFNumber _isResizable]: unrecognized selector sent to instance 0x7674b10
                 2012-06-12 16:10:49.740 iClub[34701:11903] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[__NSCFNumber _isResizable]: unrecognized selector sent to instance 0x7674b10'
                 *** First throw call stack:
                 (0x230f022 0x26ebcd6 0x2310cbd 0x2275ed0 0x2275cb2 0x156f2c3 0x791cd 0x21cd8d9 0x21ce509 0x2246803 0x2245d84 0x2245c9b 0x293b7d8 0x293b88a 0x1484626 0x1284d 0x2245 0x1)
                 terminate called throwing an exception */
                //                NSLog(@"cached image");
                //                [self.delegate handleImageLayout:self];
                
                //                if (![image isEqual:self.image])
                
                
                    //                    self.image = [image copy];
                    
//                [self fadeAnimation:image];
                
                self.image = image;
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(succesDownLoadWithImageView:Image:)])
                {
                    [self.delegate succesDownLoadWithImageView:self Image:image];
                }
            }else
            {
                self.image = placeholdImage;
                [self downloadImage:imageURL WithType:0];
                
            }
        });
    });
    
}

- (void) cancelDownload {
    [self.request cancel];
    self.request = nil;
}


-(void)fadeAnimation:(UIImage *)theImage
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3 ;  // 动画持续时间(秒)
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;//淡入淡出效果
    
    self.image = theImage;
    
    [self.layer addAnimation:animation forKey:@"animation"];
}


#pragma mark -
#pragma mark private downloads


- (void) loadImageFromURL1:(NSString*)imageURL withPlaceholdImage:(UIImage *)placeholdImage
{
    if (!self.image)
    {
        self.image = placeholdImage;
    }
    
    if(!imageURL || [imageURL isEqualToString:@""])
    {
        self.image = placeholdImage;
        return;
    }
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
        
        //        CGSize newSize=CGSizeMake(38, 38);
        //        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        //        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        //        self.image = UIGraphicsGetImageFromCurrentImageContext();
        //        UIGraphicsEndImageContext();
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (image)
            {
                self.image = image;
                
                CGPoint point = self.center;
                
                float theWidth = (self.image.size.width/self.image.size.height)*160;
                
                self.frame = CGRectMake(0,0,theWidth>300?300:theWidth,160);
                
                self.center = point;
                
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(succesDownLoadWithImageView:Image:)])
                {
                    
                    [self.delegate succesDownLoadWithImageView:self Image:image];
                }
                
                
            }else
            {
                [self downloadImage:imageURL WithType:1];
                
            }
        });
    });
    
}


- (void) downloadImage:(NSString *)imageURL WithType:(int)type
{
    [self cancelDownload];
    
    if (type == 1)
    {
        self.backgroundColor = [UIColor clearColor];
        //        myProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        //        myProgress.frame = CGRectMake(100,300,120,30);
        //        [self addSubview:myProgress];
        
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.frame = CGRectMake(135,100,50, 50);
        activity.hidesWhenStopped = YES;
        //        [self addSubview:activity];
        [activity startAnimating];
        
        
        NSString * newImageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:newImageURL]];
        [self.request setDownloadDestinationPath:[[FullyLoaded sharedFullyLoaded] pathForImageURL:imageURL]];
        [self.request setDelegate:self];
        [self.request setCompletionBlock:^(void)
         {
             self.request.delegate = nil;
             
             NSLog(@"async image download done");
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"cache" object:nil];
             
             NSString * imageURL = [[self.request.originalURL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             
             self.request = nil;
             
             dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
             dispatch_async(queue, ^{
                 UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     if (image)
                     {
                         self.image = image;
                         
                         CGPoint point = self.center;
                         
                         self.frame = CGRectMake(0,0,(self.image.size.width/self.image.size.height)*160,160);
                         
                         self.center = point;
                         
                         if (self.delegate && [self.delegate respondsToSelector:@selector(succesDownLoadWithImageView:Image:)])
                         {
                             [self.delegate succesDownLoadWithImageView:self Image:nil];
                         }

                     }
                     
                 });
             });}];
        [self.request setFailedBlock:^(void){
            [self.request cancel];
            self.request.delegate = nil;
            self.request = nil;
            NSLog(@"async image download failed");
            
            
        }];
        
    }else
    {
        NSString * newImageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:newImageURL]];
        [self.request setDownloadDestinationPath:[[FullyLoaded sharedFullyLoaded] pathForImageURL:imageURL]];
        [self.request setDelegate:self];
        [self.request setCompletionBlock:^(void){
            self.request.delegate = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cache" object:nil];
            NSString * imageURL = [[self.request.originalURL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            self.request = nil;
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (image)
                    {
                        
                        NSLog(@"async image download done");
                        
                        self.image = image;
                        
//                        [self fadeAnimation:image];
                        
                    }
                    if (self.delegate && [self.delegate respondsToSelector:@selector(seccesDownLoad:)])
                    {
                        [self.delegate seccesDownLoad:image];
                    }
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(succesDownLoadWithImageView:Image:)])
                    {
                        
                        [self.delegate succesDownLoadWithImageView:self Image:image];
                    }
                    
                });
            });}];
        
        [self.request setFailedBlock:^(void)
         {
             [self.delegate seccesDownLoad:nil];
             [self.request cancel];
             self.request.delegate = nil;
             self.request = nil;
             NSLog(@"async image download failed");
         }];
    }
    
    
	
    [self.request startAsynchronous];
    //	NSLog(@"download Image %@", imageURL);
}



-(void)requestFinished:(ASIHTTPRequest *)request
{
    [myProgress removeFromSuperview];
    [activity removeFromSuperview];
}

/*
 - (void) requestFinished:(ASIHTTPRequest *)request
 {
 self.request.delegate = nil;
 self.request = nil;
 
 NSLog(@"async image download done");
 
 NSString * imageURL = [[request.originalURL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
 dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
 dispatch_async(queue, ^{
 UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
 dispatch_sync(dispatch_get_main_queue(), ^{
 self.image = image;
 });
 });
 
 
 //    NSString * imageURL = [[request.originalURL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 //    UIImage * image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
 //    [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
 
 }
 
 
 - (void) requestFailed:(ASIHTTPRequest *)request
 {
 [self.request cancel];
 self.request.delegate = nil;
 self.request = nil;
 
 NSLog(@"async image download failed");
 }
 */

@end
