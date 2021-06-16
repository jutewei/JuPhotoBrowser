//
//  PFBPreviewScrollView.h
//  PFBDoctor
//
//  Created by Juvid on 16/7/21.
//  Copyright © 2016年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PFBScrollViewDelegate;
@interface PFBPhotoContainerView : UIScrollView<UIScrollViewDelegate>{
    NSInteger sh_currentIndex;
    NSArray *sh_ArrGroupImgs;
}
+(instancetype)initView:(UIView *)view;

+(instancetype)initView:(UIView *)view withDelegate:(id<PFBScrollViewDelegate>)delegate;
@property (nonatomic,assign) id<PFBScrollViewDelegate> shDelegate;

/**
 *  @author Juvid, 16-07-21 15:07:56
 *
 *  初始化照片容器
 *
 *  @param index 第几张
 *
 *  @return 照片scroll
 */
-(id)shSetPhotoIndex:(NSInteger)index;
/**
 *  @author Juvid, 16-07-21 15:07:01
 *
 *  设置预览照片组
 *
 *  @param arrImgs 照片数组
 *  @param indexs  当前第几张
 */
-(void)shSetImages:(NSArray *)arrImgs currentIndex:(NSInteger)indexs;

//-(void)shCurrentIndex:(NSInteger)indexs;///< 滑动后定位到第几张
@end


@protocol PFBScrollViewDelegate <NSObject>
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@optional
-(void)shTapHideBar;
-(void)shCurrentIndex:(NSInteger)indexs;
@end