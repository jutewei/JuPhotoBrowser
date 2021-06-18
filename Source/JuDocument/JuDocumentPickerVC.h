//
//  JUDocumentPickerVC.h
//  JuPhotoBrowser
//
//  Copyright © 2019 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^__nullable JuDocumentHandle)(NSData * _Nullable data);
NS_ASSUME_NONNULL_BEGIN

@interface JuDocumentPickerVC : UIDocumentPickerViewController

+(instancetype)initDocumentPickHandle:(JuDocumentHandle)handle;

+(instancetype)initDocumentPickWtihVC:(UIViewController *)vc
                                handle:(JuDocumentHandle)handle;

@end



@interface PAPreShareDocumentVC : NSObject<UIDocumentInteractionControllerDelegate>

@end
NS_ASSUME_NONNULL_END
