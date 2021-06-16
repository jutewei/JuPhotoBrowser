//
//  UIImage+Size.m
//  MTSkinPublic
//
//  Created by Juvid on 2017/1/3.
//  Copyright © 2017年 Juvid(zhutianwei). All rights reserved.
//

#import "UIImage+Cropping.h"

@implementation UIImage (Cropping)

-(UIImage*)setThumbnail{
    return [self setMinSide:150];
}

/**以最小边压缩**/
-(UIImage *)setMinSide:(CGFloat)newSize{
    if (newSize==0) {
        return self;
    }
    CGSize oSize=CGSizeMake(self.size.width*self.scale, self.size.height*self.scale);
    if (oSize.width<=newSize||oSize.height<=newSize) {
        return self;
    }
    CGSize  fixSize;
    if (oSize.width>oSize.height) {
        fixSize=CGSizeMake(newSize*(oSize.width/oSize.height),newSize);
    }else{
        fixSize=CGSizeMake(newSize,newSize*(oSize.height/oSize.width));
    }
    return [self juFixImage:fixSize];
}

/**以最大边压缩*/
-(UIImage *)setMaxSide:(CGFloat)minSize{
    CGSize  fixSize;
    CGSize oSize=CGSizeMake(self.size.width*self.scale, self.size.height*self.scale);
    if (oSize.width>=oSize.height) {
        fixSize=CGSizeMake(minSize,minSize*(oSize.height/oSize.width));
    }else{
        fixSize=CGSizeMake(minSize*(oSize.width/oSize.height),minSize);
    }
    return  [self juFixImage:fixSize];
}

//按指定尺寸压缩
-(UIImage *)juFixImage:(CGSize)fixSize{
    UIGraphicsBeginImageContext(fixSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [self drawInRect:CGRectMake(0,0,fixSize.width,fixSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}


//图片裁剪（指定区域裁剪）
- (UIImage *)juImageFromInRect:(CGRect)rect original:(CGSize)oSize{
    CGFloat cropingX=(rect.origin.x/oSize.width)*self.size.width;
    CGFloat cropingY=(rect.origin.y/oSize.height)*self.size.height;
    CGFloat cropingW=(rect.size.width/oSize.width)*self.size.width;
    CGFloat cropingH=(rect.size.height/oSize.height)*self.size.height;
    CGRect croping=CGRectMake(cropingX, cropingY, cropingW, cropingH);
    return [self juImageFromInRect:croping];
}

- (UIImage *)juImageFromInRect:(CGRect)cropRect{
    CGImageRef sourceImageRef = [self CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, cropRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

//加水印
-(UIImage *)juWaterWithImage:(UIImage *)image{
    UIGraphicsBeginImageContext(self.size);
    // Draw image1
    [self drawInRect:CGRectMake(0, 0, self.size.width,self.size.height)];
    // Draw image2 位置需要重写
    [image drawInRect:CGRectMake(0, 0, self.size.width,self.size.height)];
    UIImage *resultingImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

//获取Scrollview截图
-(UIImage *)juCaptureScrollView:(UIScrollView *)scrollView{
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, 2.0f);
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

@implementation NSData (Cropping)

+(NSData *)juSetImageData:(id)imageData{
    return [self juSetImageData:imageData withScale:0];
}

+(NSData *)juSetImageData:(id)imageData type:(NSInteger)type sideSize:(CGFloat)sideSize quality:(CGFloat)quality{
    UIImage *images=imageData;
    NSData  *dataImage=imageData;
    if([imageData isKindOfClass:[NSData class]]){
        dataImage=imageData;
    }else{
        dataImage=UIImageJPEGRepresentation(images, 1);
        CGFloat dataLength=dataImage.length/(1024.*1024);
        NSLog(@"原图大小: %.3fM", dataLength);
        CGFloat scale=1;
        if (type==1) {
            images=[images setMinSide:1080];
            scale=0.85;
        }else if(type==2){
            images=[images setMaxSide:1080];
            scale=0.85;
        }else if(type==3){
            if (dataLength>4) {///
                images=[images setMinSide:1080];
                dataImage=UIImageJPEGRepresentation(images, 1);
                dataLength=dataImage.length/(1024.*1024);
            }
            if (dataLength>1) {
                scale=MAX(0.3,1-(dataLength-1)*.09);
            }
        }else{
            if (type==4&&sideSize>0) {
                images=[images setMinSide:sideSize];
            }else if(type==5&&sideSize){
                images=[images setMaxSide:sideSize];
            }
            scale=quality;
        }
        dataImage= UIImageJPEGRepresentation(images, scale);
    }
    NSLog(@"压缩后大小: %.3fM", dataImage.length/(1024.*1024));
    return dataImage;
}

+(NSData *)juSetImageData:(id)imageData withScale:(CGFloat)scale{
    __block UIImage *images=imageData;
    NSData  *dataImage=imageData;
    if([imageData isKindOfClass:[NSData class]]){
        dataImage=imageData;
    }else{
        if(scale>0)return UIImageJPEGRepresentation(images, scale);
        
        dataImage=UIImageJPEGRepresentation(images, 1);
        CGFloat dataLength=dataImage.length/(1024.*1024);
        NSLog(@"原图大小: %.3fM", dataLength);
        if (dataLength>4) {///
            images=[images setMinSide:1620];
        }
        if (dataLength>1) {
            scale=MAX(0.5,1-(dataLength-1.5)*.08);
        } else{
            scale=1;
        }
        dataImage= UIImageJPEGRepresentation(images, scale);
    }
    NSLog(@"压缩后大小: %.3fM", dataImage.length/(1024.*1024));
    return dataImage;
}

@end
