//
//  FBFindCarDetailController.m
//  FBAuto
//
//  Created by lichaowei on 14-7-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBFindCarDetailController.h"

#import "LShareSheetView.h"
#import "FBFriendsController.h"

#import "GuserZyViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "FBChatViewController.h"

@interface FBFindCarDetailController ()
{
    NSString *userId;
}

@end

@implementation FBFindCarDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createViews];
    
    [self getSingleCarInfoWithId:self.infoId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _headImage = nil;
    _nameLabel = nil;
    _saleTypeBtn = nil;//商家类型
    _phoneNumLabel = nil;
    _addressLabel = nil;
    _bottomBgView = nil;
    
    for (int i = 1; i < 7; i ++) {
        UILabel *label = [self labelWithTag:110 + i];
        label = nil;
        
        UILabel *label2 = [self labelWithTag:100 + i];
        label2 = nil;
    }
}

#pragma - mark 网络请求 获取单个寻车信息

- (void)getSingleCarInfoWithId:(NSString *)carId
{
    NSString *url = [NSString stringWithFormat:FBAUTO_FINDCAR_SINGLE,carId];
    
    NSLog(@"单个车源信息 %@",url);
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"单个车源发布 result %@, erro%@",result,[result objectForKey:@"errinfo"]);
        
        NSArray *dataInfo = [result objectForKey:@"datainfo"];
        
        if (dataInfo.count == 0) {
            return ;
        }
        
        NSDictionary *dic = [dataInfo objectAtIndex:0];
        
        NSString *carName = [dic objectForKey:@"car_name"];
        
        UILabel *nameLabel = [self labelWithTag:110];
        nameLabel.numberOfLines = 0;
        nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
        CGFloat newHeight = [LCWTools heightForText:carName width:200 font:14];
        
        CGRect oldFrame = nameLabel.frame;
        
        CGFloat dis = newHeight - oldFrame.size.height;
        
        oldFrame.size.height = newHeight;
        nameLabel.frame = oldFrame;
        
//        //参数
        
        nameLabel.text = carName;
        
        NSString *area = [NSString stringWithFormat:@"%@",[dic objectForKey:@"province"]];
        
//        if ([area isEqualToString:@"不限不限"]) {
//            area = @"不限";
//        }
        
        
        [self labelWithTag:111].text  =[self showForText:area] ;
        [self labelWithTag:112].text  = [self showForText:[dic objectForKey:@"carfrom"]];
        [self labelWithTag:113].text  = [self showForText:[dic objectForKey:@"spot_future"]];
        [self labelWithTag:114].text  = [self showForText:[dic objectForKey:@"color_out"]];
        [self labelWithTag:115].text  = [self showForText:[dic objectForKey:@"color_in"]];
//        [self labelWithTag:114].text  = [self depositWithText:[dic objectForKey:@"deposit"]];
        
        
        NSString *description = [NSString stringWithFormat:@"%@  联系请说在e车看到的信息",[dic objectForKey:@"cardiscrib"]];
        
        [self labelWithTag:116].text  = description;
        
        [self labelWithTag:116].numberOfLines = 0;
        [self labelWithTag:116].lineBreakMode = NSLineBreakByCharWrapping;
        [self labelWithTag:116].height = [LCWTools heightForText:[self labelWithTag:116].text width:200 font:14];
//        [self labelWithTag:114].backgroundColor = [UIColor orangeColor];
        
        for (int i = 1; i < 7; i ++) {
            UILabel *label = [self labelWithTag:110 + i];
            label.top += dis;
            
            UILabel *label2 = [self labelWithTag:100 + i];
            label2.top += dis;
        }
        
        
        //商家信息
        
        self.nameLabel.text = [dic objectForKey:@"username"];
        self.saleTypeBtn.titleLabel.text = [dic objectForKey:@"usertype"];//商家类型
        self.phoneNumLabel.text = [dic objectForKey:@"phone"];
        
        self.addressLabel.text = area;
        
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"headimage"]] placeholderImage:[UIImage imageNamed:@"defaultFace"]];
        
        userId = [dic objectForKey:@"uid"];//用户id
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        
        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
    }];
}

- (NSString *)showForText:(NSString *)text
{
    if ([text isEqualToString:@""]) {
        
        text = @"不限";
    }
    return text;
}

- (NSString *)depositWithText:(NSString *)text
{
    if ([text isEqualToString:@"1"]) {
        text = @"定金已付";
    }else if ([text isEqualToString:@"2"])
    {
        text = @"定金未支付";
    }else if ([text isEqualToString:@"0"] || [text isEqualToString:@""])
    {
        text = @"定金不限";
    }
    return text;
}

#pragma - mark 创建详情视图

- (UILabel *)createLabelFrame:(CGRect)aFrame text:(NSString *)text alignMent:(NSTextAlignment)align textColor:(UIColor *)color
{
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:aFrame];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.text = text;
    priceLabel.textAlignment = align;
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.textColor = color;
    return priceLabel;
}

- (void)createViews
{
    NSArray *items = @[@"车       型:",@"地       区:",@"版       本:",@"库       存:",@"外  观 色:",@"内  饰 色:",@"详细描述:"];
    for (int i = 0; i < items.count; i ++) {
        UILabel *aLabel = [self createLabelFrame:CGRectMake(10, 25 + (20 + 15) * i, 92, 20) text:[items objectAtIndex:i] alignMent:NSTextAlignmentLeft textColor:[UIColor blackColor]];
        aLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.view addSubview:aLabel];
        aLabel.tag = 100 + i;
    }
    for (int i = 0; i < items.count; i ++) {
        UILabel *aLabel = [self createLabelFrame:CGRectMake(92, 25 + (20 + 15) * i, 200, 20) text:@"" alignMent:NSTextAlignmentLeft textColor:[UIColor grayColor]];
        [self.view addSubview:aLabel];
        aLabel.tag = 110 + i;
        NSLog(@"tag %d",aLabel.tag);

    }
}

- (UILabel *)labelWithTag:(int)aTag
{
    return (UILabel *)[self.view viewWithTag:aTag];
}

#pragma - mark 点击事件

- (IBAction)clickToDial:(id)sender {
    
    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",self.phoneNumLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
}
- (IBAction)clickToChat:(id)sender {
    
    if ([self.phoneNumLabel.text isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:USERID]]) {
        
        [LCWTools alertText:@"本人发布信息"];
        return;
    }
    [FBChatTool chatWithUserId:userId userName:self.nameLabel.text target:self];
}

- (IBAction)clickToPersonal:(id)sender {
    
    GuserZyViewController *personal = [[GuserZyViewController alloc]init];
    personal.title = self.nameLabel.text;
    personal.userId = userId;
    [self.navigationController pushViewController:personal animated:YES];
}

//收藏
- (void)clickToCollect:(UIButton *)sender
{
    NSLog(@"收藏");
    
    // ‘1’ 车源收藏 ‘2’ 寻车收藏
    NSString *url = [NSString stringWithFormat:FBAUTO_COLLECTION,[GMAPI getAuthkey],self.carId,2,self.infoId];
    
    NSLog(@"添加收藏 %@",url);
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"添加收藏 result %@, erro%@",result,[result objectForKey:@"errinfo"]);
        
        [LCWTools showDXAlertViewWithText:[result objectForKey:@"errinfo"]];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        
        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
        
    }];
}


//分享
- (void)clickToShare:(UIButton *)sender
{
    NSLog(@"分享");
    LShareSheetView *shareView = [[LShareSheetView alloc]initWithFrame:self.view.frame];
    [shareView actionBlock:^(NSInteger buttonIndex, NSString *shareStyle) {
        
//        NSArray *text =  @[@"微信",@"QQ",@"朋友圈",@"微博",@"站内好友"];
        
        ////@"发河北 寻美规 奥迪Q7 14款 豪华"
        NSString *contentText = [NSString stringWithFormat:@"我在e族汽车上发布了一条求购信息，有车源的朋友来看看，（%@）",[self labelWithTag:110].text];
        
        NSString *shareUrl = [NSString stringWithFormat:FBAUTO_SHARE_CAR_FIND,self.infoId];
        
        NSString *contentWithUrl = [NSString stringWithFormat:@"%@%@",contentText,shareUrl];
        
        UIImage *aImage = [UIImage imageNamed:@"icon114.png"];
        
        NSString *title = [self labelWithTag:110].text;
        
        buttonIndex -= 100;
        NSLog(@"share %d %@",buttonIndex,shareStyle);
        switch (buttonIndex) {
            case 0:
            {
                NSLog(@"微信");
                [LCWTools shareText:contentText title:title image:aImage linkUrl:shareUrl ShareType:ShareTypeWeixiSession];
            }
                break;
            case 1:
            {
                NSLog(@"QQ");
                [LCWTools shareText:contentText title:title image:aImage linkUrl:shareUrl ShareType:ShareTypeQQ];
            }
                break;
            case 2:
            {
                NSLog(@"朋友圈");
                [LCWTools shareText:contentText title:title image:aImage linkUrl:shareUrl ShareType:ShareTypeWeixiTimeline];
            }
                break;
            case 3:
            {
                NSLog(@"微博");
                
                [LCWTools shareText:contentWithUrl title:title image:aImage linkUrl:shareUrl ShareType:ShareTypeSinaWeibo];
            }
                break;
            case 4:
            {
                NSLog(@"站内好友");
                
                FBFriendsController *friend = [[FBFriendsController alloc]init];
                friend.isShare = YES;
                //分享的内容  {@"text",@"infoId"}
                
                NSString *infoId = [NSString stringWithFormat:@"%@,%@",self.infoId,self.carId];
                friend.shareContent = @{@"text": contentText,@"infoId":infoId,SHARE_TYPE_KEY:SHARE_FINDCAR};
                [self.navigationController pushViewController:friend animated:YES];
                
            }
                break;
                
            default:
                break;
        }
    }];
}


#pragma mark - 发送短信

//短信

-(void)showSMSPicker:(NSString *)phoneNumber smsBody:(NSString *)smsBody{
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            
            [self displaySMSComposerSheet:phoneNumber smsBody:smsBody];
        }
        else {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""message:@"设备不支持短信功能" delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        
    }
}

-(void)displaySMSComposerSheet:(NSString *)phoneNumber smsBody:(NSString *)smsBody

{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate =self;
    
    //收件人
    NSArray *receiveArr = [NSArray arrayWithObjects:phoneNumber, nil];
    [picker setRecipients:receiveArr];
    //短信内容
    picker.body=smsBody;
    
    [self presentViewController:picker animated:YES completion:Nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    
    {
            
        case MessageComposeResultCancelled:
            
            NSLog(@"Result: 取消短信发送");
            break;
            
        case MessageComposeResultSent:
            NSLog(@"Result: 短信发送成功");
            break;
            
        case MessageComposeResultFailed:
            NSLog(@"Result: 短信发送失败");
            break;
        default:
            break;
            
    }
    //退出发短信界面
    [self dismissViewControllerAnimated:YES completion:Nil];
}


@end
