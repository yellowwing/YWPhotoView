//
//  YWPhotoView2.h
//  Chinese
//
//  Created by yellow on 2019/5/11.
//  Copyright © 2019 YSLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWEditImageStatus.h"
NS_ASSUME_NONNULL_BEGIN

@class YWPhotoView2;

@protocol YWPhotoView2Delegate <NSObject>

@optional

-(void)photoView:(YWPhotoView2 *)photoView addPhotoWithImageArray:(NSMutableArray *)imgArray; //添加图片

-(void)photoView:(YWPhotoView2 *)photoView deletePhotoWithImageArray:(NSMutableArray *)imgArray andImageStatus:(YWEditImageStatus*)imageStatus; //删除图片


-(void)photoView:(YWPhotoView2 *)photoView changePhotoWithImageArray:(NSMutableArray *)imgArray andImageStatus:(YWEditImageStatus*)imageStatus; //更换图片

@end
@interface YWPhotoView2 : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (strong, nonatomic)NSMutableArray *imgArray; //这数组装的是模型，其中在这个view里面还要创建6-imgArray.count的“+”模型。总之要凑齐6个模型放在totalImageArray里面在collectionView显示6个cell

@property (assign, nonatomic) id <YWPhotoView2Delegate>delegate;

@end

NS_ASSUME_NONNULL_END
