//
//  FBHelper.m
//  CoreTextDemo_0723
//
//  Created by lichaowei on 14-7-4.
//  Copyright (c) 2014年 北京微云即趣. All rights reserved.
//

#import "FBHelper.h"

@implementation FBHelper
#pragma mark - 正则匹配电话号码，网址链接，Email地址
+ (NSMutableArray *)addHttpArr:(NSString *)text
{
    //匹配网址链接
    NSString *regex_http = @"(https?|ftp|file)+://[^\\s]*";
    NSArray *array_http = [text componentsMatchedByRegex:regex_http];
    NSMutableArray *httpArr = [NSMutableArray arrayWithArray:array_http];
    return httpArr;
}

+ (NSMutableArray *)addPhoneNumArr:(NSString *)text
{
    //匹配电话号码
    NSString *regex_phonenum = @"\\d{3}-\\d{7}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{8}|1+[358]+\\d{9}|\\d{8}|\\d{7}";
    NSArray *array_phonenum = [text componentsMatchedByRegex:regex_phonenum];
    NSMutableArray *phoneNumArr = [NSMutableArray arrayWithArray:array_phonenum];
    return phoneNumArr;
}

+ (NSMutableArray *)addEmailArr:(NSString *)text
{
    //匹配Email地址
    NSString *regex_email = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*.\\w+([-.]\\w+)*";
    NSArray *array_email = [text componentsMatchedByRegex:regex_email];
    NSMutableArray *emailArr = [NSMutableArray arrayWithArray:array_email];
    return emailArr;
}

+ (NSString *)transformString:(NSString *)originalStr
{
    //匹配表情，将表情转化为html格式
    NSString *text = originalStr;
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    if ([array_emoji count]) {
        for (NSString *str in array_emoji) {
            NSRange range = [text rangeOfString:str];
            NSString *i_transCharacter = [[self emojiDic] objectForKey:str];
            if (i_transCharacter) {
                NSString *imageHtml = [NSString stringWithFormat:@"<img src='%@' width='16' height='16'>",i_transCharacter];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:imageHtml];
            }
        }
    }
    //返回转义后的字符串
    return text;
}

+ (NSDictionary *)emojiDic
{
    NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotionImage.plist"];
    NSDictionary *emojiDic = [[NSDictionary alloc] initWithContentsOfFile:emojiFilePath];
    return emojiDic;
}

/**
 *  创建lable
 */

//+ (void)creatAttributedText:(NSString *)o_text Label:(OHAttributedLabel *)label OHDelegate:(id<OHAttributedLabelDelegate>)delegate
//{
//    [label setNeedsDisplay];
//    
//    label.automaticallyAddLinksForType = 0;//不让系统自动检测网址链接
//    
//    NSMutableArray *httpArr = [FBHelper addHttpArr:o_text];
//    NSMutableArray *phoneNumArr = [FBHelper addPhoneNumArr:o_text];
//    
//    NSString *text = [FBHelper transformString:o_text];
//    text = [NSString stringWithFormat:@"<font color='black' face='Palatino-Roman'>%@",text];
//    
//    MarkupParser* p = [[MarkupParser alloc] init];
//    NSMutableAttributedString* attString = [p attrStringFromMarkup: text];
//    [attString setFont:[UIFont systemFontOfSize:14]];
//    [attString setTextAlignment:kCTTextAlignmentJustified lineBreakMode:kCTLineBreakByCharWrapping];
//    
//    [label setAttString:attString withImages:p.images];
//    
//    NSString *string = attString.string;
//    
//    //    if ([phoneNumArr count]) {
//    //        for (NSString *phoneNum in phoneNumArr) {
//    //            [label addCustomLink:[NSURL URLWithString:phoneNum] inRange:[string rangeOfString:phoneNum]];
//    //        }
//    //    }
//    
//    if ([httpArr count]) {
//        for (NSString *httpStr in httpArr) {
//            [label addCustomLink:[NSURL URLWithString:httpStr] inRange:[string rangeOfString:httpStr]];
//        }
//    }
//    label.delegate = delegate;
//    CGRect labelRect = label.frame;
//    labelRect.size.width = [label sizeThatFits:CGSizeMake(225, CGFLOAT_MAX)].width;
//    labelRect.size.height = [label sizeThatFits:CGSizeMake(225, CGFLOAT_MAX)].height;
//    label.frame = labelRect;
//    label.onlyCatchTouchesOnLinks = NO;
//    label.underlineLinks = YES;//链接是否带下划线
//    [label.layer display];
//    // 调用这个方法立即触发label的|drawTextInRect:|方法，
//    // |setNeedsDisplay|方法有滞后，因为这个需要画面稳定后才调用|drawTextInRect:|方法
//    // 这里我们创建的时候就需要调用|drawTextInRect:|方法，所以用|display|方法，这个我找了很久才发现的
//    
//    [FBHelper drawImage:label];
//}
//
///**
// *  画图
// */
//+ (void)drawImage:(OHAttributedLabel *)label
//{
//    for (NSArray *info in label.imageInfoArr) {
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:[info objectAtIndex:0] ofType:nil];
//        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
//        SCGIFImageView *imageView = [[SCGIFImageView alloc] initWithGIFData:data];
//        imageView.frame = CGRectFromString([info objectAtIndex:2]);
//        imageView.top += 2;
//        
//        [label addSubview:imageView];//label内添加图片层
//        [label bringSubviewToFront:imageView];
//    }
//}


@end
