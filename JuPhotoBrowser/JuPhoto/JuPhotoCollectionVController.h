//
//  JuPhotoCollectionVController.h
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/21.
//  Copyright © 2016年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "JuPhotoDelegate.h"
typedef void(^shBackWithMultiData)(id first,id second);//下步操作后有有多个数据
@interface JuPhotoCollectionVController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)  PHAssetCollection *ju_PhotoGroup;
@property (nonatomic, assign) NSUInteger ju_maxNumSelection;
@property (nonatomic,weak) id<JuPhotoDelegate> juDelegate;
@end
