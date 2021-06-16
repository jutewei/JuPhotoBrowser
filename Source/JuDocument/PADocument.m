//
//  PADocument.m
//  TestImage
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/5/26.
//

#import "PADocument.h"
#import "PADocumentPickerVC.h"

@implementation PADocument
//RCT_EXPORT_MODULE(PADocument)
//
//// base64图片添加水印
//RCT_REMAP_METHOD(openDocument,
//                resolve:(RCTPromiseResolveBlock)resolve
//                reject:(RCTPromiseRejectBlock)reject) {
//    self.resolveBlock = resolve;
//    self.rejectBlock = reject;
//    [self dealImage:info];
//}

-(void)openDocument{
    [PADocumentPickerVC initDocumentPickHandle:^(NSData * _Nullable data) {
        
    }];
}
@end
