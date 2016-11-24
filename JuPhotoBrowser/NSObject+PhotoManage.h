//
//  NSObject+PhotoManage.h
//  PFBDoctor
//
//  Created by Juvid on 2016/11/18.
//  Copyright © 2016年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
@interface NSObject (PhotoManage)

/**
 小图

 @param imageHandle 图片
 */
-(void)shGetThumbnail:(void(^)(UIImage *image))imageHandle;

/**
 中图

 @param imageHandle 图片
 */
-(void)shGetRatioThumbnail:(void(^)(UIImage *image))imageHandle;

/**
 原图

 @param imageHandle 图片
 */
-(void)shGetfullScreenImage:(void(^)(UIImage *image))imageHandle;
@end


@interface UIImage (imageSave)


/**
 保存照片 老框架

 @param imageHandle 照片源头
 */
-(void)shSaveAssetPhoto:(void(^)(ALAsset *asset))imageHandle;

/**
 保存相册 photos 框架

 @param imageHandle 照片源
 */
-(void)shSaveRHAssetPhoto:(void(^)(PHAsset * Asset))imageHandle;
@end
