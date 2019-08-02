//
//  YWEditImageStatus.h
//  Chinese
//
//  Created by yellow on 2019/5/11.
//  Copyright © 2019 YSLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWEditImageStatus : NSObject

 

//是否正在编辑状态
@property(nonatomic,assign)BOOL isEdit;


//url
@property(nonatomic,copy)NSString* urlString;

//本地image
@property(nonatomic,strong)UIImage* image;

//是不是本地图片
@property(nonatomic,assign)BOOL isLocal;

@end

NS_ASSUME_NONNULL_END
