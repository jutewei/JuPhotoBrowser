//
//  JuPhotoAlert.h
//  TestImage
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/4/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JuPhotoConfig.h"
//typedef void(^__nullable JuImageHandle)(id  _Nullable image);             //下步操作后有跟新数据

NS_ASSUME_NONNULL_BEGIN

@interface JuPhotoAlert : NSObject
+(UIAlertController *)juAlertTitle:(NSString *)title
                           message:(NSString *)message;

+(UIAlertController *)juSheetControll:(NSString *_Nullable)title
                          actionItems:(NSArray *)items
                              handler:(void (^)(UIAlertAction *action))handle;

+(UIAlertController *)juAlertControllTitle:(NSString *_Nullable)title
                                     message:(NSString *_Nullable)message
                                 actionItems:(NSArray *)items
                              preferredStyle:(UIAlertControllerStyle)preferredStyle
                                    withVC:(UIViewController *_Nullable)vc
                                   handler:( void (^_Nullable)(UIAlertAction *action))handle;

+(UIViewController *)topViewControll;
@end

NS_ASSUME_NONNULL_END
