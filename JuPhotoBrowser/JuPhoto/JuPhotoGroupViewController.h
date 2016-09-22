//
//  JuPhotoGroupViewController.h
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/21.
//  Copyright © 2016年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuPhotoDelegate.h"
@interface JuPhotoGroupViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) NSUInteger ju_maxNumSelection;
@property (nonatomic,weak) id<JuPhotoDelegate> juDelegate;
@end
