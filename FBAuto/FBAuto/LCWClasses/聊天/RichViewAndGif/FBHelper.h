//
//  FBHelper.h
//  CoreTextDemo_0723
//
//  Created by lichaowei on 14-7-4.
//

#import <Foundation/Foundation.h>
#import "RegexKitLite.h"

@interface FBHelper : NSObject

+ (NSMutableArray *)addHttpArr:(NSString *)text;
+ (NSMutableArray *)addPhoneNumArr:(NSString *)text;
+ (NSMutableArray *)addEmailArr:(NSString *)text;
+ (NSString *)transformString:(NSString *)originalStr;//表情转换为html

@end
