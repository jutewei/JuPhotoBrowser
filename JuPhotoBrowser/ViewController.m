//
//  ViewController.m
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/21.
//  Copyright © 2016年 Juvid. All rights reserved.
//

#import "ViewController.h"
#import "JuPhotoGroupViewController.h"
#import <Photos/Photos.h>
#import "NSObject+PhotoManage.h"
/** 相册名字 */
static NSString * const XMGCollectionName = @"皮肤宝医生";
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
/**
 * 查询所有的图片
 */
/*- (IBAction)searchAllImages {
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;

        dispatch_async(dispatch_get_main_queue(), ^{
            // 遍历所有的自定义相册
            PHFetchResult<PHAssetCollection *> *collectionResult0 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            for (PHAssetCollection *collection in collectionResult0) {
                [self searchAllImagesInCollection:collection];
            }

            // 获得相机胶卷的图片
            PHFetchResult<PHAssetCollection *> *collectionResult1 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            for (PHAssetCollection *collection in collectionResult1) {
                if (![collection.localizedTitle isEqualToString:@"Camera Roll"]) continue;
                [self searchAllImagesInCollection:collection];
                break;
            }
        });
    }];
}*/

/**
 * 查询某个相册里面的所有图片
 */
/*- (void)searchAllImagesInCollection:(PHAssetCollection *)collection
{
    // 采取同步获取图片（只获得一次图片）
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.synchronous = YES;

    NSLog(@"相册名字：%@", collection.localizedTitle);

    // 遍历这个相册中的所有图片
    PHFetchResult<PHAsset *> *assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    for (PHAsset *asset in assetResult) {
        // 过滤非图片
        if (asset.mediaType != PHAssetMediaTypeImage) continue;

        // 图片原尺寸
        CGSize targetSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        // 请求图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeDefault options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSLog(@"图片：%@ %@", result, [NSThread currentThread]);
        }];
    }
}*/

#pragma mark - 保存图片到自定义相册
/**
 * 获得自定义的相册对象
 */
- (PHAssetCollection *)collection
{
    // 先从已存在相册中找到自定义相册对象
    PHFetchResult<PHAssetCollection *> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collectionResult) {
        if ([collection.localizedTitle isEqualToString:XMGCollectionName]) {
            return collection;
        }
    }

    // 新建自定义相册
    __block NSString *collectionId = nil;
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:XMGCollectionName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];

    if (error) {
        NSLog(@"获取相册【%@】失败", XMGCollectionName);
        return nil;
    }

    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].lastObject;
}

/**
 * 保存图片到相册
 */
- (IBAction)saveImage {
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;

        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;

//            // 保存相片到相机胶卷
            __block PHObjectPlaceholder *createdAsset = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:[UIImage imageNamed:@"test.jpeg"]].placeholderForCreatedAsset;
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
                NSLog(@"%@",fetchCollectionResult.lastObject);
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection] insertAssets:@[createdAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
            } error:&error];

            if (error) {
                NSLog(@"保存失败：%@", error);
            } else {
                NSLog(@"保存成功");
            }
        });
    }];
}
- (IBAction)juTouchSave:(UIButton *)sender {
    UIImage *image=  [UIImage imageNamed:@"test.jpeg"];
    [image shSaveRHAssetPhoto:^(PHAsset *Asset) {
        ;
    }];
}

- (IBAction)juTouchSelectPhoto:(id)sender {
    JuPhotoGroupViewController *vc=[[JuPhotoGroupViewController alloc]init];
    vc.ju_maxNumSelection=8;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
