//
//  ViewController.m
//  图片拍照上展示文字
//
//  Created by 辛忠志 on 2017/7/24.
//  Copyright © 2017年 辛忠志. All rights reserved.
//
#define HRWitch [UIScreen mainScreen].bounds.size.width
#define HRHeight [UIScreen mainScreen].bounds.size.height
#define kApplicationShared  [UIApplication sharedApplication]
#pragma mark - ------------------- XIB --------------------
#define HRXIB(Class) [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([Class class]) owner:nil options:nil] firstObject];
#import "ViewController.h"
#pragma mark ----------------------- 系统类型 -----------------------
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#pragma mark ----------------------- View类型 -----------------------
#import "backView.h"
@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *_imagePickerController;
}
@property (strong,nonatomic)UIImageView * imageView;
@property (strong,nonatomic)backView * BView;
@end

@implementation ViewController
- (backView *)BView{
    if (!_BView) {
        _BView = HRXIB(backView);
        self.BView.frame = CGRectMake(0,50, HRWitch, HRHeight-50-80);
    }
    return _BView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
    [kApplicationShared.keyWindow addSubview:self.BView ];
    self.BView.hidden = YES;
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(200, 200, 50, 50)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"拍照" forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 400, 100, 100)];
    self.imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:btn];
}
-(void)btnClick{
    [self openCamera];
}
/**
 
 *  调用照相机
 
 */

- (void)openCamera

{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    
    picker.allowsEditing = NO; //可编辑
    
    //判断是否可以打开照相机
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        
        //摄像头
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        self.BView.hidden = NO;
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    
    else
        
    {
        
        NSLog(@"没有摄像头");
        
    }
    
}



/**
 
 *  打开相册
 
 */

-(void)openPhotoLibrary

{
    
    // Supported orientations has no common orientation with the application, and [PUUIAlbumListViewController shouldAutorotate] is returning YES
    
    
    
    // 进入相册
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        
    {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        
        imagePicker.allowsEditing = YES;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        imagePicker.delegate = self;
        
        [self presentViewController:imagePicker animated:YES completion:^{
            
            NSLog(@"打开相册");
            
        }];
        
    }
    
    else
        
    {
        
        NSLog(@"不能打开相册");
        
    }
    
}



#pragma mark - UIImagePickerControllerDelegate

// 拍照完成回调

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)

{
    
    NSLog(@"finish..");
    
    
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        
    {
        //获取当前的截图  苹果系统直接有方法可以截取当前试图的view大小的截图 就是背景View
        //UIGraphicsBeginImageContext  这个方法是7.0之前的方法 用这个会造成 截屏的像素模糊
        //        UIGraphicsBeginImageContext(self.BView.bounds.size);
        
        UIGraphicsBeginImageContextWithOptions(self.BView.bounds.size, YES, 0.0);
        [[[UIApplication sharedApplication] keyWindow] drawViewHierarchyInRect:CGRectMake(0, -70, HRWitch, HRHeight+70) afterScreenUpdates:YES];
        //将ImageContext放入一个UIImage内然后清理掉这个ImageContext
        UIImage * image1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.imageView.image = image1;
        /*把图片存到相册中*/
        UIImageWriteToSavedPhotosAlbum(image1, nil, nil, nil);
    }
    /*取消隐藏*/
    self.BView.hidden = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//进入拍摄页面点击取消按钮

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    /*取消隐藏*/
    self.BView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
/*截屏功能*/
-(UIImage *)captureScreenForView:(UIView *)currentView {
    UIGraphicsBeginImageContext(currentView.frame.size);
    [currentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  viewImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
