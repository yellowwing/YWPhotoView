//
//  YWEditAddCell.m
//  Chinese
//
//  Created by yellow on 2019/5/14.
//  Copyright © 2019 YSLC. All rights reserved.
//

#import "YWEditAddCell.h"
@interface YWEditAddCell ()

@end
@implementation YWEditAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.layer.cornerRadius = 5;
    self.imageView.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

-(void)setStatus:(YWEditAddStatus *)status{
    
    _status = status;
    
    
    
    
}

@end
