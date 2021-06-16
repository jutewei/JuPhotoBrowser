//
//  ImgScrollView.h
//  mbstore
//
//  Created by Juvid on 14-4-28.
//  Copyright (c) 2014年 huangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImgScrollViewDelegate <NSObject>
@optional
- (void) tapImageViewTappedWithObject:(id) sender;
-(void)shCurrentIndex:(NSInteger)indexs;
-(void)shTapHideBar;

@end

@interface SHItemPhotoView : UIScrollView

@property (weak) id<ImgScrollViewDelegate> i_delegate;
@property   BOOL isAnimate;
@property   BOOL isSetImage;
@property (nonatomic,strong) UIImageView *imgView;
- (void) setContentWithFrame:(CGRect) rect isAnimate:(BOOL)isAnimate;
- (void) setImage:(UIImage *) image;
- (void) shSetImage:(id)imageData;
- (void) setAnimationRect;
- (void) rechangeInitRdct;

@end
