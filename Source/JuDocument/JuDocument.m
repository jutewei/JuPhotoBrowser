//
//  PADocument.m
//  JuPhotoBrowser
//
//  Copyright © 2019 Juvid. All rights reserved.
//

#import "JuDocument.h"
#import "JuDocumentPickerVC.h"

@implementation JuDocument
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
    [JuDocumentPickerVC initDocumentPickHandle:^(NSData * _Nullable data) {
        
    }];
}
@end
