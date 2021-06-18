//
//  UIImage+Cropping.h
//  JuPhotoBrowser
//
//  Created by Juvid on 2017/1/3.
//  Copyright © 2017年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Cropping)

/**裁剪略缩图*/
-(UIImage*)setThumbnail;

/**以最小边压缩**/
-(UIImage *)setMinSide:(CGFloat)size;

/**以最大边压缩*/
-(UIImage *)setMaxSide:(CGFloat)size;

//按指定尺寸压缩
- (UIImage *)juFixImage:(CGSize)fixSize;

/// 指定区域裁剪
/// @param rect 相对位置
/// @param oSize 相对大小
- (UIImage *)juImageFromInRect:(CGRect)rect original:(CGSize)oSize;

/// 指定区域裁剪
/// @param cropRect 绝对位置
- (UIImage *)juImageFromInRect:(CGRect)cropRect;

//加水印
-(UIImage *)juWaterWithImage:(UIImage *)image;

-(UIImage *)juCaptureScrollView:(UIScrollView *)scrollView;

@end

@interface NSData (Cropping)
/*质量压缩*/
+(NSData *)juSetImageData:(id)imageData;

+(NSData *)juSetImageData:(id)imageData withScale:(CGFloat)scale;

+(NSData *)juSetImageData:(id)imageData
                     type:(NSInteger)type
                 sideSize:(CGFloat)sideSize
                  quality:(CGFloat)quality;
@end
