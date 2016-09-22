//
//  SHDealWithPhoto.h
//  SHBaseProject
//
//  Created by Juvid on 15/11/4.
//  Copyright © 2015年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHDealWithPhoto : NSObject
+(UIImage*)setHeadTailoring:(UIImage*)image;
/**
 *  对图片进行压缩处理
 *
 *  @param images      需处理的图片
 *  @return 处理后的图片（640*640内原比例）
 */
+ (UIImage*)setTailoring:(UIImage*)image scaledToSize:(CGSize)newSize;
/**
 *  @author Juvid, 16-06-22 10:06:14
 *
 *  缓存图片
 *
 *  @param image   图片资源
 *  @param orderID 图片路径
 *
 *  @return 图片名字
 */
+(NSString *)shSetImageData:(id)image withName:(NSString *)orderID;
/**
 *  @author Juvid, 16-06-22 10:06:37
 *
 *  图片data
 *
 *  @param imageData 图片资源
 *
 *  @return data
 */
+(NSData *)shSetImageData:(id)imageData;
@end
