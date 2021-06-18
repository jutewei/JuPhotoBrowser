//
//  SHGetPhotos.m
//  SHBaseProject
//
//  Created by Juvid on 15/11/4.
//  Copyright © 2015年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPhotoPickers.h"
#import "UIImage+Cropping.h"
#import "UIImage+PhotoManage.h"
#import <Photos/Photos.h>
#import "JuImagePickerController.h"
#import "JuDocumentPickerVC.h"

@interface JuPhotoPickers ()<JuPhotoDelegate,UINavigationControllerDelegate>{
    NSMutableArray *ju_mArrAsset;
    JuPhotoGroupTVC *ju_photoGropVC;
}

@property(nonatomic,copy)JuImageHandle ju_imageHandle;
@property (nonatomic, weak) UIViewController * _Nullable presentController;
@property (nonatomic, assign) BOOL allowsMultipleSelection;//允许多选
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;//最多张数
@property (nonatomic,strong) NSMutableArray* _Nullable ju_Assets;
@property BOOL allowsEditing;//允许编辑

@end

@implementation JuPhotoPickers

+ (instancetype) sharedInstance{
    static JuPhotoPickers *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init{
    self=[super init];
    if (self) {
        _maximumNumberOfSelection=8;
        ju_mArrAsset=[NSMutableArray array];
    }
    return self;
}

-(void)juSelectSysPhoto:(BOOL)allowsEdit handle:(JuImageHandle)handle{
    [self juSelectSysPhoto:allowsEdit withVC:JuPhotoAlert.topViewControll handle:handle];
}

-(void)juSelectSysPhoto:(BOOL)allowsEdit withVC:(UIViewController *)vc handle:(JuImageHandle)handle{
    [self juSelectMutlePhotos:0 selectImages:nil  withVC:vc  handle:handle];
    self.allowsEditing=allowsEdit;
}

-(void)juSelectMutlePhotos:(NSInteger)maxNum selectImages:(NSMutableArray *)arrList handle:(JuImageHandle)handle{
    [self juSelectMutlePhotos:maxNum selectImages:arrList withVC:JuPhotoAlert.topViewControll handle:handle];
}

-(void)juSelectMutlePhotos:(NSInteger)maxNum selectImages:(NSMutableArray *)arrList withVC:(UIViewController *)vc handle:(JuImageHandle)handle{
    _ju_imageHandle=handle;
    self.allowsEditing=NO;
    self.isUpLoad=NO;
    self.maximumNumberOfSelection=maxNum;
    self.presentController=vc;
    self.ju_Assets=arrList;
    [self shSelectPhoto];
}
-(void)shSelectPhoto{
    if (_allowsMultipleSelection) {
        if (_maximumNumberOfSelection>0&&[self juImageCount]>=_maximumNumberOfSelection) {
            [JuPhotoAlert juAlertTitle:@"提示" message: [NSString stringWithFormat:@"最多选择%lu张照片,请先删除部分照片再重新选择！",(unsigned long)_maximumNumberOfSelection]];
            return;
        }
    }
    [JuPhotoAlert juSheetControll:nil actionItems:@[@"取消",@"拍照",@"从手机相册选择",@"文件"] handler:^(UIAlertAction *action) {
        [self shSelectAction:action.title];
    }];

}

-(void)setMaximumNumberOfSelection:(NSUInteger)maximumNumberOfSelection{
    _maximumNumberOfSelection=maximumNumberOfSelection;
    self.allowsMultipleSelection=maximumNumberOfSelection>0;
}
-(void)setJu_Assets:(NSMutableArray *)leAssets{
    [ju_mArrAsset removeAllObjects];
    if (leAssets) {
        _ju_Assets=leAssets;
    }else{
        _ju_Assets =[NSMutableArray array];
    }
}

#pragma mark 选择照片方式
-(void)shSelectAction:(NSString *)buttonTitle{
    
    if ([buttonTitle isEqual:@"取消"]) {
        return;
    }
    if([buttonTitle isEqual:@"文件"]){
        JuDocumentPickerVC *vc=[JuDocumentPickerVC initDocumentPickHandle:^(NSData * _Nullable data) {
            
        }];
        [self juPresentViewController:vc];
        return;
    }
    
    BOOL isLibrary=[buttonTitle isEqual:@"从手机相册选择"];
    
    if (isLibrary&&_allowsMultipleSelection) {
        if ([JuImagePickerController isPhotoLibraryAvailable]){
            if (!ju_photoGropVC) {
                ju_photoGropVC=[JuPhotoGroupTVC initWithDelegate:self];
            }
            ju_photoGropVC.ju_maxNumSelection=_maximumNumberOfSelection-[self juImageCount];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:ju_photoGropVC];
            [self juPresentViewController:nav];
        }
    }
    else{
        JuImagePickerController *vc=[JuImagePickerController initImagePickType:isLibrary?UIImagePickerControllerSourceTypePhotoLibrary:UIImagePickerControllerSourceTypeCamera allowsEditing:_allowsEditing handle:^(id  _Nullable result) {
            [self juFinishImage:result];
        }];
        [self juPresentViewController:vc];
    }
}
-(void)juPresentViewController:(UIViewController *)vc{
    
    if (!vc)  return;
    
    UIViewController *supVC=self.presentController;
    vc.modalPresentationStyle=UIModalPresentationFullScreen;
    dispatch_async(dispatch_get_main_queue(), ^{
        [supVC presentViewController:vc animated:YES completion:nil];
    });
}

#pragma mark PreviewDelegate 完成预览
-(void)juFinishSelectImage:(id)arrImg{
    NSMutableArray *arrResult=[NSMutableArray array];
    [arrResult addObjectsFromArray:_ju_Assets];
    [arrResult addObjectsFromArray:arrImg];
    [self juFinishImage:arrResult];
}

-(void)juFinishImage:(id)images{
    if (self.ju_imageHandle) {
        self.ju_imageHandle(images);
        self.ju_imageHandle = nil;
    }
}

-(NSInteger)juImageCount{
    return ju_mArrAsset.count+_ju_Assets.count;
}

- (void)juPhotosDidCancelController:(UIViewController *)pickerController {
    
}

- (void)juPhotosDidFinishController:(UIViewController *)pickerController didSelectAssets:(NSArray *)arrList isPreview:(BOOL)ispreview {
    if(!ispreview){
        [self juFinishSelectImage:arrList];
        [pickerController dismissViewControllerAnimated:YES completion:nil];
    }else {
        __weak typeof(self)    weakSelf = self;
        JuAlbumPreviewVC *vc=[[JuAlbumPreviewVC alloc]init];
        [vc juSetImages:arrList currentIndex:0 finish:^(NSArray *arrList) {
            [weakSelf juFinishSelectImage:arrList];
        }];
        [pickerController.navigationController pushViewController:vc animated:YES];
    }
}

-(void)juDidReceiveMemoryWarning{
    ju_photoGropVC=nil;
}
@end
