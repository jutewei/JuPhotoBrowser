//
//  ImgScrollView.m
//  mbstore
//
//  Created by Juvid on 14-4-28.
//  Copyright (c) 2014年 huangyi. All rights reserved.
//

#import "SHItemPhotoView.h"
#import "UIImageView+ModCache.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface SHItemPhotoView()<UIScrollViewDelegate>
{
    //记录自己的位置
    CGRect scaleOriginRect;
    
    //图片的大小
    CGSize imgSize;
    
    //缩放前大小
    CGRect initRect;
}
@property (nonatomic,strong)MBProgressHUD *sh_ProgressHud;
@end

@implementation SHItemPhotoView
@synthesize imgView;
- (void)dealloc
{
    if (imgView) {
        [imgView removeObserver:self forKeyPath:@"image"];
    }
    _i_delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        self.bouncesZoom                    = YES;
//        self.zoomBouncing=YES;
        self.backgroundColor                = [UIColor clearColor];
        self.delegate                       = self;
        self.minimumZoomScale               = 1.0;
        self.maximumZoomScale               =   3.0;

        [self shSetImageView];

        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doDoubleTap:)];
        doubleTap.numberOfTapsRequired    = 2;
        doubleTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:doubleTap];
        
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ButtonBack:)];
        gesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:gesture];
        [gesture requireGestureRecognizerToFail:doubleTap];

    }
    return self;
}
-(void)shSetImageView{
    imgView               = [[UIImageView alloc] init];
    imgView.clipsToBounds = YES;
    imgView.contentMode   = UIViewContentModeScaleAspectFit;
    imgView.tag=918;
    [self addSubview:imgView];
    [imgView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];

//    UIActivityIndicatorView *activityV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activityV.hidesWhenStopped = YES;
//    activityV.tag              = 112;
//    [activityV startAnimating];
//    activityV.center           = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
//    [self addSubview:activityV];
}
-(void)shCleanImageView{
    _isSetImage=NO;
    imgView.image=nil;
//    if (imgView) {
//        [imgView removeObserver:self forKeyPath:@"image"];
//    }
//    imgView=nil;
}
-(void)ButtonBack:(id)sender{
    [self shHidePhoto];
}
-(void)shHidePhoto{
    if ([self.i_delegate respondsToSelector:@selector(shCurrentIndex:)]) {///< 网络图片看大图
        [self.i_delegate shCurrentIndex:self.frame.origin.x/self.superview.bounds.size.width];
        [self rechangeInitRdct];

    }
    if ([self.i_delegate respondsToSelector:@selector(shTapHideBar)]) {///< 相册预览
        [self.i_delegate shTapHideBar];
    }
}


- (void) setContentWithFrame:(CGRect) rect isAnimate:(BOOL)isAnimate
{
    _isAnimate=isAnimate;
    imgView.frame = rect;
    initRect = rect;
}

- (void) setAnimationRect
{
    [UIView animateWithDuration:_isAnimate?0.3:0 animations:^{
        imgView.frame = scaleOriginRect;
    }];

}

- (void) rechangeInitRdct
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView animateWithDuration:self.zoomScale==1.0?0:0.3 animations:^{
        self.zoomScale=1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            if (_isAnimate)  imgView.frame = initRect;
            else self.superview.alpha=0.0;
        } completion:^(BOOL finished) {
            [self.superview removeFromSuperview];
        }];
    }];



}

- (void)shSetImage:(id)imageData{
    if (!imageData) {
        [self shCleanImageView];
        return;
    }
//     [self shSetImageView];
    _isSetImage=YES;
    if ([imageData isKindOfClass:[UIImage class]]) {
        imgView.image = imageData;
    }
    else if([imageData isKindOfClass:[ALAsset class]]){
        ALAsset *asset=imageData;
        imgView.image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    }
    else if([imageData isKindOfClass:[NSString class]]){
        

        WEAK_SELF
        [imgView setImageWithStr:imageData progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (!weakSelf.sh_ProgressHud) {
                weakSelf.sh_ProgressHud=[MBProgressHUD showHUDAddedTo:weakSelf animated:YES];
                weakSelf.sh_ProgressHud.color=[UIColor colorWithWhite:0.2 alpha:0.8];
                weakSelf.sh_ProgressHud.mode = MBProgressHUDModeDeterminate;
            }
            weakSelf.sh_ProgressHud.progress=(float)receivedSize/(float)expectedSize;
        }];
//        [_sh_ProgressHud show:YES];
//         [imgView setImageWithStr:imageData];
    }
}
- (void) setImage:(UIImage *) image
{
    if (image)
    {
        imgSize = image.size;
        
        //判断首先缩放的值
        float scaleX = self.frame.size.width/imgSize.width;
        float scaleY = self.frame.size.height/imgSize.height;
        
        //倍数小的，先到边缘
        
        if (scaleX > scaleY)
        {
            //Y方向先到边缘
            float imgViewWidth = imgSize.width*scaleY;
//            self.maximumZoomScale = self.frame.size.width/imgViewWidth;
            scaleOriginRect = (CGRect){self.frame.size.width/2-imgViewWidth/2,0,imgViewWidth,self.frame.size.height};
        }
        else
        {
            //X先到边缘
            float imgViewHeight = imgSize.height*scaleX;
//            self.maximumZoomScale = self.frame.size.height/imgViewHeight;
            scaleOriginRect = (CGRect){0,self.frame.size.height/2-imgViewHeight/2,self.frame.size.width,imgViewHeight};
        }
        [self setAnimationRect];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"image"])
    {
        if (imgView.image) {
//            UIActivityIndicatorView *act=(id)[self viewWithTag:112];
//            if (act) {
//                [act stopAnimating];
//                [act removeFromSuperview];
//
//            }
            if(_sh_ProgressHud){
                [_sh_ProgressHud hide:YES];
                _sh_ProgressHud=nil;
            }
            [self setImage:imgView.image];
        }

    }
}
-(void)doDoubleTap:(UIGestureRecognizer *)sender{
    UIScrollView *scr=(UIScrollView *)sender.view;
    float newScale=0 ;
    if (scr.zoomScale>1.0) {
        [scr setZoomScale:1.0 animated:YES];
    }
    else{
        
        newScale=scr.zoomScale * 3.0;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[sender locationInView:sender.view]];
        //        [scr setZoomScale:zoomRect animated:YES];
        [scr zoomToRect:zoomRect animated:YES];
    }
    
}
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}
#pragma mark -
#pragma mark - scroll delegate
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = imgView.frame;
    CGSize contentSize = scrollView.contentSize;
    
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    // center horizontally
    if (imgFrame.size.width <= boundsSize.width)
    {
        centerPoint.x = boundsSize.width/2;
    }
    
    // center vertically
    if (imgFrame.size.height <= boundsSize.height)
    {
        centerPoint.y = boundsSize.height/2;
    }
    
    imgView.center = centerPoint;
}

#pragma mark -
#pragma mark - touch
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.i_delegate respondsToSelector:@selector(tapImageViewTappedWithObject:)])
    {
        [self.i_delegate tapImageViewTappedWithObject:self];
    }
}

@end
