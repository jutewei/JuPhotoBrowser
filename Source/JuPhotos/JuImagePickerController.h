//
//  JuSystemPictureVC.h
//  JuPhotoBrowser
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/4/26.
//

#import <UIKit/UIKit.h>
#import "JuPhotoConfig.h"
NS_ASSUME_NONNULL_BEGIN
//调用系统相册，用于获取一张图片
@interface JuImagePickerController : UIImagePickerController

+(instancetype)initImagePickType:(UIImagePickerControllerSourceType )sourceType
                   allowsEditing:(BOOL)allowsEditing
                          handle:(JuPhotoHandle)handle;
//照片库
+ (BOOL) isPhotoLibraryAvailable;
@end

NS_ASSUME_NONNULL_END
