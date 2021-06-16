//
//  JUDocumentPickerVC.h
//  TestImage
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/5/19.
//

#import <UIKit/UIKit.h>
typedef void(^__nullable PADocumentHandle)(NSData * _Nullable data);
NS_ASSUME_NONNULL_BEGIN

@interface PADocumentPickerVC : UIDocumentPickerViewController

+(instancetype)initDocumentPickHandle:(PADocumentHandle)handle;

+(instancetype)initDocumentPickWtihVC:(UIViewController *)vc
                                handle:(PADocumentHandle)handle;

@end



@interface PAPreShareDocumentVC : NSObject<UIDocumentInteractionControllerDelegate>

@end
NS_ASSUME_NONNULL_END
