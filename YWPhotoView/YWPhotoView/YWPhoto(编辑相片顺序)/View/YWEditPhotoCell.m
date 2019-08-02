//
//  YWEditPhotoCell.m
//  Chinese
//
//  Created by yellow on 2019/5/11.
//  Copyright © 2019 YSLC. All rights reserved.
//

#import "YWEditPhotoCell.h"


@interface YWEditPhotoCell ()

//@property(nonatomic,weak)UILongPressGestureRecognizer *longPressRecognizer;
//
//@property(nonatomic,weak)UITapGestureRecognizer *tapRecognizer;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

- (IBAction)deleteClick:(UIButton *)sender;

@end

@implementation YWEditPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.layer.cornerRadius = 5;
    self.imageView.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPress.minimumPressDuration = 0.2;
    [self addGestureRecognizer:longPress];
}

-(void)setStatus:(YWEditImageStatus *)status{
    
    _status = status;
    
    //分为本地和URL的显示
    if (status.isLocal) {
        
        self.imageView.image = status.image;
    }
    else{
        
#warning - 网络下载的图片
//        NSString *imageURL = [NSString stringWithFormat:@"%@%@",domainImageURL,status.urlString];
//
//
//         [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@""]];
        
        //要保存，因为万一第一个图片不是本地的，也要拿图片给极光
        status.image = self.imageView.image;
    }
   
    
    if (status.isEdit) {
        
        self.deleteBtn.hidden = NO;
        self.layer.borderColor = otherMainColor.CGColor;
        self.layer.borderWidth = 0.5;

    }
    else{
        
        self.deleteBtn.hidden = YES;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = 0;

        
    }
    
}

//长按进入编辑状态
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(editPhotoCell:didLongPressWithStatus:)]) {
        [self.delegate editPhotoCell:self didLongPressWithStatus:self.status];
    }
}


//删除图片
- (IBAction)deleteClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(editPhotoCell:didDeleteImageWithStatus:)]) {
        [self.delegate editPhotoCell:self didDeleteImageWithStatus:self.status];
    }
}







@end
