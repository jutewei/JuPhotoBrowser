//
//  PHPhotoLibraryManage.h
//  JuPhotoBrowser
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/4/27.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface JUAssetManage : NSObject
+(NSMutableArray *)juFetchPhotoAlbums;
@end

@interface PHAsset(deal)
@property(nonatomic,assign) BOOL isOriginal;//原图
@end

NS_ASSUME_NONNULL_END
