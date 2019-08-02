//
//  YWEditPhotoLayout.m
//  Chinese
//
//  Created by yellow on 2019/5/12.
//  Copyright © 2019 YSLC. All rights reserved.
//

#import "YWEditPhotoLayout.h"


//在这里实现了布局后，不需要在外面实现collectionView的几个代理方法了

@interface YWEditPhotoLayout ()



@end

@implementation YWEditPhotoLayout




-(instancetype)init{
    if (self = [super init]) {
        
        
    }
    return self;
}




//当边界改变的时候，要不要重新布局，会多次调用prepareLayout，layoutAttributesForElementsInRect，layoutAttributesForItemAtIndexPath方法
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}


//这个方法是collectionView一切都准备好了调用
-(void)prepareLayout{
    
    [super prepareLayout];
    
    
    
}


//在rect这个位置的排布和属性
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *array = [NSMutableArray array];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i<count; i++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        [array addObject:attrs];
        
    }
    
    
    
    return array;
    
}


//这个是把上面的代码搬过来，上面再调用这个方法
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    
    
    if (indexPath.item == 0) {
        attrs.frame = CGRectMake(Divide_width, Divide_width, BigImage_width, BigImage_width);
//        attrs.zIndex = 1;
    }
      else if (indexPath.item == 1) {

          attrs.frame = CGRectMake(BigImage_width + Divide_width*2, Divide_width, SmallImage_width, SmallImage_width);
          
//          attrs.zIndex = 2;

      }
      else if (indexPath.item == 2){

          attrs.frame = CGRectMake(BigImage_width + Divide_width*2, SmallImage_width + Divide_width*2, SmallImage_width, SmallImage_width);

//          attrs.zIndex = 1;
      }
      else if (indexPath.item == 3){

          attrs.frame = CGRectMake(Divide_width, BigImage_width + Divide_width*2, SmallImage_width, SmallImage_width);

          
      }
      else if (indexPath.item == 4){

          attrs.frame = CGRectMake(SmallImage_width + Divide_width*2, BigImage_width + Divide_width*2, SmallImage_width, SmallImage_width);
          
          

      }
      else if (indexPath.item == 5){

          attrs.frame = CGRectMake(BigImage_width + Divide_width*2, BigImage_width + Divide_width*2, SmallImage_width, SmallImage_width);
          
          
      }
      else{

          //最多显示6个
          attrs.frame = CGRectMake(0, 0, 0, 0);
          attrs.hidden = YES;
          
          
      }

    
    
    return attrs;
}





@end
