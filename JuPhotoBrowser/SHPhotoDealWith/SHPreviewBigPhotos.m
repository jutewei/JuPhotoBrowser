//
//  ChangImgSize.m
//  mbstore
//
//  Created by Juvid on 14-4-28.
//  Copyright (c) 2014年 huangyi. All rights reserved.
//

#import "SHPreviewBigPhotos.h"
#import "UIImageView+ModCache.h"
#import "SHItemPhotoView.h"
#import "UIView+Frame.h"
#import "SHUserShare.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface SHPreviewBigPhotos ()<ImgScrollViewDelegate>{
}

@property (nonatomic,strong) UIPageControl* sh_labPage;
@property (nonatomic,weak)  UIView *sh_vieChang;///< 根据这个view坐标放大
@property (nonatomic,weak)  UIView *sh_SupView;
@end


@implementation SHPreviewBigPhotos

- (id)initWithView:(UIView *)changView
{
    self = [super init];
    if (self) {
        if (changView) {
           _sh_vieChang=changView;
        }
        // Initialization code
        self.alpha=0.0;
        [self shShowSelf];
    }
    return self;
}
+(id)shInit{
    return [self shInit:nil];
}
+(id)shInit:(UIView *)supview{
    return [[SHPreviewBigPhotos alloc]initWithView:supview];
}
+(id)shInit:(UIView *)changView supView:(UIView*)supview{
    SHPreviewBigPhotos *changImg=[[SHPreviewBigPhotos alloc]initWithView:supview];
    changImg.sh_SupView=supview;
    return changImg;
}
/**显示自己*/
-(void)shShowSelf{

    if (_sh_SupView) {
        [_sh_SupView addSubview:self];
    }else{
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        [window addSubview:self.sh_labPage];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=1.0;
    }completion:^(BOOL finished) {
        if (!_sh_SupView) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }
    }];
    
}

-(void)shSetImage:(id)imageData{
    [self shSetImages:@[imageData] currentIndex:0];
}
-(void)shSetImages:(NSArray *)arrImgs currentIndex:(NSInteger)indexs Delegate:(id<ChageImgSizeDelegate>)delegate{
    if (delegate) {
        self.leDetegate=delegate;
    }

    [self shSetImages:arrImgs currentIndex:indexs];
}
-(void)shSetImages:(NSArray *)arrImgs currentIndex:(NSInteger)indexs{
    [super shSetImages:arrImgs currentIndex:indexs];
    self.sh_labPage.numberOfPages=sh_ArrGroupImgs.count;
    self.sh_labPage.currentPage=indexs;
}
- (void)showImageScrollView {
    for (int i=0; i<sh_ArrGroupImgs.count; i++) {
       SHItemPhotoView *tmpImgScrollView=[self shSetPhotoIndex:i];
        CGRect convertRect;
        if (_sh_vieChang) {
            convertRect = [[_sh_vieChang superview] convertRect:_sh_vieChang.frame toView:SHUser_Share.topViewcontrol.view];
            convertRect.origin.y+=64;
        }else{
            convertRect = [[self superview] convertRect:self.frame toView:self.superview];
        }
        [tmpImgScrollView setContentWithFrame:convertRect isAnimate:_sh_vieChang?YES:NO];
        [tmpImgScrollView shSetImage:sh_ArrGroupImgs[i]];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [super scrollViewDidEndDecelerating:scrollView];
    NSInteger page = scrollView.contentOffset.x/self.bounds.size.width;
    SHItemPhotoView *tmpImgScrollView =[self viewWithTag:page+100];
    if (_sh_vieChang) {
        tmpImgScrollView.isAnimate=(page==sh_currentIndex);
    }

    _sh_labPage.currentPage=page;
}

-(void)shCurrentIndex:(NSInteger)indexs{
    if ([self.shDelegate respondsToSelector:@selector(shCurrentIndex:)]) {
        [self.shDelegate shCurrentIndex:indexs];
    }
     [self.sh_labPage removeFromSuperview];
}
#pragma mark _______ lazy loading
-(UIPageControl *)sh_labPage{
    if (!_sh_labPage) {
        _sh_labPage = [[UIPageControl alloc]initWithFrame:CGRectMake(0, Screen_Height-50, Screen_Width, 50)];
        _sh_labPage.hidesForSinglePage=YES;
    }
    return _sh_labPage;
}
@end
