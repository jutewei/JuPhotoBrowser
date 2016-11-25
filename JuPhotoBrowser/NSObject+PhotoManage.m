//
//  NSObject+PhotoManage.m
//  PFBDoctor
//
//  Created by Juvid on 2016/11/18.
//  Copyright © 2016年 Juvid. All rights reserved.
//

#import "NSObject+PhotoManage.h"

#import "RHAssetsLibrary.h"
static NSString * const JuCollectionName = @"Juvid";
@implementation NSObject (PhotoManage)
-(void)juGetThumbnail:(void(^)(UIImage *image))imageHandle{
    if ([self isKindOfClass:[ALAsset class]]) {
        ALAsset *asset=(ALAsset *)self;
        imageHandle([UIImage imageWithCGImage:asset.thumbnail]);
    }else if([self isKindOfClass:[PHAsset class]]){
        CGSize targetSize = CGSizeMake(80, 80);
        // 请求图片
        [self juImageRequestSize:targetSize handle:imageHandle];
    }else if([self isKindOfClass:[UIImage class]]){
        imageHandle((UIImage *)self);
    }
//    return nil;
}
-(void)juGetRatioThumbnail:(void(^)(UIImage *image))imageHandle{
    if ([self isKindOfClass:[ALAsset class]]) {
        ALAsset *asset=(ALAsset *)self;
        imageHandle([UIImage imageWithCGImage:asset.aspectRatioThumbnail]);
    }else if([self isKindOfClass:[PHAsset class]]){
        CGSize targetSize = CGSizeMake(150, 150);
        [self juImageRequestSize:targetSize handle:imageHandle];
    }else if([self isKindOfClass:[UIImage class]]){
        imageHandle((UIImage *)self);
    }
}
-(void)juGetfullScreenImage:(void(^)(UIImage *image))imageHandle{
    if ([self isKindOfClass:[ALAsset class]]) {
        ALAsset *asset=(ALAsset *)self;
        imageHandle ([UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]);
    }else if([self isKindOfClass:[PHAsset class]]){
        PHAsset *asset=(PHAsset *)self;
        CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        [self juImageRequestSize:size handle:imageHandle];
    }else if([self isKindOfClass:[UIImage class]]){
        imageHandle((UIImage *)self);
    }
}

/**
 获取图片

 @param targetSize 图片尺寸
 @param imageHandle 返回图片
 */
-(void)juImageRequestSize:(CGSize)targetSize handle:(void(^)(UIImage *image))imageHandle {
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.synchronous = YES;
    // 请求图片
    [[PHImageManager defaultManager] requestImageForAsset:(PHAsset *)self targetSize:targetSize contentMode:PHImageContentModeDefault options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        imageHandle(result);
    }];
}
@end

@implementation UIImage (imageSave)

-(void)juSaveAssetPhoto:(void(^)(ALAsset *asset))imageHandle{

    ALAssetsLibrary *assetsLibrary = [RHAssetsLibrary rh_getShareAssetsLibrary];
    [assetsLibrary writeImageToSavedPhotosAlbum:[self CGImage] orientation:(ALAssetOrientation)self.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
//            [SHUIAlertView ShowAlert:@"无法使用iPhone相册" Message:@"请在iPhone的“设置-隐私-照片”中允许访问相册"];
            NSLog(@"无法使用iPhone相册");
        }else{
            [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                imageHandle(asset);
            } failureBlock:^(NSError *error) {
//                [SHUIAlertView ShowAlert:@"" Message:@"照片选取失败，请重试！"];
                NSLog(@"照片选取失败，请重试！");
            }];
        }
    }];
}



-(void)juSaveRHAssetPhoto:(void(^)(PHAsset * Asset))imageHandle{

    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) {
            if (status==PHAuthorizationStatusDenied||status==PHAuthorizationStatusRestricted) {
//                [SHUIAlertView ShowAlert:@"无法使用iPhone相册" Message:@"请在iPhone的“设置-隐私-照片”中允许访问相册"];
                NSLog(@"无法使用iPhone相册");
            }
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            //            // 保存相片到相机胶卷
            __block PHObjectPlaceholder *createdAsset = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:self].placeholderForCreatedAsset;
            } error:&error];

            if (error) {
                NSLog(@"保存失败：%@", error);
                return;
            }
            // 拿到自定义的相册对象
            PHAssetCollection *collection = [self collection];
            if (collection == nil) return;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                PHFetchResult *fetchCollectionResult=[PHAsset fetchAssetsWithLocalIdentifiers:@[createdAsset.localIdentifier] options:nil];
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection] insertAssets:@[createdAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
                imageHandle(fetchCollectionResult.lastObject);
            } error:&error];

            if (error) {
                NSLog(@"保存失败：%@", error);
            } else {
                NSLog(@"保存成功");
            }
        });
    }];
}

-(PHAssetCollection *)collection
{
    // 先从已存在相册中找到自定义相册对象
    PHFetchResult<PHAssetCollection *> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collectionResult) {
        if ([collection.localizedTitle isEqualToString:JuCollectionName]) {
            return collection;
        }
    }

    // 新建自定义相册
    __block NSString *collectionId = nil;
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:JuCollectionName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];

    if (error) {
        NSLog(@"获取相册【%@】失败", JuCollectionName);
        return nil;
    }

    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].lastObject;
}
@end

