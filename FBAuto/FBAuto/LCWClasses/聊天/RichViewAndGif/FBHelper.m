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

@end
