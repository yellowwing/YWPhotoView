//
//  YWEditAddCell.h
//  Chinese
//
//  Created by yellow on 2019/5/14.
//  Copyright © 2019 YSLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YWEditAddStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface YWEditAddCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property(nonatomic,strong)YWEditAddStatus *status;
@end

NS_ASSUME_NONNULL_END
