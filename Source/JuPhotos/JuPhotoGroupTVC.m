//
//  JuPhotoGroupViewController.m
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/21.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPhotoGroupTVC.h"
#import <Photos/Photos.h>
#import "JuLayoutFrame.h"
#import "JuPhotoGroupCell.h"
#import "JuPhotoCollectionVC.h"
#import "JUAssetManage.h"
#import "JUProgresswHUD.h"
//#import "UIViewController+Hud.h"
@interface JuPhotoGroupTVC ()<JuPhotoDelegate,PHPhotoLibraryChangeObserver>{
    UITableView *ju_tableView;
    NSArray *ju_ArrList;
    dispatch_queue_t ju_photoQueue;
}
@end

@implementation JuPhotoGroupTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    self.title=@"相册";
    ju_photoQueue=dispatch_queue_create("com.juvid.photo", DISPATCH_QUEUE_SERIAL);
    [self juSetTable];
    [self juAlbumsAuth];
    // Do any additional setup after loading the view.
}
+(id)initWithDelegate:(id<JuPhotoDelegate>)delegate{
    return [self initWithDelegate:delegate maxSelectNum:0];
}
-(instancetype)initWitDelegate:(id<JuPhotoDelegate>)delegate maxSelectNum:(NSInteger)maxNum{
    self=[super init];
    if (self) {
        self.ju_maxNumSelection=maxNum;
        self.juDelegate=delegate;
    }
    return self;
}

+(id)initWithDelegate:(id<JuPhotoDelegate>)delegate maxSelectNum:(NSInteger)maxNum{
    JuPhotoGroupTVC *vc=[[JuPhotoGroupTVC alloc]initWitDelegate:delegate maxSelectNum:maxNum];
    return vc;
}

//相册变化回调
- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    [self juGetAllAuth:^{
        
    }];
}

-(void)juSetTable{
    ju_tableView=[[UITableView alloc]init];
    [self.view addSubview:ju_tableView];
    ju_tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    ju_tableView.juFrame(CGRectMake(0, 0, 0, 0));
    ju_tableView.delegate=self;
    ju_tableView.dataSource=self;
    ju_tableView.rowHeight=70;
    [ju_tableView registerClass:[JuPhotoGroupCell class] forCellReuseIdentifier:@"JuPhotoGroupCell"];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(juCancel:)];
    [self.navigationItem setLeftBarButtonItem:cancelButton animated:NO];
//    self.navigationItem.r=nil;
}

-(void)juCancel:(id)sender{
    [self juPhotosDidCancelController:self];
}

//获取所有相册
-(void)juAlbumsAuth{
    [[[JUProgresswHUD alloc] initWithView:self.view] juShowLoadText:@"请稍后……"];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
            [self juGetAllAuth:^{
                [JUProgresswHUD hideAllHUDsForView:self.view];
            }];
        }
    }];
}

-(void)juGetAllAuth:(dispatch_block_t)block{
    dispatch_async(ju_photoQueue, ^{
        self->ju_ArrList=[JUAssetManage juFetchPhotoAlbums];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->ju_tableView reloadData];
            if (block) {
                block();
            }
        });
    });
}
- (void)juPhotosDidCancelController:(UIViewController *)pickerController{
    if ([self.juDelegate respondsToSelector:@selector(juPhotosDidCancelController:)]) {
        [self.juDelegate juPhotosDidCancelController:self];
    }
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIViewController *popVc = nil;
        for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
            UIViewController *vc = self.navigationController.viewControllers[i];
            if ([NSStringFromClass([vc class]) isEqualToString:@"JuPhotoGroupViewController"]) {
                [self.navigationController popToViewController:popVc animated:true];
                return;
            }
            popVc=vc;
        }
    }
}

- (void)juPhotosDidFinishController:(UIViewController *)pickerController didSelectAssets:(NSArray *)arrList isPreview:(BOOL)ispreview{
    if ([self.juDelegate respondsToSelector:@selector(juPhotosDidFinishController:didSelectAssets:isPreview:)]) {
        [self.juDelegate juPhotosDidFinishController:self didSelectAssets:arrList isPreview:ispreview];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ju_ArrList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JuPhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JuPhotoGroupCell" forIndexPath:indexPath];
    cell.ju_PhotoGroup=ju_ArrList[indexPath.row];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JuPhotoCollectionVC *vc=[[JuPhotoCollectionVC alloc]init];
    vc.ju_PhotoGroup=ju_ArrList[indexPath.row];
    vc.juDelegate=self;
    vc.ju_maxNumSelection=_ju_maxNumSelection;
    [self.navigationController pushViewController:vc animated:YES];
}


/***==============未使用=================***/
//是否在iCloud
-(BOOL)isExist:(PHAsset *)asset{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = NO;
    option.synchronous = YES;
    __block BOOL isInLocalAblum = YES;
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        isInLocalAblum = imageData ? YES : NO;
    }];
    return isInLocalAblum;
}
/*
#pragma mark - 获取相册内所有照片资源
- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending{
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];

    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];

    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];

    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
//        NSLog(@"照片名%@", [asset valueForKey:@"filename"]);
        [assets addObject:asset];
    }];

    return assets;
}*/
/***===============================***/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self.juDelegate respondsToSelector:@selector(juDidReceiveMemoryWarning)]&&!self.view.window) {
        [self.juDelegate juDidReceiveMemoryWarning];
    }
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [PHPhotoLibrary.sharedPhotoLibrary unregisterChangeObserver:self];
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
