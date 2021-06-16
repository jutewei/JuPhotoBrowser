//
//  ChangImgSize.h
//  mbstore
//
//  Created by Juvid on 14-4-28.
//  Copyright (c) 2014年 huangyi. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "PFBPhotoContainerView.h"
@protocol ChageImgSizeDelegate;
@interface SHPreviewBigPhotos : PFBPhotoContainerView<UIScrollViewDelegate>
//@property(nonatomic,strong)UIView *leChangView;
@property(assign,nonatomic) id<ChageImgSizeDelegate>leDetegate;

//初始化
+(id)shInit;

/**
 *  @author Juvid, 15-07-14 15:07:18
 *
 *  初始化   显示图片闪退用此方法
 *
 *  @param supview 图片加在supview层 传nil时加在window上
 *
 *  @return self
 */
+(id)shInit:(UIView *)changVie;
/**
 *  @author Juvid, 15-07-14 15:07:38
 *
 *  初始化   显示图片闪退用此方法
 *
 *  @param supview  self的父view
 *  @param changVie 当前要改变的UIImageView
 *
 *  @return self
 */
+(id)shInit:(UIView *)changVie supView:(UIView*)supview;


/**
 *  @author Juvid, 15-07-14 15:07:07
 *
 *  单张图片
 *
 *  @param image 传人的图片
 */
-(void)shSetImage:(id)imageData;

///**
// *  多张
// *
// *  @param arrImgs  一组图片（图片地址、图片、底层model）
// *  @param indexs 当前第几张
// */
//
//-(void)shSetImages:(NSArray *)arrImgs currentIndex:(NSInteger)indexs;
/**
 *  @author Juvid, 15-07-14 16:07:38
 *
 *  加入一组图片
 *
 *  @param arrImgs  一组图片（图片地址、图片、底层model）
 *  @param indexs   当前第几张图片
 *  @param delegate 代理
 */
-(void)shSetImages:(NSArray *)arrImgs currentIndex:(NSInteger)indexs Delegate:(id<ChageImgSizeDelegate>)delegate;

//及时通讯使用
@end


@protocol ChageImgSizeDelegate <NSObject>

-(void)shCurrentIndex:(NSInteger)indexs;

@end
