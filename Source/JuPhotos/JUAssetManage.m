//
//  PHPhotoLibraryManage.m
//  JuPhotoBrowser
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/4/27.
//

#import "JUAssetManage.h"
#import <objc/runtime.h>
@implementation JUAssetManage
+(NSMutableArray *)juFetchPhotoAlbums{
    //            最近添加
    NSMutableArray *arrAlbums=[NSMutableArray array];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        if (assetsFetchResults.count) {
            [arrAlbums addObject:collection];
        }
    }];
    // 个人收藏
    PHFetchResult<PHAssetCollection *> *favoritesCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumFavorites options:nil];
    [favoritesCollection enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        if (assetsFetchResults.count) {
            [arrAlbums addObject:collection];
        }
    }];
    //用户创建的相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        if (assetsFetchResults.count) {
            [arrAlbums addObject:collection];
        }
    }];
    return arrAlbums;
}
@end


@implementation PHAsset(deal)

-(void)setIsOriginal:(BOOL)isOriginal{
    NSNumber *number = [[NSNumber alloc] initWithBool:isOriginal];
    objc_setAssociatedObject(self, @selector(isOriginal), number, OBJC_ASSOCIATION_COPY);
}

-(BOOL)isOriginal{
    return [objc_getAssociatedObject(self, @selector(isOriginal)) boolValue];
}

@end
