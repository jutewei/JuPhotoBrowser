//
//  SHGetPhotos.h
//  SHBaseProject
//
//  Created by Juvid on 15/11/4.
//  Copyright © 2015年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
//#import "SHPhotoAlbumPreViewVC.h"
#import "JuAlbumPreviewVC.h"
#import "JuPhotoGroupTVC.h"
#import "JuPhotoAlert.h"


//typedef void(^__nullable JuImageHandle)(id __nullable result);             //下步操作后有跟新数据
@protocol JUChoosePhotoDelegate;
//PreviewPhotoDelegate
@interface JuPhotoPickers : NSObject<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
}

/** 以下是新方法***/
+ (instancetype _Nullable ) sharedInstance;

/**
 选择相册

 @param allowsEdit 是否可用编辑图片
 @param handle 图片回调
 */
-(void)juSelectSysPhoto:(BOOL)allowsEdit handle:(JuImageHandle)handle;
-(void)juSelectSysPhoto:(BOOL)allowsEdit withVC:(UIViewController *_Nullable)vc handle:(JuImageHandle)handle;
/**
 相册选

 @param maxNum 最大数量
 @param arrList 已选图片
 @param handle 回调
 */
-(void)juSelectMutlePhotos:(NSInteger)maxNum selectImages:(NSMutableArray * _Nullable )arrList handle:(JuImageHandle)handle;

-(void)juSelectMutlePhotos:(NSInteger)maxNum selectImages:(NSMutableArray *_Nullable)arrList withVC:(UIViewController *_Nullable)vc handle:(JuImageHandle)handle;
/**
 是否预览完直接上传图片
 */
@property BOOL isUpLoad;

@end


@protocol JUChoosePhotoDelegate <NSObject>
/**
 *获取照片回调
 */
@optional
-(void)fbFinishImage:(id _Nullable )imageData;

@end
