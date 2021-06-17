//
//  MTHUDLoadView.h
//  MTSkinPublic
//
//  Created by Juvid on 2019/6/20.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    JUProgresswHUDModelLoging,  ///< 提示文本加动态图片
    JUProgresswHUDModelFinish,  ///< 提示文本加静态图片
    JUProgresswHUDModelText,    ///< 只有提示文本
} JUProgresswHUDModel;

NS_ASSUME_NONNULL_BEGIN

@interface JUProgresswHUD : UIView

@property (nonatomic,copy)NSString *labelText;

+(instancetype)showWithWindow;

-(instancetype)initWithView:(UIView *)view;

-(void)juShowHintText:(NSString *)text;

-(void)juShowLoadText:(NSString *)text;

-(void)juShowLoadText:(NSString *)text imageName:(NSString *)imageName;

-(void)juShowSuccessText:(NSString *)text imageName:(NSString *)imageName;


-(void)hiddenAfterDelay:(NSTimeInterval)delay;

-(void)hudHidden;

+ (NSUInteger)hideAllHUDsForWindow;

+ (NSUInteger)hideAllHUDsForView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
