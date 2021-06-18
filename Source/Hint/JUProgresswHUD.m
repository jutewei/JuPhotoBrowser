//
//  MTHUDLoadView.m
//  JuPhotoBrowser
//
//  Created by Juvid on 2019/6/20.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import "JUProgresswHUD.h"

//#import "NSString+Format.h"
#define MT_Window_Height       [[UIScreen mainScreen] bounds].size.height
#define MT_Window_Width        [[UIScreen mainScreen] bounds].size.width
@interface JUProgresswHUD ()

@property (assign) JUProgresswHUDModel mode;
@property (nonatomic,copy)NSString *mt_imageName;

@end

@implementation JUProgresswHUD{
    UIView *mt_vieBackGround;
    UIImageView *mt_imgLoadStatus;
    UILabel *mt_labDesc;
    UIVisualEffectView *mt_effectView;
    UIActivityIndicatorView *ju_activityView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];

        mt_vieBackGround=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
        mt_vieBackGround.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
        [self addSubview:mt_vieBackGround];
        [mt_vieBackGround.layer setCornerRadius:8];
        [mt_vieBackGround.layer setMasksToBounds:YES];
        mt_vieBackGround.center=self.center;

        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        //  毛玻璃视图
        mt_effectView= [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //添加到要有毛玻璃特效的控件中
        mt_effectView.frame = mt_vieBackGround.bounds;
        [mt_vieBackGround addSubview:mt_effectView];
        //设置模糊透明度
        mt_effectView.alpha = 0.5;

        mt_imgLoadStatus=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
        [mt_vieBackGround addSubview:mt_imgLoadStatus];
        mt_imgLoadStatus.center=mt_vieBackGround.center;
        
        ju_activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [mt_vieBackGround addSubview:ju_activityView];
        ju_activityView.frame=mt_imgLoadStatus.frame;

        mt_labDesc=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        mt_labDesc.font=[UIFont systemFontOfSize:15];
        mt_labDesc.numberOfLines=0;
        mt_labDesc.textAlignment=NSTextAlignmentCenter;
        mt_labDesc.textColor=[UIColor colorWithWhite:0 alpha:0.5];
        [mt_vieBackGround addSubview:mt_labDesc];
        self.userInteractionEnabled=NO;

        // Set default values for properties
    }
    return self;
}

-(instancetype)initWithView:(UIView *)view{
    self=[self initWithFrame:view.bounds];
    [view addSubview:self];
    return self;
}

+(instancetype)showWithWindow{
    JUProgresswHUD *hud=[[JUProgresswHUD alloc] initWithView:self.mainWindow];
//    [hud mtShowLoadText:@"请稍后..." imageName:@"loading_big".mtBundle];
    return hud;
}
+(UIWindow *)mainWindow{
    UIWindow *window;
    if (!window) {
        window=[UIApplication sharedApplication].windows.firstObject;
    }
    return window;
}

-(void)juShowLoadText:(NSString *)text {
    [self juSetHudText:text imageName:@"systemActivity" model:JUProgresswHUDModelLoging];
    
}
-(void)juShowLoadText:(NSString *)text imageName:(NSString *)imageName{
    [self juSetHudText:text imageName:imageName model:JUProgresswHUDModelLoging];
}

-(void)juShowSuccessText:(NSString *)text imageName:(NSString *)imageName{
    [self juSetHudText:text imageName:imageName model:JUProgresswHUDModelFinish];
    [self hiddenAfterDelay:2.5];
}

-(void)juShowHintText:(NSString *)text{
    [self juSetHudText:text imageName:nil model:JUProgresswHUDModelText];
    [self hiddenAfterDelay:2];
    self.userInteractionEnabled=NO;
}

-(void)juSetHudText:(NSString *)text imageName:(NSString *)imageName model:(JUProgresswHUDModel)model{
    self.mode=model;
    self.labelText=text;
    self.mt_imageName=imageName;
    [self juUpdateLayout];
//    [self showUsingAnimation:YES];
}
-(void)setLabelText:(NSString *)labelText{
    _labelText=labelText;
    if (_labelText) {
        mt_labDesc.text=labelText;
    }
    mt_labDesc.hidden=!_labelText;

}

-(void)setMt_imageName:(NSString *)mt_imageName{
    _mt_imageName=mt_imageName;
    UIImage *image=[UIImage imageNamed:mt_imageName];
    mt_imgLoadStatus.image=image;
}

-(void)juUpdateLayout{
    
    CGSize sizeBack=CGSizeMake(120, 40);
    CGSize sizeLab=CGSizeZero;
    CGSize sizeImg=CGSizeZero;
    CGRect statusframe=CGRectZero;
    if (_mt_imageName) {
        
        if ([_mt_imageName isEqual:@"systemActivity"]) {
            sizeImg=ju_activityView.frame.size;
            statusframe=CGRectMake((CGRectGetWidth(mt_vieBackGround.bounds)-sizeImg.width)/2, 20, sizeImg.width, sizeImg.height);
            ju_activityView.frame=statusframe;
            sizeBack.height=CGRectGetMaxY(statusframe)+20;
            if (_mode==JUProgresswHUDModelLoging) {
                [ju_activityView startAnimating];
            }
            
        }else{
            sizeImg=mt_imgLoadStatus.image.size;
            statusframe=CGRectMake((CGRectGetWidth(mt_vieBackGround.bounds)-sizeImg.width)/2, 20, sizeImg.width, sizeImg.height);
            mt_imgLoadStatus.frame=statusframe;
            sizeBack.height=CGRectGetMaxY(statusframe)+20;
            [mt_imgLoadStatus.layer removeAllAnimations];
            if (_mode==JUProgresswHUDModelLoging) {
                self.userInteractionEnabled=YES;
                [mt_imgLoadStatus.layer addAnimation:[self juRotationZ:1.1] forKey:@"rotationAnimation"];
            }
        }
        mt_labDesc.font=[UIFont systemFontOfSize:15];
        mt_labDesc.textColor=[UIColor colorWithWhite:0 alpha:0.5];
    }
    else{
        mt_labDesc.font=[UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        mt_labDesc.textColor=[UIColor colorWithWhite:0 alpha:0.9];
    }
    if (_labelText) {
        sizeLab=[self juBoundingRectWithSize:MT_Window_Width-60 lable:mt_labDesc];
        sizeBack.width=MAX(120, sizeLab.width+30);
        if (_mode==JUProgresswHUDModelText) {
            mt_labDesc.frame=CGRectMake((sizeBack.width-sizeLab.width)/2, 15, sizeLab.width, MIN(sizeLab.height, MT_Window_Height-60));
        }else{
            mt_labDesc.frame=CGRectMake((sizeBack.width-sizeLab.width)/2, CGRectGetMaxY(statusframe)+12, sizeLab.width, sizeLab.height);
        }
        sizeBack.height=CGRectGetMaxY(mt_labDesc.frame)+15;
    }

    CGRect frameBack=CGRectZero;
    frameBack.size=sizeBack;
    mt_vieBackGround.frame=frameBack;
    mt_vieBackGround.center=self.center;
    mt_effectView.frame = mt_vieBackGround.bounds;
}

-(void)hiddenAfterDelay:(NSTimeInterval)delay{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.30];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
        self.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(0.5f, 0.5f));
        self.alpha = 0.02f;
        [UIView commitAnimations];
    });
}

- (void)showUsingAnimation:(BOOL)animated {
    self.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(1.5f, 1.5f));
    // Fade in
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.30];
        self.alpha = 1.0f;
        self.transform = CGAffineTransformIdentity;
        [UIView commitAnimations];
    }
    else {
        self.alpha = 1.0f;
    }
}
- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context {
    [self hudHidden];
}

-(void)hudHidden{
    [self removeFromSuperview];
}

+ (NSUInteger)hideAllHUDsForWindow{
    return [self hideAllHUDsForView:[UIApplication sharedApplication].delegate.window];
}
+ (NSUInteger)hideAllHUDsForView:(UIView *)view {
    NSArray *huds = [JUProgresswHUD allHUDsForView:view];
    for (JUProgresswHUD *hud in huds) {

        [hud hiddenAfterDelay:0];
    }
    return [huds count];
}
+ (NSArray *)allHUDsForView:(UIView *)view {
    NSMutableArray *huds = [NSMutableArray array];
    NSArray *subviews = view.subviews;
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:self]) {
            [huds addObject:aView];
        }
    }
    return [NSArray arrayWithArray:huds];
}
-(void)dealloc{
    [mt_imgLoadStatus.layer removeAllAnimations];
}

-(CABasicAnimation *)juRotationZ:(CFTimeInterval)duration{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat: M_PI *2];
    animation.duration = duration;
    //    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    return animation;
}

- (CGSize)juBoundingRectWithSize:(CGFloat)width lable:(UILabel *)lable{
    NSMutableDictionary *dicStyle=[NSMutableDictionary dictionary];
    if (lable.attributedText.length>0) {
        NSRange range = NSMakeRange(0, lable.attributedText.length);
        NSDictionary *dic = [lable.attributedText attributesAtIndex:0 effectiveRange:&range];   // 获取该段
        NSMutableParagraphStyle *last=dic[NSParagraphStyleAttributeName];
        if (last) {
            NSMutableParagraphStyle *newStyle=[last mutableCopy];
            newStyle.lineBreakMode=NSLineBreakByWordWrapping;
            [dicStyle setObject:newStyle forKey:NSParagraphStyleAttributeName];
        }
    }
    [dicStyle setValue:lable.font forKey:NSFontAttributeName];

    CGSize sizeText=CGSizeMake(width, MAXFLOAT);
    CGSize retSize = [lable.text boundingRectWithSize:sizeText
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:dicStyle
                                             context:nil].size;
    return retSize;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
