//
//  UIImageView+netImage.h
//  JuPhotoBrowser
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/4/27.
//

#import <UIKit/UIKit.h>
typedef void(^JuImageLoaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL);
typedef void(^JuImageLoaderCompletedBlock)(UIImage * _Nullable image, BOOL finished);
NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (netImage)

- (void)juSetImageWithURL:(nullable NSString *)url
                  progress:(nullable JuImageLoaderProgressBlock)progressBlock
                completed:(nullable JuImageLoaderCompletedBlock)completedBlock;

+(BOOL)diskImageDataExistsWithKey:(NSString *)key;

+(UIImage *)imageFromDiskCacheForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
