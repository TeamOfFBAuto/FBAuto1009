//
//  GperInfoViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//


#import "GperInfoViewController.h"
#import "GperInfoTableViewCell.h"
#import "GmLoadData.h"//网络请求类
#import "FBActionSheet.h"//自定义ActionSheet

#import "GlocalUserImage.h"//缓存沙盒类


#import "FBCityData.h"//地区转换





@interface GperInfoViewController ()
{
    MBProgressHUD *_hud;
}
@end

@implementation GperInfoViewController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}






- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%s",__FUNCTION__);
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel.text = @"个人资料";
    
    
    NSLog(@"%s",__FUNCTION__);
    
    //主tableview
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 315) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.scrollEnabled = NO;
    _tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableview];
    
    
    
    //接收通知
    [[NSNotificationCenter defaultCenter]
     
     addObserver:self selector:@selector(prepareNetData) name:FBAUTO_CHANGEPERSONALINFO object:nil];
    
    
    _hud = [GMAPI showMBProgressWithText:@"正在加载" addToView:self.view];
    _hud.delegate = self;
    
    //请求网络数据
    [self prepareNetData];
    
    
    
    
    
}


-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud.delegate = nil;
    hud = nil;
//    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 , 320, iPhone5?568:480) style:UITableViewStylePlain];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    _tableView.scrollEnabled = NO;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    [self.view addSubview:_tableView];
    [_tableview reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)prepareNetData{
    GmLoadData *aaa = [[GmLoadData alloc]init];
    //请求地址str
    NSString *str = [NSString stringWithFormat:FBAUTO_GET_USER_INFORMATION,[GMAPI getUid]];
    
    NSLog(@"请求用户信息接口 %@",str);
    __weak typeof (self)bself = self;
    __weak typeof (_hud)bhud = _hud;
    
    [aaa SeturlStr:str block:^(NSDictionary *dataInfo, NSString *errorinfo, NSInteger errcode) {
        
        NSLog(@"%@",dataInfo);
        //用户名
        self.userName = [NSString stringWithFormat:@"%@",[dataInfo objectForKey:@"name"]];
        
        //电话
        self.phoneNum = [NSString stringWithFormat:@"%@",[dataInfo objectForKey:@"phone"]];
        
        //地区
        NSString *province = [NSString stringWithFormat:@"%@",[dataInfo objectForKey:@"province"]];
        NSString *city = [NSString stringWithFormat:@"%@",[dataInfo objectForKey:@"city"]];
        
        NSInteger sheng;
        NSInteger shi;
        NSString *p = nil;//省
        NSString *s = nil;//市
        if (province.length>0) {
            sheng = [province integerValue];
            p = [FBCityData cityNameForId:sheng];
        }
        if (city.length>0) {
            shi = [city integerValue];
            s = [FBCityData cityNameForId:shi];
        }
        
        if (p != nil && s != nil) {
            self.area = [NSString stringWithFormat:@"%@%@",p,s];
        }
        if (p == nil) {
            self.area = [NSString stringWithFormat:@"%@",s];
        }
        if (s == nil) {
            self.area = [NSString stringWithFormat:@"%@",p];
        }
        
        
        //地址
        self.address = [NSString stringWithFormat:@"%@",[dataInfo objectForKey:@"address"]];
        
        NSLog(@"%@",self.address);
        
        //简介
        self.jianjie = [NSString stringWithFormat:@"%@",[dataInfo objectForKey:@"intro"]];
        NSLog(@"%@",self.jianjie);
        
        //头像
        self.headimage = [NSString stringWithFormat:@"%@",[dataInfo objectForKey:@"headimage"]];
        
        [bself hudWasHidden:bhud];
        
    }];
}






#pragma mark - UITableViewDataSource && UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GperInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GperInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    [cell loadViewWithIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        __weak typeof (self)bself = self;
        [cell setUserFaceBlock:^{
            [bself guserFace];
        }];
    }
    
    
    return cell;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    if (section == 0) {
        num = 1;
    }else if (section == 1){
        num = 5;
    }
    return num;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0;
    
    if (_tmpCell) {
        height = [_tmpCell loadViewWithIndexPath:indexPath];
    }else{
        _tmpCell = [[GperInfoTableViewCell alloc]init];
        _tmpCell.delegate = self;
        height = [_tmpCell loadViewWithIndexPath:indexPath];
    }
    
    return height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
}





#pragma mark - 自定义cell block方法调用的本类方法
-(void)guserFace{
    NSLog(@"%s",__FUNCTION__);
    FBActionSheet *sheet = [[FBActionSheet alloc]initWithFrame:self.view.frame];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    
    
    [sheet actionBlock:^(NSInteger buttonIndex) {
        NSLog(@"%ld",(long)buttonIndex);
        if (buttonIndex == 0) {
            NSLog(@"%s",__FUNCTION__);
            NSLog(@"拍照");
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }else{
                NSLog(@"无法打开相机");
            }
            [self presentViewController:picker animated:YES completion:^{
                
            }];
            
        }else if (buttonIndex == 1){
            NSLog(@"%s",__FUNCTION__);
            NSLog(@"相册");
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
            
        }
        
    }];
    
}

#pragma mark - UIImagePickerControllerDelegate 拍照选择照片协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%s",__FUNCTION__);
    [UIApplication sharedApplication].statusBarHidden = NO;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        //压缩图片 不展示原图
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //按比例缩放
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.5];
        
        
        //将图片传递给截取界面进行截取并设置回调方法（协议）
        MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
        imageCrop.delegate = self;
        
        //按像素缩放
        imageCrop.ratioOfWidthAndHeight = 400.0f/400.0f;//设置缩放比例
        
        imageCrop.image = scaleImage;
        //[imageCrop showWithAnimation:NO];
        picker.navigationBar.hidden = YES;
        [picker pushViewController:imageCrop animated:YES];
        
        
        
        
        
    }
    
    
}


#pragma mark- 缩放图片
//按比例缩放
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//按像素缩放
-(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
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


#pragma mark - 图片回传协议方法   crop delegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    
    
    //按像素缩放
    //UIImage *doneImage = [self scaleToSize:cropImage size:CGSizeMake(400, 400)];
    
    //用户需要上传的剪裁后的头像image
    self.userUpFaceImage = cropImage;
    NSLog(@"在此设置用户上传的头像");
    self.userUpFaceImagedata = UIImagePNGRepresentation(self.userUpFaceImage);
    
    
    //缓存到本地
    [GlocalUserImage setUserFaceImageWithData:self.userUpFaceImagedata];
    NSString *str = @"yes";
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpFace"];
    
    
    //ASI上传
    [self test];
    
    [_tableview reloadData];
    
}


#pragma mark - 上传头像
#define TT_CACHE_EXPIRATION_AGE_NEVER     (1.0 / 0.0)
-(void)test{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString* fullURL = [NSString stringWithFormat:FBAUTO_MODIFY_HEADER_IMAGE,[GMAPI getAuthkey]];
        
        NSLog(@"上传图片请求的地址===%@",fullURL);
        
        request__ = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:fullURL]];
        AppDelegate *_appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        request__.delegate = _appDelegate;
        request__.tag = 123;
        
        //得到图片的data
        NSData* data;
        //获取图片质量
        NSMutableData *myRequestData=[NSMutableData data];
        [request__ setPostFormat:ASIMultipartFormDataPostFormat];
        data = UIImageJPEGRepresentation(self.userUpFaceImage,0.5);
        NSLog(@"xxxx===%@",data);
        [request__ addRequestHeader:@"uphead" value:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]]];
        //设置http body
        [request__ addData:data withFileName:[NSString stringWithFormat:@"boris.png"] andContentType:@"image/PNG" forKey:[NSString stringWithFormat:@"headimg"]];
        
        [request__ setRequestMethod:@"POST"];
        request__.cachePolicy = TT_CACHE_EXPIRATION_AGE_NEVER;
        request__.cacheStoragePolicy = ASICacheForSessionDurationCacheStoragePolicy;
        [request__ startAsynchronous];
        
    });
    
    
}


@end
