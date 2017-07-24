//
//  TakePhotoViewController.m
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/7.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "ZZNUIManager.h"
#import "Masonry.h"
#import "UIViewController+UE.h"

@interface TakePhotoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong)UIImageView *photoView;

@property(nonatomic, strong)UIImagePickerController *imagePicker;

@end

@implementation TakePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self getSystemCamera];
}
-(BOOL)shouldAutorotate{
    return NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.view.hidden = NO;
}
- (void)initUI

{
    self.photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ZZN_UI_SCREEN_W, ZZN_UI_SCREEN_H)];
    self.photoView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoView.userInteractionEnabled = YES;
    [self.view addSubview:self.photoView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ZZN_UI_SCREEN_W, ZZN_UI_SCREEN_H)];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getSystemCamera)];
    [imageView addGestureRecognizer:tap];
    imageView.image = [UIImage imageNamed:@"ico_take_bg"];
    [self.photoView addSubview:imageView];
    
    UIButton *backBtn = [UIButton new];
    [backBtn setImage:[UIImage imageNamed:@"ico_back_"] forState:UIControlStateNormal];
     [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@15);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    
    UIButton *saveBtn = [UIButton new];
    [saveBtn setImage:[UIImage imageNamed:@"ico_save_"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-25);
        make.right.equalTo(@-15);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    
    __weak typeof(self) weak = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(weak) self = weak;
        [self refreshConstrat];
    }];

}
//TODO:横竖屏
- (void)refreshConstrat
{
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        
    self.photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ZZN_UI_SCREEN_W, ZZN_UI_SCREEN_H)];

    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        
        
    }
}
- (void)getSystemCamera
{
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;

    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.view.hidden = YES;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
}

#pragma mark - Action
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)save{
    [self screenShotAction];
}
-(void) screenShotAction
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.photoView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //写入相册
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    [self showAlertIndictorWithMessage:@"The photo has been saved to the photo ablum" withDelay:1];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.photoView.image = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
