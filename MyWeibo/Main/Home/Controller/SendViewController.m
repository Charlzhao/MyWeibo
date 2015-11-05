//
//  SendViewController.m
//  MyWeibo
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "SendViewController.h"
#import "ThemeManger.h"
#import "ThemeButton.h"
#import "MMDrawerController.h"
#import "ZoomImageView.h"
#import "UIViewExt.h"
#import "DataService.h"
@interface SendViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,ZoomImageViewDelegate>
{
    //1 文本编辑栏
    UITextView *_textView;
    
    //2 工具栏
    UIView *_editorBar;
    
    //3 显示缩略图
    ZoomImageView *_zoomImageView;
    
    UIImage *_sendImage;
}
@end

@implementation SendViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return  self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createNavItems];
    [self _createEditorViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_textView becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //导航栏不透明，当导航栏不透明的时候 ，子视图的y的0位置在导航栏下面
    self.navigationController.navigationBar.translucent = NO;
    _textView.frame = CGRectMake(0, 0, kScreenWidth, 120);
    
    //弹出键盘
    [_textView becomeFirstResponder];
    
}

#pragma  mark - 创建子视图
- (void)_createNavItems{
    //1.关闭按钮
    ThemeButton *closeButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    closeButton.normalImageName = @"button_icon_close.png";
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    [self.navigationItem setLeftBarButtonItem:closeItem];
    
    //2.发送按钮
    ThemeButton *sendButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    sendButton.normalImageName = @"button_icon_ok.png";
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    [self.navigationItem setRightBarButtonItem:sendItem];
    
}

- (void)_createEditorViews{
    
    //1 文本输入视图
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    _textView.font = [UIFont systemFontOfSize:16.0f];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.editable = YES;
    
    _textView.backgroundColor = [UIColor lightGrayColor];
    //圆角边框
    _textView.layer.cornerRadius = 10;
    _textView.layer.borderWidth = 2;
    _textView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_textView];
    
    //2 编辑工具栏
    _editorBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 55)];
    _editorBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_editorBar];
    //3.创建多个编辑按钮
    NSArray *imgs = @[
                      @"compose_toolbar_1.png",
                      @"compose_toolbar_4.png",
                      @"compose_toolbar_3.png",
                      @"compose_toolbar_5.png",
                      @"compose_toolbar_6.png"
                      ];
    for (int i=0; i<imgs.count; i++)
    {
        NSString *imgName = imgs[i];
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(15+(kScreenWidth/5)*i, 20, 40, 33)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10+i;
        button.normalImageName = imgName;
        [_editorBar addSubview:button];
    }
    
    //3 创建label 显示位置信息
    _locLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -30, kScreenWidth, 30)];
    _locLabel.hidden = YES;
    _locLabel.font = [UIFont systemFontOfSize:14];
    _locLabel.backgroundColor = [UIColor grayColor];
    [_editorBar addSubview:_locLabel];
}

- (void)buttonAction:(UIButton *)button{
    NSLog(@"%li",button.tag);
    
    
    if (button.tag == 10) {
        //选择照片
        [self _selectPhoto];
    }else if (button.tag == 13){
        //显示位置
        [self _loaction];
        
    }else if(button.tag == 14) {  //显示、隐藏表情
        
        
    }
    
}

//发送微博
- (void)sendAction{
    NSString *text = _textView.text;
    NSString *error = nil;
    if (text.length == 0) {
        error = @"微博内容为空";
    }
    else if(text.length > 140) {
        error = @"微博内容大于140字符";
    }
    //弹出提示错误信息
    if (error != nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    //[self showStatus:@"正在发送..." show:YES ];
    
    
    
    AFHTTPRequestOperation *operation = [DataService sendWeibo:text image:_sendImage block:^(id result) {
        NSLog(@"%@",result);
        [self showStatus:@"发送成功" show:NO operation:nil];
        //[self showStatus:@"发送成功" show:NO oper];
    }];
    
    [self showStatus:@"正在发送" show:YES operation:operation];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)closeAction{
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 键盘弹出通知

- (void)keyBoardWillShow:(NSNotification *)notification{
    
    NSLog(@"%@",notification);
    //1 取出键盘frame,这个frame 相对于window的
    NSValue *bounsValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect frame = [bounsValue CGRectValue];
    //2 键盘高度
    CGFloat height = frame.size.height;
    //3 调整视图的高度
    _editorBar.bottom = kScreenHeight - height- 64;
    
}

#pragma mark - 选择照片
- (void)_selectPhoto{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerControllerSourceType sourceType;
    //选择相机 或者 相册
    if (buttonIndex == 0) {//拍照
        
        sourceType = UIImagePickerControllerSourceTypeCamera;
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"摄像头无法使用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
        
        
    }else if(buttonIndex == 1){ //选择相册
        
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }else{
        
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

//照片选择代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //弹出相册控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    //2 取出照片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //3 显示缩略图
    
    if (_zoomImageView == nil) {
        _zoomImageView = [[ZoomImageView alloc] init];
        // _zoomImageView = [[ZoomImageView alloc] initWithImage:image];
        _zoomImageView.frame = CGRectMake(10, _textView.bottom+10, 80, 80);
        [self.view addSubview:_zoomImageView];
        _zoomImageView.delegat = self;
    }
    _zoomImageView.image = image;
    _sendImage = image;
}

#pragma mark - zoomImageViewDelegate

- (void)imageWillZoomOut:(ZoomImageView *)imageView{
    
    [_textView becomeFirstResponder];
    
}

- (void)imageWillZoomIn:(ZoomImageView *)imageView{
    
    [_textView resignFirstResponder];
    
}

#pragma mark - 地理位置

/*
 修改 info.plist 增加以下两项
 NSLocationWhenInUseUsageDescription  BOOL YES
 NSLocationAlwaysUsageDescription         string “提示描述”
 */
- (void)_loaction{
    
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        
        if (kVersion > 8.0) {
            [_locationManager requestWhenInUseAuthorization];
        }
        
    }
    //设置定位精度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    NSLog(@"已经更新位置");
    [_locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"经度 %lf 纬度 %lf",coordinate.longitude,coordinate.latitude);
    
    //地理位置反编码
    //一 新浪位置反编码 接口说明  http://open.weibo.com/wiki/2/location/geo/geo_to_address
    NSString *coordString = [NSString stringWithFormat:@"%lf,%lf",coordinate.longitude,coordinate.latitude];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:coordString forKey:@"coordinate"];
    
    __weak __typeof(self) weakSelf = self;
    
    [DataService requestAFUrl:geo_to_address
                   httpMethod:@"GET"
                       params:params
                         data:nil
                        block:^(id result) {
                            NSLog(@"%@",result);
                            NSArray *geos = [result objectForKey:@"geos"];
                            
                            NSDictionary *geoDic = [geos lastObject];
                            NSString *address = [geoDic objectForKey:@"address"];
                            
                            NSLog(@"%@",address);
                          dispatch_async(dispatch_get_main_queue(), ^{
                              __strong __typeof(self) strongSelf = weakSelf;
                              strongSelf -> _locLabel.text = address;
                              strongSelf -> _locLabel.hidden = NO;
                          });
                            
                        }];
    
    
    //二 iOS内置
//    
//    CLGeocoder  *geoCoder = [[CLGeocoder alloc] init];
//    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        
//        CLPlacemark *place = [placemarks lastObject];
//        
//        NSLog(@"%@",place.name);
//        // NSLog(@"%@",place.areasOfInterest);
//        
//    }];
    
  
}
@end
