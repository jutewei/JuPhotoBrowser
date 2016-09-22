//
//  SHDealWithPhoto.m
//  SHBaseProject
//
//  Created by Juvid on 15/11/4.
//  Copyright © 2015年 Juvid. All rights reserved.
//
#define imageSize 1280
#import "SHDealWithPhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "GTMBase64.h"
@implementation SHDealWithPhoto

+(UIImage*)setHeadTailoring:(UIImage*)image{
    return [self setTailoring:image scaledToSize:CGSizeMake(imageSize, imageSize)];
}
+ (UIImage*)setTailoring:(UIImage*)image scaledToSize:(CGSize)newSize{
    if (image.size.width<imageSize||image.size.height<imageSize) {
        newSize=image.size;
    }
    CGSize  FixSize=CGSizeMake(newSize.width,newSize.width/(image.size.width/image.size.height));
    // Create a graphics image context
    UIGraphicsBeginImageContext(FixSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    
    [image drawInRect:CGRectMake(0,0,FixSize.width,FixSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+(NSString *)shSetImageData:(id)image withName:(NSString *)imageFlie{
    NSData *data= [self shSetImageData:image withScale:1];
    NSFileManager *fileManager=[NSFileManager new];
    NSString *imageName=[NSString stringWithFormat:@"%@.JPG",[Common shGetDateName]];
    NSString *strPath=[LEFilePath shSetUserMecPicPath:imageName];
//    [LEFilePath shGetFilePath:[NSString stringWithFormat:@"%@/%@",CreatMecRecord,imageFlie] fileName:[NSString stringWithFormat:@"%@",imageName]];
    if([fileManager createFileAtPath:strPath contents:data attributes:nil]){
        return imageName;
    }
    return nil;
}
+(NSData *)shSetImageData:(id)imageData{
    return [self shSetImageData:imageData withScale:0.9];
}
+(NSData *)shSetImageData:(id)imageData withScale:(CGFloat)scale{
    UIImage *images;
    if([imageData isKindOfClass:[ALAsset class]])//_roaldSearchText
    {
        ALAsset *asset=imageData;
        images=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        images=[SHDealWithPhoto setHeadTailoring:images];
    }else if([imageData isKindOfClass:[UIImage class]]){
        images=imageData;
    }
    NSData  *Data =[NSData data];
    if([imageData isKindOfClass:[NSData class]]){
        Data=imageData;
    }else{
        NSData *dataFull=UIImageJPEGRepresentation(images, 1);
        NSLog(@"原图大小: %.3fKB", dataFull.length / 1024.);
        if (dataFull.length/1024.<100) {
            scale=1;
            dataFull=nil;
        }
        Data= UIImageJPEGRepresentation(images, scale);
    }
     NSLog(@"压缩后大小: %.3fKB", Data.length / 1024.);
    return Data;
}
@end
