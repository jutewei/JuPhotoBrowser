//
//  UIImageView+netImage.m
//  TestImage
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/4/27.
//

#import "UIImageView+netImage.h"

@implementation UIImageView (netImage)

- (void)juSetImageWithURL:(nullable NSString *)url
                  progress:(nullable JuImageLoaderProgressBlock)progressBlock
                 completed:(nullable JuImageLoaderCompletedBlock)completedBlock {
   
}

+(BOOL)diskImageDataExistsWithKey:(NSString *)key{
    return NO;
}

+(UIImage *)imageFromDiskCacheForKey:(NSString *)key{
    return nil;
}

@end
