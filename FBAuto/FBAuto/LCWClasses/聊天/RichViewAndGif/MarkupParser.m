//
//  MarkupParser.m
//  CoreTextDemo
//
//  Created by caixuejun on 11-12-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MarkupParser.h"
//#import "RegexKitLite.h"

//#define kHTML @"These are <font color=\"red\">red<font color=\"black\"> and\
<font color=\"blue\">blue <font color=\"black\">words."

@implementation MarkupParser
@synthesize font, color, strokeColor, strokeWidth;
@synthesize images;

-(id)init
{
    self = [super init];
    
    if (self)
    {
        self.font = @"ArialMT";
        self.color = [UIColor blackColor];
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
        self.images = [NSMutableArray array];
    }
    
    return self;
}

/* Callbacks */
static void deallocCallback( void* ref ){
    [(id)ref release];
}
static CGFloat ascentCallback( void *ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"height"] floatValue];
}
static CGFloat descentCallback( void *ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"descent"] floatValue];
}
static CGFloat widthCallback( void* ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"width"] floatValue];
}

- (NSString *)escapedString:(NSString *)oldString
{
    NSString *escapedString_lt = [oldString stringByReplacingOccurrencesOfString:@"&lt" withString:@"<"];
    NSString *escapedString = [escapedString_lt stringByReplacingOccurrencesOfString:@"&gt" withString:@">"];
    return escapedString;
}

- (NSMutableAttributedString *)attrStringFromMarkup:(NSString*)markup
{
    NSMutableAttributedString *string = [[[NSMutableAttributedString alloc] init] autorelease];
    NSRegularExpression* regex = [[NSRegularExpression alloc]
                                  initWithPattern:@"(.*?)(<[^>]*+>|\\Z)"
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil];
    
    NSArray* chunks = [regex matchesInString:markup options:0
                                       range:NSMakeRange(0, [markup length])];
    [regex release];
    
    for (NSTextCheckingResult* b in chunks)
    {
        NSArray* parts = [[markup substringWithRange:b.range]
                          componentsSeparatedByString:@"<"]; //1
        
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font,
                                                 24.0f, NULL);
        
        //apply the current text style //2
        NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               (id)self.color.CGColor, kCTForegroundColorAttributeName,
                               (id)fontRef, kCTFontAttributeName,
                               (id)self.strokeColor.CGColor, (NSString *) kCTStrokeColorAttributeName,
                               (id)[NSNumber numberWithFloat: self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,nil];
        
        
        //转义 &lt 和 &gt
        NSString *part0 = [self escapedString:[parts objectAtIndex:0]];
        NSAttributedString *partString = [[NSAttributedString alloc] initWithString:part0 attributes:attrs];
        [string appendAttributedString:partString];
        [partString release];
        
        CFRelease(fontRef);
        
        if ([parts count]>1)
        {
            NSString* tag = (NSString*)[parts objectAtIndex:1];
            if ([tag hasPrefix:@"font"]) {
                //stroke color
                NSRegularExpression* scolorRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=strokeColor=[\'\"])\\w+" options:0 error:NULL] autorelease];
                [scolorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    if ([[tag substringWithRange:match.range] isEqualToString:@"none"]) {
                        self.strokeWidth = 0.0;
                    } else {
                        self.strokeWidth = -2.0;
                        SEL colorSel = NSSelectorFromString([NSString stringWithFormat: @"%@Color", [tag substringWithRange:match.range]]);
                        self.strokeColor = [UIColor performSelector:colorSel];
                    }
                }];
                
                //color
                NSRegularExpression* colorRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=color=[\'\"])\\w+" options:0 error:NULL] autorelease];
                [colorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    SEL colorSel = NSSelectorFromString([NSString stringWithFormat: @"%@Color", [tag substringWithRange:match.range]]);
                    self.color = [UIColor performSelector:colorSel];
                }];
                
                //face
                NSRegularExpression* faceRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=face=[\'\"])[^[\'\"]]+" options:0 error:NULL] autorelease];
                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    self.font = [tag substringWithRange:match.range];
                }];
            } //end of font parsing
            
            if ([tag hasPrefix:@"img"]) {
                
                __block NSNumber* width = [NSNumber numberWithInt:0];
                __block NSNumber* height = [NSNumber numberWithInt:0];
                __block NSString* fileName = @"";
                
                //width
                NSRegularExpression* widthRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=width=[\'\"])[^[\'\"]]+" options:0 error:NULL] autorelease];
                [widthRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    width = [NSNumber numberWithInt: [[tag substringWithRange: match.range] intValue] ];
                }];
                
                //height
                NSRegularExpression* faceRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=height=[\'\"])[^[\'\"]]+" options:0 error:NULL] autorelease];
                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    height = [NSNumber numberWithInt: [[tag substringWithRange:match.range] intValue]];
                }];
                
                //image
                NSRegularExpression* srcRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=src=[\'\"])[^[\'\"]]+" options:0 error:NULL] autorelease];
                [srcRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    fileName = [tag substringWithRange: match.range];
                }];
                
                //add the image for drawing
                [self.images addObject:
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  width, @"width",
                  height, @"height",
                  fileName, @"fileName",
                  [NSNumber numberWithInt:(int)[string length]], @"location",
                  nil]];
                
                //render empty space for drawing the image in the text //1给callbacks指定回调函数
                CTRunDelegateCallbacks callbacks;
                callbacks.version = kCTRunDelegateVersion1;
                callbacks.getAscent = ascentCallback;
                callbacks.getDescent = descentCallback;
                callbacks.getWidth = widthCallback;
                callbacks.dealloc = deallocCallback;
                
                NSDictionary* imgAttr = [[NSDictionary dictionaryWithObjectsAndKeys: //2
                                          width, @"width",
                                          height, @"height",
                                          nil] retain];//创建字典储存单个空格的长和宽
                
                CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, imgAttr); //3创建CTRun的代理
                NSDictionary *attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        //set the delegate
                                                        (id)delegate, (NSString*)kCTRunDelegateAttributeName,
                                                        nil];//通过回调，获取空格的长和宽属性
                
                //add a space to the text so that it can call the delegate
                // 空格的属性（长和宽为将要绘制图片的长和宽,原先的" "改成"-"
                // 因为空格换行时会出现问题，造成连续打印表情显示成一行
                // 后续处理时我们需要将这块区域先clear掉，不然就会有字符
                // 目前没想到更好的方法，算是曲线救国的方式
                NSAttributedString *replaceString = [[NSAttributedString alloc] initWithString:@"－" attributes:attrDictionaryDelegate];
                [string appendAttributedString:replaceString];
                [replaceString release];
                CFRelease(delegate);
            }//end of img parsing
        }
    }
    NSAttributedString *blankString = [[NSAttributedString alloc] initWithString:@" " attributes:nil];
    [string appendAttributedString:blankString];
    [blankString release];
    return string;
}


-(void)dealloc
{
    //[font release];
    self.font = nil;
    //[color release];
    self.color = nil;
    //[strokeColor release];
    self.strokeColor = nil;
    //[images release];
    self.images = nil;
    
    [super dealloc];
}

@end
