//
//  ZoomImageView.h
//  MyWeibo
//
//  Created by mac on 15/10/17.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZoomImageView;
@protocol ZoomImageViewDelegate <NSObject>

- (void)imageWillZoomIn:(ZoomImageView *)imageView;
- (void)imageWillZoomOut:(ZoomImageView *)imageView;
@end


@interface ZoomImageView : UIImageView<NSURLConnectionDataDelegate,UIActionSheetDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_fullImageView;
}

@property (nonatomic, copy)NSString *fullImageUrlString;

@property (nonatomic, weak)id<ZoomImageViewDelegate>delegat;
//gif处理
@property (nonatomic,assign) BOOL isGif;
@property (nonatomic,strong) UIImageView *iconView;
@end
