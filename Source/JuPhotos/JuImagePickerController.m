//
//  JuSystemPictureVC.m
//  TestImage
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/4/26.
//

#import "JuImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import "JuPhotoAlert.h"
@interface JuImagePickerController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
     BOOL allowsEditing;//允许编辑
}
@property(nonatomic,copy)JuImageHandle ju_handle;
@end

@implementation JuImagePickerController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//}
-(instancetype)initImagePickType:(UIImagePickerControllerSourceType )sourceType allowsEditing:(BOOL)allowsEditing handle:(JuImageHandle)handle{
    self=[super init];
    if (self) {
        self.delegate = self;
        self.sourceType = sourceType;
        self.mediaTypes = [[NSArray alloc]
                                 initWithObjects:( NSString *)kUTTypeImage, nil];
        self.allowsEditing = allowsEditing;
        self.modalPresentationStyle=UIModalPresentationFullScreen;
        self.ju_handle = handle;
        //    if (sourceType==UIImagePickerControllerSourceTypeCamera) {
        //        controller.videoQuality = UIImagePickerControllerQualityTypeLow;
        //    }
    }
    return self;
}
+(instancetype)initImagePickType:(UIImagePickerControllerSourceType )sourceType allowsEditing:(BOOL)allowsEditing handle:(JuImageHandle)handle{
    if (sourceType==UIImagePickerControllerSourceTypeCamera) {
        if (![self isCameraAvailable]){
            return nil;
        }
    }else{
        if (![self isPhotoLibraryAvailable]) {
            return nil;
        }
    }
    return [[JuImagePickerController alloc]initImagePickType:sourceType allowsEditing:allowsEditing handle:handle];
}
//拍照
+ (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]&&[self doesCameraSupportTakingPhotos];
}

+ (BOOL) doesCameraSupportTakingPhotos{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage
                          sourceType:UIImagePickerControllerSourceTypeCamera];
}
//照片库
+ (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]&&[self canUserPickPhotosFromPhotoLibrary];
}

+ (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self cameraSupportsMedia:(NSString *)kUTTypeImage
                          sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

//判断是否支持多媒体
+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType
                  sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    
    __block BOOL result = NO;
    if ([paramMediaType length] == 0){
        [JuPhotoAlert juAlertTitle:@"警告" message:@ "没有可用媒体" ];
        return NO;
    }
    if (paramSourceType==UIImagePickerControllerSourceTypePhotoLibrary) {
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        if (authStatus ==PHAuthorizationStatusDenied || authStatus==PHAuthorizationStatusRestricted) {
            [JuPhotoAlert juAlertTitle:@"无法使用iPhone相册" message:@"请在iPhone的“设置-隐私-照片”中允许访问相册"];
            return NO;
        }
    }
    else{
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus ==AVAuthorizationStatusDenied || authStatus==AVAuthorizationStatusRestricted){
            [JuPhotoAlert juAlertTitle:@"无法使用iPhone相机" message:@"请在iPhone的“设置-隐私-相机”中允许访问相机"];
            return NO;
        }
    }
    //判断iOS7的宏，没有就自己写个，下边的方法是iOS7新加的，7以下调用会报错
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         NSString *mediaType = (NSString *)obj;
         if ([mediaType isEqualToString:paramMediaType]){
             result = YES;
             *stop= YES;
         }
     }];
    return result;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString  *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(__bridge NSString *)kUTTypeImage]){
        UIImage *resultImage=nil;
        if ([picker allowsEditing]){
            resultImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            resultImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {//拍照存图片
            UIImageWriteToSavedPhotosAlbum(resultImage, self,NULL, NULL);
        }
        if (self.ju_handle) {
            self.ju_handle(resultImage);
        }
//       [self fbFinishImage:theImage];
    }
}

#pragma mark UIImagePickerControllerDelegate methods
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([UIDevice currentDevice].systemVersion.floatValue < 11){
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")])
    {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             // iOS 11之后，图片编辑界面最上层会出现一个宽度<42的view，会遮盖住左下方的cancel按钮，使cancel按钮很难被点击到，故改变该view的层级结构
             if (obj.frame.size.width < 42)
             {
                 [viewController.view sendSubviewToBack:obj];
                 *stop = YES;
             }
         }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
