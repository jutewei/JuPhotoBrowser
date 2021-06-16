//
//  PreviewPhotoVC.h
//  SHPatient
//
//  Created by Juvid on 15/11/4.
//  Copyright © 2015年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PreviewPhotoDelegate ;
@interface SHPhotoAlbumPreViewVC : UIViewController<UIScrollViewDelegate>{
  
    NSMutableArray *sh_MArrSelectImg;
    int currentNum;
    UIButton *sh_BtnRight;
}
@property (nonatomic, assign) id<PreviewPhotoDelegate>delegate;
@property BOOL isUnLoad;
@property BOOL isPreviewCurrent;///< 相册选择直接预览
-(void)shSetAllData:(id)arrImgs index:(NSInteger)indexs;
@property(nonatomic,strong) NSMutableArray *sh_ImageItems;     //选中的图片数组
@end
@protocol PreviewPhotoDelegate <NSObject>
/**完成选择照片*/
-(void)shFinishSelectImage:(NSArray *)imgItems;

@end