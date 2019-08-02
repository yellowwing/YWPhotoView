//
//  YWPhotoView2.m
//  Chinese
//
//  Created by yellow on 2019/5/11.
//  Copyright © 2019 YSLC. All rights reserved.
//

#import "YWPhotoView2.h"

#import "YWEditPhotoCell.h"

#define EditPhotoCellID @"YWEditPhotoCell"

#import "YWEditPhotoLayout.h"

#import "YWEditAddCell.h"
#import "YWEditAddStatus.h"
#import "YWEditImageStatus.h"

#define EditAddCellID @"YWEditAddCell"


@interface YWPhotoView2 ()<UICollectionViewDataSource,UICollectionViewDelegate,YWEditPhotoCellDelegate>
@property(nonatomic,weak)UICollectionView *collectionView;

@property(nonatomic,strong)NSArray *totalImageArray;

//这里手势用强引用
@property(nonatomic,strong)UILongPressGestureRecognizer *longPressRecognizer;


@property(nonatomic,weak)UIImageView *panImageView;

@property(nonatomic,weak)UICollectionViewCell *lastPassCell;

@property(nonatomic,strong)NSIndexPath *beginIndexPath;

@property(nonatomic,assign)BOOL isEdit;

@property(nonatomic,assign)NSInteger lastItem;

@end

@implementation YWPhotoView2

// 5种操作：添加图片（外）☑️、删除图片（外）☑️、编辑照片（本）☑️、取消编辑照片（本）☑️、移动照片（本）☑️【5个操作两个数组都要解决】☑️



//解决collectionView手势冲突，拖拽手势变成长按手势
//此处给collectionView增加长按的拖拽手势，用此手势触发cell移动效果
//只创建一次，引用的时候假如为空才创建
-(UILongPressGestureRecognizer*)longPressRecognizer{
    if (!_longPressRecognizer) {
        _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlepanGesture:)];
        
        _longPressRecognizer.minimumPressDuration = 0.1;
    }
    return _longPressRecognizer;
}

-(NSArray*)totalImageArray{
    if (!_totalImageArray) {
        self.totalImageArray = [NSArray array];
    }
    return _totalImageArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imgArray = [NSMutableArray array];
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[[YWEditPhotoLayout alloc]init]];
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = grayMainColor;
        
        [self addSubview:collectionView];
        
        self.collectionView = collectionView;
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"YWEditPhotoCell" bundle:nil] forCellWithReuseIdentifier:EditPhotoCellID];
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"YWEditAddCell" bundle:nil] forCellWithReuseIdentifier:EditAddCellID];
        
        
    }
    return self;
    
}

#pragma mark - photoCellDelegate代理方法
//长按进入编辑
-(void)editPhotoCell:(YWEditPhotoCell *)editPhotoCell didLongPressWithStatus:(YWEditImageStatus *)imageStatus{
    
    //添加移动手势
    [self.collectionView addGestureRecognizer:self.longPressRecognizer];
    
    self.isEdit = YES;
    
    //两个数组都解决，因为photoView用到totalImageArray数据，外面控制器用到imgArray数据
    for (NSInteger i = 0; i<self.totalImageArray.count; i++) {
        id status = self.totalImageArray[i];
        if ([status isKindOfClass:[YWEditImageStatus class]]) {
            YWEditImageStatus *imageStatus = (YWEditImageStatus *)status;
            imageStatus.isEdit = YES;
        }
    }
    //添加的也有编辑和不是编辑的情况
    for (NSInteger i = 0; i<self.imgArray.count; i++) {
        YWEditImageStatus *imageStatus = self.imgArray[i];
        imageStatus.isEdit = YES;
    }
    
    [self.collectionView reloadData];
    
    
    
    
}

//不要单击手势
//单击取消编辑
//-(void)editPhotoCell:(YWEditPhotoCell *)editPhotoCell didTapWithStatus:(YWEditImageStatus *)imageStatus{
//
//    self.isEdit = NO;
//
//    //去除移动手势
//    [self.collectionView removeGestureRecognizer:self.longPressRecognizer];
//
//    //两个数组都解决
//    for (NSInteger i = 0; i<self.totalImageArray.count; i++) {
//        id status = self.totalImageArray[i];
//        if ([status isKindOfClass:[YWEditImageStatus class]]) {
//            YWEditImageStatus *imageStatus = (YWEditImageStatus *)status;
//            imageStatus.isEdit = NO;
//        }
//    }
//    //添加的也有编辑和不是编辑的情况
//    for (NSInteger i = 0; i<self.imgArray.count; i++) {
//        YWEditImageStatus *imageStatus = self.imgArray[i];
//        imageStatus.isEdit = NO;
//    }
//
//    [self.collectionView reloadData];
//
//}


//删除图片
-(void)editPhotoCell:(YWEditPhotoCell *)editPhotoCell didDeleteImageWithStatus:(YWEditImageStatus *)imageStatus{

//代理方法不用传totalImageArray,只需要传ImageArray,因为setImageArray的时候，已经会创建一个新的totalImageArray

    if ([self.delegate respondsToSelector:@selector(photoView:deletePhotoWithImageArray:andImageStatus:)]) {
        [self.delegate photoView:self deletePhotoWithImageArray:self.imgArray andImageStatus:imageStatus];
    }

}

#pragma mark - 移动图片
//长按手势拖拽排序
- (void)handlepanGesture:(UILongPressGestureRecognizer *)panGesture {
    
    //判断手势状态
    switch (panGesture.state) {
            
            //一开始拖拽
        case UIGestureRecognizerStateBegan:{
            
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[panGesture locationInView:self.collectionView]];
            
            //假如不是在indexPath范围内的，直接返回
            if (indexPath == nil) {
                break;
            }
            
            
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            
            if ([cell isKindOfClass:[YWEditAddCell class]]) {
                break;
            }
            else if ([cell isKindOfClass:[YWEditPhotoCell class]]){

                //先初始化下面三个值
                self.beginIndexPath = indexPath;
                
                self.lastItem = indexPath.item;
                
                self.lastPassCell = cell;
                
                self.lastPassCell.hidden = YES;

                YWEditPhotoCell *photoCell = (YWEditPhotoCell*)cell;

                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                [self.collectionView addSubview:imageView];
                imageView.image = photoCell.imageView.image;
                imageView.layer.cornerRadius = 5;
                imageView.clipsToBounds = YES;
                imageView.alpha = 1;
                self.panImageView = imageView;
                imageView.frame = photoCell.frame;
                [UIView animateWithDuration:0.2 animations:^{
                    
                    imageView.center = [panGesture locationInView:self.collectionView];
                    imageView.bounds = CGRectMake(0, 0, (Wi-40)/3, (Wi-40)/3);
                } ];
                
            }
            
        }
            break;
        case UIGestureRecognizerStateChanged:{
            
            //获取正在移动的位置
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[panGesture locationInView:self.collectionView]];
            
            
            self.panImageView.center = [panGesture locationInView:self.collectionView];
            
//            self.lastPassCell.layer.borderColor = otherMainColor.CGColor;
//            self.lastPassCell.layer.borderWidth = 0.5;
            
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            
            if ([cell isKindOfClass:[YWEditPhotoCell class]] && indexPath.item != self.beginIndexPath.item) {
                
//                cell.layer.borderColor = otherMainColor.CGColor;
//                cell.layer.borderWidth = 1;
//
//                self.lastPassCell = cell;
                
                
                //探探做法
            //因为状态在change，所以手指动一下就会换图片很多次，用self.lastItem来控制手指在同一个indePath里只能调用一次换顺序
                if (self.lastItem != indexPath.item) {
                    //两个数组都要改变模型
                    
                    NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.totalImageArray];
                    
                    YWEditImageStatus *imageStatus = mArray[self.beginIndexPath.item];
                    
                    [mArray removeObject:imageStatus];
                    
                    [mArray insertObject:imageStatus atIndex:indexPath.item];
                    
                    self.totalImageArray = mArray;
                    
                    
                    YWEditImageStatus *status = self.imgArray[self.beginIndexPath.item];
                    
                    [self.imgArray removeObject:status];
                    
                    [self.imgArray insertObject:status atIndex:indexPath.item];
                    
                    //样式
                    [self.collectionView moveItemAtIndexPath:self.beginIndexPath toIndexPath:indexPath];
                    
                    self.lastItem = indexPath.item;
                    
                    //换了位置之后要重新把indexPath作为新的开始beginIndexPath
                    self.beginIndexPath = indexPath;
                }
                
            }
            
        }
            break;
        case UIGestureRecognizerStateEnded:{
            
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[panGesture locationInView:self.collectionView]];
            
//            self.lastPassCell.layer.borderColor = otherMainColor.CGColor;
//            self.lastPassCell.layer.borderWidth = 0.5;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                self.panImageView.frame = self.lastPassCell.frame;
                
            } completion:^(BOOL finished) {
                
                [self.panImageView removeFromSuperview];
                
                self.lastPassCell.hidden = NO;
                
//                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//
//                if ([cell isKindOfClass:[YWEditPhotoCell class]] ) {
//
//                    //两个数组都要改变模型
//
//                    NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.totalImageArray];
//
//                    YWEditImageStatus *imageStatus = mArray[self.beginIndexPath.item];
//
//                    [mArray removeObject:imageStatus];
//
//                    [mArray insertObject:imageStatus atIndex:indexPath.item];
//
//                    self.totalImageArray = mArray;
//
//
//                    YWEditImageStatus *status = self.imgArray[self.beginIndexPath.item];
//
//                    [self.imgArray removeObject:status];
//
//                    [self.imgArray insertObject:status atIndex:indexPath.item];
//
//                    //样式
//                    [self.collectionView moveItemAtIndexPath:self.beginIndexPath toIndexPath:indexPath];
//
//
//
//                }
                
            }];
            
            
            
        }
            
            
            break;
        default:
            
            break;
    }
}




-(void)setImgArray:(NSMutableArray *)imgArray{
    
    _imgArray = imgArray;
    
    //添加的也有编辑和不是编辑的情况
    for (NSInteger i = 0; i<self.imgArray.count; i++) {
        YWEditImageStatus *imageStatus = self.imgArray[i];
       imageStatus.isEdit = self.isEdit;
    }
    
    //imgArray的模型再加6-imgArray.count个“+”模型放在totalImageArray里面
    //控制totalImageArray刚刚好总共有6个模型
    
    NSInteger imgCount = imgArray.count;
    
    if (imgCount >= 6) { //1. 大于等于6个，取前6个
        
        self.totalImageArray = [imgArray subarrayWithRange:NSMakeRange(0, 6)];
    }
    else{  //2. 小于6个，创建6-imgArray.count个editAddStatus模型，补齐6个
        
        NSMutableArray *mArray = [NSMutableArray array];
        
        //先添加图片模型的
        [mArray addObjectsFromArray:imgArray];
        
        NSInteger remaimCount = 6 - imgCount;
        
        for (NSInteger i = 0; i < remaimCount; i++) {
            
            YWEditAddStatus *addStatus = [[YWEditAddStatus alloc] init];
            
            [mArray addObject:addStatus];
            
        }
        
        self.totalImageArray = mArray;
        
    }
    
    
    [self.collectionView reloadData];
}




-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    id status = self.totalImageArray[indexPath.item];
    
    if ([status isKindOfClass:[YWEditAddStatus class]]) {
        
        //代理叫控制器打开相册添加照片
        if ([self.delegate respondsToSelector:@selector(photoView:addPhotoWithImageArray:)]) {
            [self.delegate photoView:self addPhotoWithImageArray:self.imgArray];
        }
        
    }
    else if ([status isKindOfClass:[YWEditImageStatus class]]) {
        
        if (self.isEdit) {  //编辑状态下
         //代理方法不用传totalImageArray,只需要传ImageArray,因为setImageArray的时候，已经会创建一个新的totalImageArray
            
            self.isEdit = NO;
            
            //去除移动手势
            [self.collectionView removeGestureRecognizer:self.longPressRecognizer];
            
            //两个数组都解决
            for (NSInteger i = 0; i<self.totalImageArray.count; i++) {
                id status = self.totalImageArray[i];
                if ([status isKindOfClass:[YWEditImageStatus class]]) {
                    YWEditImageStatus *imageStatus = (YWEditImageStatus *)status;
                    imageStatus.isEdit = NO;
                }
            }
            //添加的也有编辑和不是编辑的情况
            for (NSInteger i = 0; i<self.imgArray.count; i++) {
                YWEditImageStatus *imageStatus = self.imgArray[i];
                imageStatus.isEdit = NO;
            }
            
            [self.collectionView reloadData];
            
        }
        else{ //不是编辑状态下
            
            
            YWLog(@"%ld",(long)indexPath.item);
            
            YWEditImageStatus *imageStatus = self.imgArray[indexPath.item];
            //更换图片
            if ([self.delegate respondsToSelector:@selector(photoView:changePhotoWithImageArray:andImageStatus:)]) {
                [self.delegate photoView:self changePhotoWithImageArray:self.imgArray andImageStatus:imageStatus];
            }
            
        }
        
        
        
        
    }
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.totalImageArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    id status = self.totalImageArray[indexPath.item];
    
    if ([status isKindOfClass:[YWEditAddStatus class]]) {
        
        YWEditAddStatus *addStatus = (YWEditAddStatus *)status;
        
        YWEditAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EditAddCellID forIndexPath:indexPath];
        
        cell.status = addStatus;
        
        return cell;
    }
    else if ([status isKindOfClass:[YWEditImageStatus class]]){
        
        
        YWEditImageStatus *imageStatus = (YWEditImageStatus *)status;
        
        YWEditPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EditPhotoCellID forIndexPath:indexPath];
        
        cell.delegate = self;
        
        cell.status = imageStatus;
        
        return cell;
        
    }
    else{
        
        return nil;
    }
    
    
    
}

@end
