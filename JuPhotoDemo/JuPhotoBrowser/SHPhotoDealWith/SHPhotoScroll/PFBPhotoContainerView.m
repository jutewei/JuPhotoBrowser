//
//  PFBPreviewScrollView.m
//  PFBDoctor
//
//  Created by Juvid on 16/7/21.
//  Copyright © 2016年 Juvid. All rights reserved.
//

#import "PFBPhotoContainerView.h"
#import "UIView+Frame.h"
#import "SHItemPhotoView.h"
@interface PFBPhotoContainerView ()<ImgScrollViewDelegate>{
//    int sh_allShowPage;
}
@end

@implementation PFBPhotoContainerView
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
         CGFloat screen_Width =  [[UIScreen mainScreen] bounds].size.width;    //屏幕宽
        self.frame         = CGRectMake(0, 0, screen_Width, Screen_Height);
        self.sizeW         += 20;
        self.backgroundColor=[UIColor blackColor];
        self.showsVerticalScrollIndicator=NO;
        self.showsHorizontalScrollIndicator=NO;
        self.delegate      = self;
        self.pagingEnabled = YES;
    }
    return self;
}
+(instancetype)initView:(UIView *)view{
    PFBPhotoContainerView *scrllView=[[[self class] alloc]init];
    [view addSubview:scrllView];
    return scrllView;
}
+(instancetype)initView:(UIView *)view withDelegate:(id<PFBScrollViewDelegate>)delegate{
    PFBPhotoContainerView *scrollView=[[self class] initView:view];
    scrollView.shDelegate=delegate;
    return scrollView;
}
-(void)shSetImages:(NSArray *)arrImgs currentIndex:(NSInteger)indexs {
    sh_currentIndex=indexs;
    sh_ArrGroupImgs=arrImgs;
    [self setContentSize:CGSizeMake(self.sizeW*sh_ArrGroupImgs.count, self.sizeH)];
    self.contentOffset  = CGPointMake(indexs*self.sizeW, 0);
    [self showImageScrollView:indexs];
   

}
- (void)showImageScrollView:(NSInteger)index{
    for (int i=0; i<sh_ArrGroupImgs.count; i++) {
        SHItemPhotoView *tmpImgScrollView =[self shSetPhotoIndex:i];
        tmpImgScrollView.tag=10+i;
        if (index==i) {
            [tmpImgScrollView shSetImage:sh_ArrGroupImgs[i]];
        }
    }
}
//初始化照片容器
-(SHItemPhotoView *)shSetPhotoIndex:(NSInteger)index{
    SHItemPhotoView *tmpImgScrollView = [[SHItemPhotoView alloc] initWithFrame:CGRectMake(index*self.sizeW, 0, Screen_Width, Screen_Height)];
    tmpImgScrollView.tag=index+100;
    tmpImgScrollView.i_delegate = self;
    [self addSubview:tmpImgScrollView];
    return tmpImgScrollView;
}

-(void)shTapHideBar{
    if ([self.shDelegate respondsToSelector:@selector(shTapHideBar)]) {
        [self.shDelegate shTapHideBar];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGRect contentSet=CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y, CGRectGetWidth(scrollView.bounds), CGRectGetHeight(scrollView.bounds));
    [scrollView.subviews enumerateObjectsUsingBlock:^(__kindof SHItemPhotoView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIScrollView class]]){
            if (!CGRectIntersectsRect(contentSet, obj.frame)) {
                [obj setZoomScale:1.0];
                if (obj.isSetImage) {///< 未显示的图片释放内存
                   [obj shSetImage:nil];
                }
            }
//            NSLog(@"图片 %@",obj.imgView.image);
        }
    }];
    if ([self.shDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.shDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

/**图片处理最多只加载两张到内存**/
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat currentPage=scrollView.contentOffset.x/scrollView.frame.size.width;
    int allShowPage=currentPage>0?currentPage+2:currentPage+1;
    for (int i=currentPage; i<MIN(allShowPage, sh_ArrGroupImgs.count); i++) {
        SHItemPhotoView *obj=[self viewWithTag:i+10];
        if (!obj.isSetImage) {///< 显示的当前图片
            [obj shSetImage:sh_ArrGroupImgs[i]];
        }
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
