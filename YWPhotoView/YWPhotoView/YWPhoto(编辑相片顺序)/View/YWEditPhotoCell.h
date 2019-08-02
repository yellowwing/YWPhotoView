//
//  YWEditPhotoCell.h
//  Chinese
//
//  Created by yellow on 2019/5/11.
//  Copyright © 2019 YSLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YWEditImageStatus.h"

NS_ASSUME_NONNULL_BEGIN
@class YWEditPhotoCell;

@protocol YWEditPhotoCellDelegate <NSObject>

@optional

-(void)editPhotoCell:(YWEditPhotoCell *)editPhotoCell didLongPressWithStatus:(YWEditImageStatus *)imageStatus; //进入编辑状态

-(void)editPhotoCell:(YWEditPhotoCell *)editPhotoCell didTapWithStatus:(YWEditImageStatus *)imageStatus; //取消编辑状态

-(void)editPhotoCell:(YWEditPhotoCell *)editPhotoCell didDeleteImageWithStatus:(YWEditImageStatus *)imageStatus; //取消编辑状态

@end
@interface YWEditPhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property(nonatomic,strong)YWEditImageStatus *status;

@property (assign, nonatomic) id <YWEditPhotoCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
