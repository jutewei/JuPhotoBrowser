//
//  JuPhotoConfig.h
//  Pods
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/6/15.
//

#ifndef JuPhotoConfig_h
#define JuPhotoConfig_h

typedef void(^__nullable JuImageHandle)(id  _Nullable image);             //下步操作后有跟新数据

#define juPhotoBundle(value) [NSString stringWithFormat:@"JuPhotoResource.bundle/%@",value]
#endif /* JuPhotoConfig_h */
