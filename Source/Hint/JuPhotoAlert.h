//
//  JuPhotoAlert.h
//  JuPhotoBrowser
//
//  Copyright © 2019 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "JuPhotoConfig.h"
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
