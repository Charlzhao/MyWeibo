//
//  ZoomImageView.m
//  MyWeibo
//
//  Created by mac on 15/10/17.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ZoomImageView.h"
#import "MBProgressHUD.h"
#import "UIViewExt.h"
#import "UIImage+GIF.h"
#import <ImageIO/ImageIO.h>
@implementation ZoomImageView
{
    NSURLConnection *_connection;
    double _length;
    NSMutableData *_data;
    MBProgressHUD *_hud;
}
- (instancetype)init
{
    self =[super init];
    if (self)
    {
        [self initTap];
        
        [self _createIconView];
    }
    return self;
}


- (void)initTap
{
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
    [self addGestureRecognizer:tap];

}

- (void)zoomIn
{
    if ([self.delegat respondsToSelector:@selector(imageWillZoomIn:)])
    {
        [self.delegat imageWillZoomIn:self];
    }
    
    
    
    [self _createViews];
    
    CGRect fram = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = fram;
    
    [UIView animateWithDuration:0.35 animations:^{
        _fullImageView.frame = _scrollView.frame;
    }completion:^(BOOL finished) {
        _scrollView.backgroundColor = [UIColor blackColor];
        [self downLoadImage];
        
    }];
}

-(void)_createIconView
{
    _iconView = [[UIImageView alloc] init];
    _iconView.image = [UIImage imageNamed:@"timeline_gif"];
    [self addSubview:_iconView];
    _iconView.hidden = YES;
}

- (void)_createViews
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window addSubview:_scrollView];
        
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        _fullImageView.image = self.image;
        [_scrollView addSubview:_fullImageView];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
        [_scrollView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTap:)];
        
        longTap.minimumPressDuration = 1;
        [_scrollView addGestureRecognizer:longTap];
    }
}

- (void)zoomOut
{
    if ([self.delegat respondsToSelector:@selector(imageWillZoomOut:)])
    {
        [self.delegat imageWillZoomOut:self];
    }
    //取消网络下载
    [_connection cancel];
    
    _scrollView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.35 animations:^{
        CGRect fram = [self convertRect:self.bounds toView:self.window];
        _fullImageView.frame = fram;
        
        //如果scroll内容偏移,偏移量也要考虑进去
        _fullImageView.top += _scrollView.contentOffset.y;

    }completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImageView = nil;
        self.hidden = NO;
    }];
}

- (void)longTap:(UILongPressGestureRecognizer *)longTap  //长按手势方法
{
    if (longTap.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"长按");
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:@"保存"
                                                  otherButtonTitles:nil];
        
        [sheet showInView:self];
    }
}

- (void)downLoadImage
{
    if (_fullImageUrlString.length != 0)
    {
        _hud = [MBProgressHUD showHUDAddedTo:_scrollView animated:YES];
        _hud.mode = MBProgressHUDModeDeterminate;
        _hud.progress = 0.0;
        
        
        NSURL *url = [NSURL URLWithString:_fullImageUrlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
        _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    }  
}
#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *headFiles = [httpResponse allHeaderFields];
    
    NSString *length = headFiles[@"Content-Length"];
    _length = [length doubleValue];
    _data = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
    CGFloat progress = _data.length / _length;
    _hud.progress = progress;
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   
    [_hud hide:YES];
    
    UIImage *image = [UIImage imageWithData:_data];
    
    _fullImageView.image = image;
    
    CGFloat length = image.size.height/image.size.width * kScreenWidth;
    if (length > kScreenHeight) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _fullImageView.height = length;
            _scrollView.contentSize = CGSizeMake(kScreenWidth, length);
            
        }];
    }
    if (_isGif)
    {
        [self showGIF];
    }
    
}

- (void)showGIF
{
    _fullImageView.image = [UIImage sd_animatedGIFWithData:_data];
    CGImageSourceRef soucce = CGImageSourceCreateWithData((__bridge CFDataRef)_data, NULL);
    
    size_t count = CGImageSourceGetCount(soucce);
    NSMutableArray *images = [NSMutableArray array];
    
    NSTimeInterval duration = 0.0f;
    
    for (size_t i = 0; i < count; i++)
    {
        //获取每一张图片 放到UIImage对象里面
        CGImageRef image = CGImageSourceCreateImageAtIndex(soucce, i, NULL);
        
        duration += 0.1;
        
        [images addObject:[UIImage imageWithCGImage:image]];
        
        CGImageRelease(image);
    }
    UIImage *animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    _fullImageView.image = animatedImage;
    
    CFRelease(soucce);
    
}

#pragma mark -UIActionSheetDelegete
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%li",buttonIndex);
    UIImage *image = _fullImageView.image;
    
    if (buttonIndex == 0)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    else if (buttonIndex == 1)
    {
        
    }
  
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //提示保存成功
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //显示模式改为：自定义视图模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"保存成功";
    
    //延迟隐藏
    [hud hide:YES afterDelay:1.5];
}

@end
