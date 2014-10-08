//
//  CWInputView.m
//  CWProject
//
//  Created by Lichaowei on 14-4-4.
//  Copyright (c) 2014年 Chaowei LI. All rights reserved.
//

#import "CWInputView.h"
//#import "Emoji.h"
#import "NSString+Emoji.h"
#import "FBActionSheet.h"


// UICode转化为UTF8

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

//#define UNICODETOUTF16(x)  ((Uf << 16) | Ue) //将这个公式向前代替，最终得到

#define UNICODETOUTF16(x) (((((x - 0x10000) >>10) | 0xD800) << 16)  | (((x-0x10000)&3FF) | 0xDC00))


//同样使用UTF16转回为大于0x10000 的Unicode码；

#define MULITTHREEBYTEUTF16TOUNICODE(x,y) (((((x ^ 0xD800) << 2) | ((y ^ 0xDC00) >> 8)) << 8) | ((y ^ 0xDC00) & 0xFF)) + 0x10000


#define SELF_HEIGHT 50  //本身的高度
#define TEXT_HEIGHT 35 //输入框高度
#define TEXT_WIDTH 150 //输入框宽带

#define KLEFT 85 //左距离
#define KTOP 7 //上

#define FONT_SIZE 16 //输入框字体大小

#define UPDARE_HEIGHT 44 //使用系统navigationBar时,高度需要减去此

@implementation CWInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:20/255. green:20/255. blue:20/255. alpha:1];
        self.frame = CGRectMake(0, CGRectGetMinY(frame), 320, SELF_HEIGHT);
        self.layer.borderWidth = 1;
//        self.layer.borderColor = [UIColor colorWithRed:200/255.0 green:203/255.0 blue:206/255.0 alpha:1].CGColor;
        [self textView];
        [self sendBtn];
        [self toolBtn1];
        [self toolBtn2];
        initFrameY = frame.origin.y;//记录最开始的y
        //注册键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _originalFrame = frame;
}
//_originalFrame的set方法  因为会调用setFrame  所以就不在此做赋值；
- (void)setOriginalFrame:(CGRect)originalFrame
{
    self.frame = CGRectMake(0, CGRectGetMinY(originalFrame), 320, CGRectGetHeight(originalFrame));
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark get方法实例化输入框／btn

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(KLEFT, KTOP, TEXT_WIDTH, TEXT_HEIGHT)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.cornerRadius = 5.0;
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:FONT_SIZE];
        [self addSubview:_textView];
    }
    return _textView;
}

- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn setFrame:CGRectMake(251, 12, 60, 25)];
        [_sendBtn addTarget:self action:@selector(sendBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"fasong_botton116_48"] forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_sendBtn];
        
        _sendBtn.userInteractionEnabled = NO;//默认不可点击
    }
    return _sendBtn;
}

/**
 * 电话 按钮
 */
- (UIButton *)toolBtn1
{
    if (!_toolBtn1) {
        _toolBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toolBtn1 setFrame:CGRectMake(1, 1, 40, 48)];
        [_toolBtn1 addTarget:self action:@selector(tool1Press:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBtn1 setImage:[UIImage imageNamed:@"dianhua40_48"] forState:UIControlStateNormal];
        _toolBtn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_toolBtn1];
    }
    return _toolBtn1;
}

/**
 *  拍照 按钮
 */
- (UIButton *)toolBtn2
{
    if (!_toolBtn2) {
        _toolBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toolBtn2 setFrame:CGRectMake(_toolBtn1.right, 1, 40, 48)];
        [_toolBtn2 addTarget:self action:@selector(tool2Press:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBtn2 setImage:[UIImage imageNamed:@"zhaoxiangji66_48"] forState:UIControlStateNormal];
        _toolBtn2.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_toolBtn2];
    }
    return _toolBtn2;
}

#pragma - mark block 回调

- (void)setToolBlock:(ToolBlock)aBlock
{
    toolBlock = aBlock;
}
- (void)setFrameBlock:(FrameBlock)aFrameBlock
{
    frameBlock = aFrameBlock;
}

#pragma mark - 事件处理

/**
 *  清空时恢复inputView 和 textView frame
 */
- (void)resetFrame
{
    [self textViewDidChange:self.textView];
}

- (void)sendBtnPress:(UIButton*)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(inputView:sendBtn:inputText:)]) {
       [self.delegate inputView:self sendBtn:sender inputText:_textView.text];
    }
    if (self.clearInputWhenSend) {
        self.textView.text = @"";
        [self resetFrame];
    }
    if (self.resignFirstResponderWhenSend) {
        [self resignFirstResponder];
    }
}
//电话
- (void)tool1Press:(UIButton *)sender
{
    toolBlock(0);
    
    [self resignFirstResponder];
}

//照片

- (void)tool2Press:(UIButton *)sender
{
    FBActionSheet *sheet = [[FBActionSheet alloc]initWithFrame:self.superview.frame];
    [sheet actionBlock:^(NSInteger buttonIndex) {
        NSLog(@"%ld",(long)buttonIndex);
        if (buttonIndex == 0) {
            NSLog(@"拍照");
            
            toolBlock(1);
            
        }else if (buttonIndex == 1)
        {
            NSLog(@"相册");
            
            toolBlock(2);
        }
        
    }];
    
        [self resignFirstResponder];
}


/**
 *  切换表情与键盘
 */
- (void)swapEmjAndKeyBoard:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    
}

#pragma mark keyboardNotification

- (void)keyboardWillShow:(NSNotification*)notification{
    
    NSLog(@"keyboardWillShow");
    
    _sendBtn.userInteractionEnabled = YES;//打开发送按钮交互
    
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect aFrame = self.originalFrame;
        aFrame.origin.y = keyboardRect.origin.y - aFrame.size.height - UPDARE_HEIGHT - 20;
        self.frame = aFrame;
        current_FrameY = aFrame.origin.y;//记录当前y
        current_KeyBoard_Y = keyboardRect.origin.y;
    }];
    
    if (frameBlock) {
        frameBlock(self,self.frame,NO);
    }
}

- (void)keyboardWillHide:(NSNotification*)notification{
    
    _sendBtn.userInteractionEnabled = NO;//打开发送按钮交互
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGRect aFrame = self.frame;
                         aFrame.origin.y = initFrameY;
                         self.frame = aFrame;
                         current_FrameY = aFrame.origin.y;//记录当前y
                     } completion:nil];
    
    if (frameBlock) {
        frameBlock(self,self.frame,YES);
    }
}

#pragma  mark ConvertPoint


- (BOOL)resignFirstResponder
{
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}

#pragma - mark UITextView 代理委托

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    NSLog(@"text  %@",text);
    if ([self stringContainsEmoji:text]) {
        
//        NSString *newString = [[text stringByReplacingEmojiUnicodeWithCheatCodes]stringByAppendingFormat:@"哈哈哈"];
//        NSLog(@"newString %@",newString);
//        NSString *emoji = [newString stringByReplacingEmojiCheatCodesWithUnicode];
//        NSLog(@"emoji %@",emoji);
    }else
    {
//        NSLog(@"text 没有表情 %@",text);
    }
    
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound )
    {
        return YES;
    }
    
    [self sendBtnPress:nil];
    
//    [self resignFirstResponder];
    return NO;
}
/**
 *  计算输入框以及 inputView的高度
 */
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat newHeight = [[self textView] sizeThatFits:CGSizeMake(textView.frame.size.width,CGFLOAT_MAX)].height;
    
    CGRect text_Frame = self.textView.frame;
    text_Frame.size.height = newHeight;
    self.textView.frame = text_Frame;
    
    CGRect input_Frame = self.frame;
    input_Frame.size.height = SELF_HEIGHT - TEXT_HEIGHT + newHeight;
    input_Frame.origin.y = current_KeyBoard_Y - input_Frame.size.height - UPDARE_HEIGHT - 20;
    
    self.frame = input_Frame;
    
//    NSLog(@"resetFrame %f",input_Frame.origin.y);
    
    toolBlock(3);
    
    if (frameBlock) {
        frameBlock(self,input_Frame,NO);
    }
}

#pragma - mark 表情处理

/**
 *  判断是否是表情
 */
- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         }
         else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }

     }];
    
    return returnValue;
}

/**
 *  表情转化为对应一个串数字
 */
- (NSString *)Emoji:(NSString *)string {
    __block NSString *returnValue = nil;
    
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = [NSString stringWithFormat:@"%d",ls];
                 }
             }
         }
         else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = [NSString stringWithFormat:@"%d",ls];
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = [NSString stringWithFormat:@"%d",hs];
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = [NSString stringWithFormat:@"%d",hs];
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = [NSString stringWithFormat:@"%d",hs];
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = [NSString stringWithFormat:@"%d",hs];
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = [NSString stringWithFormat:@"%d",hs];
             }
         }
         
     }];
    
    return returnValue;
}

/**
 *  Unicode 转中文
 */
- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    //NSLog(@"Output = %@", returnStr);
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}


/**
 *  表情Unicode转化为UTF8、UTF16
 *
 *  @param text 表情
 */

- (BOOL)replacementText:(NSString *)text
{
    NSString *hexstr = @"";
    
    for (int i=0;i< [text length];i++)
    {
        hexstr = [hexstr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"0x%1X ",[text characterAtIndex:i]]];
    }
    NSLog(@"UTF16 [%@]",hexstr);
    
    hexstr = @"";
    
    int slen = (int)strlen([text UTF8String]);
    
    for (int i = 0; i < slen; i++)
    {
        //fffffff0 去除前面六个F & 0xFF
        hexstr = [hexstr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"0x%X ",[text UTF8String][i] & 0xFF ]];
    }
    NSLog(@"UTF8 [%@]",hexstr);
    
    hexstr = @"";
    
    if ([text length] >= 2) {
        
        for (int i = 0; i < [text length] / 2 && ([text length] % 2 == 0) ; i++)
        {
            // three bytes
            if (([text characterAtIndex:i*2] & 0xFF00) == 0 ) {
                hexstr = [hexstr stringByAppendingFormat:@"Ox%1X 0x%1X",[text characterAtIndex:i*2],[text characterAtIndex:i*2+1]];
            }
            else
            {// four bytes
                hexstr = [hexstr stringByAppendingFormat:@"U+%1X ",MULITTHREEBYTEUTF16TOUNICODE([text characterAtIndex:i*2],[text characterAtIndex:i*2+1])];
            }
            
        }
        NSLog(@"(unicode) [%@]",hexstr);
    }
    else
    {
        NSLog(@"(unicode) U+%1X",[text characterAtIndex:0]);
    }
    
    return YES;
}

// UTF16编码
- (NSString *)UTF16ForString:(NSString *)text
{
    NSString *hexstr = @"";
    
    for (int i=0;i< [text length];i++)
    {
        hexstr = [hexstr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"0x%1X",[text characterAtIndex:i]]];
    }
//    NSLog(@"UTF16 [%@]",hexstr);
    return hexstr;
}

// UTF8编码
- (NSString *)UTF8ForString:(NSString *)text
{
    NSString *hexstr = @"";
    int slen = (int)strlen([text UTF8String]);
    
    for (int i = 0; i < slen; i++)
    {
        //fffffff0 去除前面六个F & 0xFF
        hexstr = [hexstr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"0x%X ",[text UTF8String][i] & 0xFF]];
    }
//    NSLog(@"UTF8 [%@]",hexstr);
    return hexstr;
}

// Unicode
- (NSString *)UnicodeForString:(NSString *)text
{
    NSString *hexstr = @"";
    
    if ([text length] >= 2) {
        
        for (int i = 0; i < [text length] / 2 && ([text length] % 2 == 0) ; i++)
        {
            // three bytes
            if (([text characterAtIndex:i*2] & 0xFF00) == 0 ) {
                hexstr = [hexstr stringByAppendingFormat:@"Ox%1X 0x%1X",[text characterAtIndex:i*2],[text characterAtIndex:i*2+1]];
            }
            else
            {// four bytes
                hexstr = [hexstr stringByAppendingFormat:@"U+%1X",MULITTHREEBYTEUTF16TOUNICODE([text characterAtIndex:i*2],[text characterAtIndex:i*2+1])];
            }
            
        }
    }
//    NSLog(@"(unicode) [%@]",hexstr);
    return hexstr;
}

@end
