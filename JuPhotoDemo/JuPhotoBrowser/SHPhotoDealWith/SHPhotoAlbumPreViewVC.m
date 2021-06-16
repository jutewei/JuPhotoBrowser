//
//  PreviewPhotoVC.m
//  SHPatient
//
//  Created by Juvid on 15/11/4.
//  Copyright © 2015年 Juvid. All rights reserved.
//

#import "SHPhotoAlbumPreViewVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIView+Frame.h"
#import "SHItemPhotoView.h"
#import "PFBPhotoContainerView.h"
@interface SHPhotoAlbumPreViewVC ()<ImgScrollViewDelegate,PFBScrollViewDelegate>{
    UINavigationBar *sh_NavBar;
    NSInteger currentIndex;
    PFBPhotoContainerView *sh_Scrollview;
}

@end

@implementation SHPhotoAlbumPreViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    self.edgesForExtendedLayout=UIRectEdgeAll;
    [self shSetRightButton];
    sh_MArrSelectImg=[NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self setBaseScrollView];
    [self shLoadScroll];
//    [self shSetNarBar];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}
-(void)shSetAllData:(id)arrImgs index:(NSInteger)indexs{
    _sh_ImageItems=arrImgs;
    currentIndex=indexs;
    currentNum=(int)indexs;
}
-(void)shPressCancle:(id)sender{
    if (!_isPreviewCurrent) {
        [self.navigationController setToolbarHidden:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)shTapHideBar{
    if (self.navigationController.toolbarHidden==YES) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController setToolbarHidden: NO animated: YES];
        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }else{
        [self.navigationController setToolbarHidden: YES animated: YES];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
}
-(void)setBaseScrollView{

    UIButton  *sh_doneItem = [UIButton buttonWithType: UIButtonTypeCustom];
    sh_doneItem.frame = CGRectMake(0, 0, 40, 40);
    sh_doneItem.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [sh_doneItem setTitle:_isUnLoad?@"上传":@"完成" forState: UIControlStateNormal];
    [sh_doneItem setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [sh_doneItem addTarget:self action:@selector(shTouchFinish:) forControlEvents:UIControlEventTouchUpInside];
     {
        UIBarButtonItem* previewItem = [[UIBarButtonItem alloc] initWithCustomView: sh_doneItem];
        UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
        self.toolbarItems = @[spaceItem, previewItem];
    }
}
//导航栏右边按钮
-(void)shSetRightButton{
    UIButton *btnBack=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    [btnBack setImage:[UIImage imageNamed:@"OK"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"No"] forState:UIControlStateSelected];
    [btnBack addTarget:self action:@selector(shRightReturn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
    self.navigationItem.rightBarButtonItem=backItem;
    sh_BtnRight=btnBack;
}
-(void)shLoadScroll{
    sh_Scrollview=[PFBPhotoContainerView initView:self.view withDelegate:self];
    [sh_Scrollview shSetImages:_sh_ImageItems currentIndex:currentIndex];
    for (int i=0; i<_sh_ImageItems.count; i++) {
        [sh_MArrSelectImg addObject:@"1"];
    }
}
-(void)shRightReturn:(UIButton *)sender{
    if ([sh_MArrSelectImg[currentNum] isEqualToString:@"0"]) {
        [sh_MArrSelectImg setObject:@"1" atIndexedSubscript:currentNum];
        sh_BtnRight.selected=NO;
    }
    else{
        [sh_MArrSelectImg setObject:@"0" atIndexedSubscript:currentNum];
        sh_BtnRight.selected=YES;
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    currentNum=scrollView.contentOffset.x/Screen_Width;
    if ([sh_MArrSelectImg[currentNum] isEqualToString:@"0"]) {
        sh_BtnRight.selected=YES;
    }
    else{
         sh_BtnRight.selected=NO;
    }
}

- (void)shTouchFinish:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shFinishSelectImage:)]) {
        NSMutableArray *arr=[NSMutableArray array];
        for (int i=0;i<sh_MArrSelectImg.count;i++) {
            if ([sh_MArrSelectImg[i] isEqualToString:@"1"]) {
                [arr addObject:_sh_ImageItems[i]];
            }
        }
        [self.delegate shFinishSelectImage:arr];
    }
    [self.navigationController setToolbarHidden:YES animated: NO];
    if (!_isPreviewCurrent) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
