//
//  JuPhotoDelegate.h
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/22.
//  Copyright © 2016年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JuPhotoDelegate <NSObject>
- (void)juPhotosDidFinishSelection:(NSArray *)arrList isPreview:(BOOL)ispreview;///< 预览
- (void)juPhotosDidCancelSelection;///< 取消
@end