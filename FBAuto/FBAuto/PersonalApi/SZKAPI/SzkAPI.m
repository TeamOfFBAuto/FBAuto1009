//
//  SzkAPI.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-7.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "SzkAPI.h"
#import <AddressBook/AddressBook.h>
#include <dirent.h>
#import <AddressBookUI/AddressBookUI.h>
#include "sys/stat.h"

@implementation SzkAPI

#define NORESAULT @"noresault"


#pragma mark--获取通讯录放到一个数组里面，包含名字和号码
+(NSMutableArray *)AccesstoAddressBookAndGetDetail{
    NSMutableArray *arr_info=[NSMutableArray array];
    
    ABAddressBookRef tmpAddressBook=nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        tmpAddressBook =ABAddressBookCreate();
    }
    if (tmpAddressBook==nil) {
        return [NSMutableArray array];
    }
    
    
    
    
    
    NSArray* tmpPeoples = (NSArray*)CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(tmpAddressBook));
    
    
    
    for(id tmpPerson in tmpPeoples)
        
    {
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        
        //获取的联系人单一属性:First name
        
        NSString* tmpFirstName = (NSString*)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonFirstNameProperty));
        
      tmpFirstName=  [self changestrkongge:tmpFirstName];
        
        if (tmpFirstName.length!=0) {
            [dic setObject:tmpFirstName forKey:@"tmpFirstName"];

        }else{
        
            [dic setObject:NORESAULT forKey:@"tmpFirstName"];

            
        
        }
        
        
        //获取的联系人单一属性:Last name
        
        NSString* tmpLastName = (NSString*)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonLastNameProperty));
        
        tmpLastName=  [self changestrkongge:tmpLastName];

        
        if (tmpLastName.length!=0) {
            [dic setObject:tmpLastName forKey:@"tmpLastName"];

        }else{
            continue;

            [dic setObject:NORESAULT forKey:@"tmpLastName"];

        }
        //获取的联系人单一属性:Generic phone number
        
        ABMultiValueRef tmpPhones = ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonPhoneProperty);
        
        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
            
        {
            NSString* tmpPhoneIndex = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(tmpPhones, j));
            tmpPhoneIndex=[self changestrkongge:tmpPhoneIndex];
            
            if (tmpPhoneIndex.length!=0) {
                [dic setObject:tmpPhoneIndex forKey:[NSString stringWithFormat:@"tmpPhoneIndex%ld",(long)j]];

            }else{
            
                [dic setObject:NORESAULT forKey:[NSString stringWithFormat:@"tmpPhoneIndex%ld",(long)j]];
            }
        }
        
        [arr_info addObject:dic];
        CFRelease(tmpPhones);
        
    }
    return  arr_info;
}
//解决名字空格的问题
+(NSString *)changestrkongge:(NSString*)_receivestr{
    NSString *str=[NSString string];
    while ([_receivestr rangeOfString:@" "].length||[_receivestr rangeOfString:@"-"].length||[_receivestr rangeOfString:@"+86"].length) {
        _receivestr=[_receivestr stringByReplacingOccurrencesOfString:@" " withString:@""];
        _receivestr=[_receivestr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        _receivestr=[_receivestr stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    }
    str=_receivestr;
    return str;
}
//获取文件大小
+(NSString *) fileSizeAtPath:(NSString*) filePath
{
    int sizez_b = (int)[self _folderSizeAtPath:[filePath cStringUsingEncoding:NSUTF8StringEncoding]]/10240;
    
    if (sizez_b < 1024)
    {
        return [NSString stringWithFormat:@"(%dK)",sizez_b];
    }else if (sizez_b < 1024*1024 && sizez_b >= 1024)
    {
        return [NSString stringWithFormat:@"(%.1fM)",sizez_b/1024.0];
    }else
    {
        return [NSString stringWithFormat:@"(%.2fG)",sizez_b/1048576.0];
    }
}


+ (long long) _folderSizeAtPath: (const char*)folderPath{
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) return 0;
    struct dirent* child;
    while ((child = readdir(dir))!=NULL) {
        if (child->d_type == DT_DIR && (
                                        (child->d_name[0] == '.' && child->d_name[1] == 0) || // 忽略目录 .
                                        (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0) // 忽略目录 ..
                                        )) continue;
        
        int folderPathLength = strlen(folderPath);
        char childPath[1024]; // 子文件的路径地址
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength-1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        stpcpy(childPath+folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR){ // directory
            folderSize += [self _folderSizeAtPath:childPath]; // 递归调用子目录
            // 把目录本身所占的空间也加上
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }else if (child->d_type == DT_REG || child->d_type == DT_LNK){ // file or link
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }
    }
    
    return folderSize;
}



//获取用户的devicetoken

+(NSString *)getDeviceToken{

    NSString *str_devicetoken=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:DEVICETOKEN]];
    return str_devicetoken;


}

+(UIImage *)scaleToSizeWithImage:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}



@end
