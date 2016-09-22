//
//  SHGetPhotos.m
//  SHBaseProject
//
//  Created by Juvid on 15/11/4.
//  Copyright © 2015年 Juvid. All rights reserved.
//

#import "SHChoosePhotos.h"
#import "RHAssetsLibrary.h"
#import "SHDealWithPhoto.h"
#import "SHUIAlertView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface SHChoosePhotos (){
    NSMutableArray *sh_MArrAsset;
    UIActionSheet *showPhotoSelect;
}

@end

@implementation SHChoosePhotos
-(id)init{
    self=[super init];
    if (self) {
        _maximumNumberOfSelection=8;
        sh_MArrAsset=[NSMutableArray array];
    }
    return self;
}
-(instancetype)initWitDelegate:(id<SHChoosePhotoDelegate>)delegete{
    self=[self init];
    self.shDelegate=delegete;
    return self;
}
-(void)setMaximumNumberOfSelection:(NSUInteger)maximumNumberOfSelection{
    _maximumNumberOfSelection=maximumNumberOfSelection;
    self.allowsMultipleSelection=YES;
}
-(void)shSelectPhoto{
    
    if (_allowsMultipleSelection) {
        if ([self shImageCount]>=_maximumNumberOfSelection) {
            [SHUIAlertView ShowAlert:@"提示" Message: [NSString stringWithFormat:@"最多选择%lu张照片,请先删除部分照片再重新选择！",(unsigned long)_maximumNumberOfSelection]];
            return;
        }
    }
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
//    if (IPHONE4S) {
//        showPhotoSelect=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择", nil];
//        [showPhotoSelect showInView: window];
//    }else{
        showPhotoSelect=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [showPhotoSelect showInView: window];
//    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"取消"]){
        [self shSelectAction:buttonIndex];
    }
}

#pragma mark 选择照片方式
-(void)shSelectAction:(NSInteger)buttonIndex{
    UIImagePickerController *controller =[[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.allowsEditing = _allowsEditing;
    if (buttonIndex==1) {
        if ([self isPhotoLibraryAvailable]&&[self canUserPickPhotosFromPhotoLibrary]){
            if (_allowsMultipleSelection) {
                QBImagePickerController* vc = [[QBImagePickerController alloc]init];
                vc.delegate = self;
                vc.allowsMultipleSelection = YES;
                vc.maximumNumberOfSelection = _maximumNumberOfSelection-[self shImageCount];
                if (self.presentController) {
                    UIViewController *pareVc=(UIViewController *)self.presentController;
                    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                    [pareVc presentViewController:nav animated:YES completion:nil];
                }else if(self.shDelegate){
                    UIViewController *pareVc=(UIViewController *)self.shDelegate;
                    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                    [pareVc presentViewController:nav animated:YES completion:nil];
                }
            }
            else {
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:( NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                if (self.presentController) {
                     [(UIViewController *)self.presentController presentViewController:controller animated:YES completion:nil];
                }
                else if(self.shDelegate){
                     [(UIViewController *)self.shDelegate presentViewController:controller animated:YES completion:nil];
                }
            }
        }
    }
    else if(buttonIndex==0){
        if ([self isCameraAvailable] &&
            [self doesCameraSupportTakingPhotos]){
            if (IPHONE4S) {
                controller.videoQuality = UIImagePickerControllerQualityTypeLow;
            }
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            NSString *requiredMediaType = (__bridge NSString *)kUTTypeImage;
            controller.mediaTypes = [[NSArray alloc]
                                     initWithObjects:requiredMediaType, nil];
            if (self.presentController) {
                [(UIViewController *)self.presentController presentViewController:controller animated:YES completion:nil];
            } else if(self.shDelegate){
                [(UIViewController *)self.shDelegate presentViewController:controller animated:YES completion:nil];
            }
        }
    }
    
}



- (void)  imagePickerController:(UIImagePickerController *)picker
  didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString    *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(__bridge NSString *)kUTTypeImage]){
        UIImage *theImage=nil;
        if ([picker allowsEditing]){
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {//拍照存图片
            if (_allowsMultipleSelection) {
                [self shSaveAssetPhoto:theImage];//允许多选写路径
                return;
            }
            else {//直接存
//                [NSThread detachNewThreadSelector:@selector(UseImage:) toTarget:self withObject:theImage];
                theImage=[SHDealWithPhoto setHeadTailoring:theImage];
                UIImageWriteToSavedPhotosAlbum(theImage, self,NULL, NULL);
                
            }
        }
        
        if ([self.shDelegate respondsToSelector:@selector(fbFinishImage:)]) {
            [self.shDelegate fbFinishImage:theImage]; //        裁剪头像图片
            return;
        }
        
    }
}
#pragma mark 获取Asset图片
-(void)shSaveAssetPhoto:(UIImage *)images{

    ALAssetsLibrary *assetsLibrary = [RHAssetsLibrary rh_getShareAssetsLibrary];
    [assetsLibrary writeImageToSavedPhotosAlbum:[images CGImage] orientation:(ALAssetOrientation)images.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            [SHUIAlertView ShowAlert:@"无法使用iPhone相册" Message:@"请在iPhone的“设置-隐私-照片”中允许访问相册"];
        }else{
            [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                if([self.shDelegate respondsToSelector:@selector(fbFinishImage:)]){
//                    if (!_leAssets) _leAssets=[NSMutableArray array];
                    [sh_MArrAsset addObject:asset];
                    [self shFinishSelectImage:sh_MArrAsset];
                }
            } failureBlock:^(NSError *error) {
                [SHUIAlertView ShowAlert:@"" Message:@"照片选取失败，请重试！"];
            }];
        }
        
    }];
}
#pragma mark UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)setLeAssets:(NSMutableArray *)leAssets{
    [sh_MArrAsset removeAllObjects];
    if (leAssets) {
        _leAssets=leAssets;
    }else{
        _leAssets =[NSMutableArray array];
    }
}
#pragma mark _______QBImagePicker delegate
//多张图片预览
- (void)QB_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets isPreview:(BOOL)ispreview{
//    if (!_leAssets) _leAssets=[NSMutableArray array];
    [sh_MArrAsset removeAllObjects];
    for (ALAsset *asset in assets) {
//        if (![_leAssets containsObject:asset]) {
            [sh_MArrAsset addObject:asset];
//        }
    }
    if(!ispreview){
        [self shFinishSelectImage:sh_MArrAsset];
        [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }else {
        SHPhotoAlbumPreViewVC *vc=[[SHPhotoAlbumPreViewVC alloc]init];
        vc.isUnLoad=self.isUpLoad;
        vc.sh_ImageItems=sh_MArrAsset;
        vc.isPreviewCurrent=YES;
        vc.delegate=self;
        [imagePickerController.navigationController pushViewController:vc animated:YES];
    }
}
-(void)QB_finishPickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets{
//[self shFinishSelectImage]
}
- (void)QB_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [sh_MArrAsset removeAllObjects];
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark PreviewDelegate 完成预览
-(void)shFinishSelectImage:(id)arrImg{
    NSMutableArray *arrResult=[NSMutableArray array];
    [arrResult addObjectsFromArray:_leAssets];
    [arrResult addObjectsFromArray:arrImg];
    if([self.shDelegate respondsToSelector:@selector(fbFinishImage:)]){
        [self.shDelegate fbFinishImage:arrResult];
    }
    
}
-(NSInteger)shImageCount{
    return sh_MArrAsset.count+_leAssets.count;
}
//拍照
- (BOOL) isCameraAvailable{
    
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
}
- (BOOL) doesCameraSupportTakingPhotos{
    
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage
                          sourceType:UIImagePickerControllerSourceTypeCamera];
    
}

//照片库
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(NSString *)kUTTypeImage
            sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

//判断是否支持多媒体
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType
                  sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    
    __block BOOL result = NO;
    
    if ([paramMediaType length] == 0){
        [SHUIAlertView ShowAlert:@"警告" Message:@"没有可用媒体" ];
        //        NSLog(@"Media type is empty.");
        return NO;
    }
    if (paramSourceType==UIImagePickerControllerSourceTypePhotoLibrary) {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus ==ALAuthorizationStatusDenied || authStatus==AVAuthorizationStatusRestricted) {
            [SHUIAlertView ShowAlert:@"无法使用iPhone相册" Message:@"请在iPhone的“设置-隐私-照片”中允许访问相册"];
            return NO;
        }
    }
    else{
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus ==ALAuthorizationStatusDenied || authStatus==AVAuthorizationStatusRestricted)
        {
            [SHUIAlertView ShowAlert:@"无法使用iPhone相机" Message:@"请在iPhone的“设置-隐私-相机”中允许访问相机"];
            return NO;
        }
    }
    //判断iOS7的宏，没有就自己写个，下边的方法是iOS7新加的，7以下调用会报错
    
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         
         NSString *mediaType = (NSString *)obj;
         if ([mediaType isEqualToString:paramMediaType]){
             result = YES;
             *stop= YES;
         }
         
     }];
    
    return result;
    
}

@end
