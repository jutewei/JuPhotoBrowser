//
//  SHGetPhotos.h
//  SHBaseProject
//
//  Created by Juvid on 15/11/4.
//  Copyright © 2015年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "JuPhotoGroupViewController.h"
#import "SHPhotoAlbumPreViewVC.h"
@protocol SHChoosePhotoDelegate;
@interface SHChoosePhotos : NSObject<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,JuPhotoDelegate,PreviewPhotoDelegate>{
    int loadCount;
    int imgCount;
    NSString *leImagePath;
    UIImage *lePhotoImage;
    
}
-(instancetype)initWitDelegate:(id<SHChoosePhotoDelegate>)delegete;

/**
 *actiont代理调用方法
 */
-(void)shSelectPhoto;//显示弹框


@property (weak,nonatomic ) id<SHChoosePhotoDelegate> shDelegate;
@property (nonatomic, weak) UIViewController *presentController;

@property (nonatomic, assign) BOOL allowsMultipleSelection;//允许多选

@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;//最多张数

@property (nonatomic,strong) NSMutableArray* leAssets;

@property BOOL allowsEditing;//允许编辑

@property BOOL isUpLoad;

//@property BOOL isNotPreview;///< 不预览
@end


@protocol SHChoosePhotoDelegate <NSObject>
/**
 *获取照片回调
 */
@optional
-(void)fbFinishImage:(id)imageData;

@end
