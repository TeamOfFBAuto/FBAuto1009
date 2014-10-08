//
//  AsyncImageView.h
//  AirMedia
//
//  Created by Xingzhi Cheng on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@class AsyncImageView;

@protocol AsyncImageDelegate <NSObject>

@required

-(void)handleImageLayout:(AsyncImageView*)tag;


@optional

-(void)seccesDownLoad:(UIImage *)image;
-(void)succesDownLoadWithImageView:(UIImageView *)imageView Image:(UIImage *)image;

@end


@interface AsyncImageView : UIImageView <ASIHTTPRequestDelegate>
{
    NSMutableData * data;
    
    UIProgressView * myProgress;
    UIActivityIndicatorView * activity;
    
}
@property(nonatomic, retain) ASIHTTPRequest * request;
@property (nonatomic, assign) id <AsyncImageDelegate> delegate;

- (void) loadImageFromURL:(NSString*)imageURL withPlaceholdImage:(UIImage *)placeholdImage WithAnimation:(BOOL)animation;
- (void) loadImageFromURL1:(NSString*)imageURL withPlaceholdImage:(UIImage *)placeholdImage;
- (void) loadImageFromURL:(NSString*)imageURL;
- (void) loadImageFromURL:(NSString*)imageURL withPlaceholdImage:(UIImage*)image;
- (void) cancelDownload;
@end
