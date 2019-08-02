//
//  YWPhotoController.m
//  YWPhotoView
//
//  Created by yellow on 2019/7/31.
//  Copyright © 2019 YW. All rights reserved.
//

#import "YWPhotoController.h"

#import "YWPhotoView2.h"

#import "YWEditImageStatus.h"

@interface YWPhotoController ()<YWPhotoView2Delegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,weak)YWPhotoView2 *photoView; // 所需要用到的编辑相片view

@property(nonatomic,assign)BOOL isChangePhoto; // 是否重选相片，不是的话就是添加相片

@property(nonatomic,strong)YWEditImageStatus *oldImageStatus; // 旧相片模型

@end

@implementation YWPhotoController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = mainColor;
    
    [self setupPhotoView];
    
}

-(void)setupPhotoView{
    
    YWPhotoView2 *photoView = [[YWPhotoView2 alloc] initWithFrame:CGRectMake(0, 60, Wi, Wi)];
    
    photoView.backgroundColor = mainColor;
    
    photoView.delegate = self;
    
    self.photoView = photoView;
    
    [self.view addSubview:photoView];
    
    //这里可以从网上请求得到的图片模型数组，给到self.photoView显示
    NSMutableArray *imgArray = [NSMutableArray array];
    self.photoView.imgArray = imgArray;
    
    
    
}


#pragma mark ------图片编辑代理方法

//删除图片
-(void)photoView:(YWPhotoView2 *)photoView deletePhotoWithImageArray:(nonnull NSMutableArray *)imgArray andImageStatus:(nonnull YWEditImageStatus *)imageStatus{
    
    //最后一张图片不能删除，只能提示
    
    if (imgArray.count <= 1) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"最后一张照片不能删除" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    [imgArray removeObject:imageStatus];
    
    //把新图片数组重新赋值给photoView
    self.photoView.imgArray = imgArray;
    
}

//用系统的添加，只能一张张来，每次添加都要调用一次接口
-(void)photoView:(YWPhotoView2 *)photoView addPhotoWithImageArray:(NSMutableArray *)imgArray{
    self.isChangePhoto = NO;
    [self openPhoto];
    
    
}

//交换图片
-(void)photoView:(YWPhotoView2 *)photoView changePhotoWithImageArray:(NSMutableArray *)imgArray andImageStatus:(YWEditImageStatus *)imageStatus{
    
    self.isChangePhoto = YES;
    self.oldImageStatus = imageStatus;
    [self openPhoto];
    
}

//添加图片/交换图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //    获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //    创建image模型添加到数组，付给photoView解决
    
    YWEditImageStatus *imgStatus = [[YWEditImageStatus alloc] init];
    
    //是本地上传的图片，用image显示不用URL显示，到时上传只上传isLocal等于YES的图片
    imgStatus.isLocal = YES;
    imgStatus.image = image;
    
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.photoView.imgArray];
    
    if (self.isChangePhoto) {
        
        NSInteger index = [self.photoView.imgArray indexOfObject:self.oldImageStatus];
        
        [mArray replaceObjectAtIndex:index withObject:imgStatus];
    }
    else{
        
        [mArray addObject:imgStatus];
        
    }
    
    
    self.photoView.imgArray = mArray;
    
    //    获取图片后返回
    [picker dismissViewControllerAnimated:YES completion:nil];
}



-(void)openPhoto{
    
    // 进入相册
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        
        imagePicker.allowsEditing = NO;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        imagePicker.delegate = self;
        
        [self presentViewController:imagePicker animated:YES completion:^{
            
            YWLog(@"打开相册");
            
        }];
        
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"相册不可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}


//按取消按钮时候的功能
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    返回
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController   willShowViewController:(UIViewController *)viewController  animated:(BOOL)animated{
    if ([navigationController isKindOfClass:[UIImagePickerController class]]){ viewController.navigationController.navigationBar.translucent = NO;
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
        viewController.navigationController.navigationBar.barTintColor = mainColor;
        //title颜色和字体
        viewController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
        viewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
}



@end
