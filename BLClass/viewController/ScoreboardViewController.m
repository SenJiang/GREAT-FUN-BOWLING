//
//  ScoreboardViewController.m
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/2.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import "ScoreboardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Masonry.h"
#import "ZZNUIManager.h"
#import "BLMainView.h"
#import "Person.h"
#import "UIViewController+UE.h"
#import "ScoreCollectionViewCell.h"
#import "TakePhotoViewController.h"
#import "Manager.h"



@interface ScoreboardViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic, strong)BLMainView *mainView;

@property(nonatomic, strong)NSMutableArray *dataSource;

@property(nonatomic, strong)UIImagePickerController *imagePicker;

@property(nonatomic, strong)ScoreCollectionViewCell *scoreCell;

@property(nonatomic, strong)UIImageView *showGreatImageView;

@property(nonatomic ,assign)int indexPx;//第几个cell

@property(nonatomic, assign)int select; //1 是取相册，2是拍照

@end

@implementation ScoreboardViewController

- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.view.hidden = NO;
}
-(void)dealloc{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self initUI];
    [self initMainView];
    [self setDatasource];
    
}
- (void)initMainView
{
    self.mainView = [[BLMainView alloc]initWithFrame:CGRectMake(5, 44, ZZN_UI_SCREEN_W, ZZN_UI_SCREEN_H - 44)];
    [self.view addSubview:self.mainView];
    
    //打得好
    self.showGreatImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    self.showGreatImageView.hidden = YES;
    self.showGreatImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImageViewAction)];
    [self.showGreatImageView addGestureRecognizer:tap];
    [self.view addSubview:self.showGreatImageView];
    
    //系统相册类
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    
    __weak typeof(self)weakSelf = self;
    //拍照或者拍摄
    self.mainView.photoBlock = ^(ScoreCollectionViewCell *soreCell,int index,int select){
        
        // select = 1 是去相册，2 是拍照
        // index 点击的第几个图片
        __strong typeof(weakSelf)self = weakSelf;
        
        self.scoreCell = soreCell;
        self.indexPx = index;
        self.select = select;
        if (select == 1) {
            [self getSystemPhoto];
        }else{
            [self getSystemCamera];
        }
    };
    
    //show 图
    self.mainView.greatShowCall = ^(int showIndex){
        __strong typeof(weakSelf)self = weakSelf;
        if (showIndex == bravo) {
            self.showGreatImageView.image = [UIImage imageNamed:@"bravo_bg.jpg"];
            self.showGreatImageView.hidden = NO;
        }else if (showIndex == game_end){
            self.showGreatImageView.image = [UIImage imageNamed:@"game_end_bg.jpg"];
            self.showGreatImageView.hidden = NO;
        }
    };
    
    
}
//TODO:打开系统相册
- (void)getSystemPhoto
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}
- (void)getSystemCamera
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}
-(void)readDataSource{
    self.mainView.scoreArray =  [[[Manager sharedInstance] getAllDataSource] mutableCopy];
}
-(void)setDatasource
{
 
    [self readDataSource];
    
}
- (void)setNav
{
    //返回
    UIButton *play_button = [UIButton new];
    [play_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    play_button.backgroundColor = [UIColor redColor];
    [self.view addSubview:play_button];
    
    [play_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
    }];
    
    //设置
    UIButton *setting_button = [UIButton new];
    [setting_button addTarget:self action:@selector(popAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setting_button];
    
    [setting_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
    }];
}
- (void)initUI{
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"game_bg.jpg"];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    self.view.opaque = YES;
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    [self saveImage:image];

   
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
}
#pragma mark - 照片存到本地后的回调
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"存储成功");
    } else {
        NSLog(@"存储失败：%@", error);
    }
}
#pragma mark - 保存图片
- (void) saveImage:(UIImage *)currentImage {
    //设置照片的品质
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/bowling%d.png",self.indexPx]];
    // 将图片写入文件
    [imageData writeToFile:filePath atomically:YES];
    
    
    NSLog(@"imagePath==%@",filePath);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mainView.collectionView reloadData];
        //刷新列表
    });
    
}
- (void)popAlertView
{
    __weak typeof(self)weakself = self;
    [[ZZNUIManager sharedInstance] showThreeSelectAlert:@"save" firstTitle:@"take" secondTitle:@"new" thirdTitle:@"cancel" alertBlock:^{
        __strong typeof(weakself)self = weakself;
        [self screenShotAction];
        [self showAlertIndictorWithMessage:@"The photo has been saved to the photo ablum" withDelay:1];
        
    } firstBlock:^{
        TakePhotoViewController *vc = [TakePhotoViewController new];
         __strong typeof(weakself)self = weakself;
        self.view.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } secondBlock:^{
        __weak typeof(self)weakself = self;
        [[ZZNUIManager sharedInstance] showThreeSelectAlert:nil firstTitle:@"clear score" secondTitle:@"clear all" thirdTitle:@"cancel" firstBlock:^{
             __strong typeof(weakself)self = weakself;
            self.mainView.scoreArray = [[Manager sharedInstance] removeAllScore];
            [self.mainView reload];
            
        } secondBlock:^{
            __strong typeof(weakself)self = weakself;
            self.mainView.scoreArray = [[Manager sharedInstance] removeAllScoreAndAllPhotos];
            [self.mainView reload];
            
        } thirdBlock:^{
            
        }];
    } thirdBlock:^{
        
    }];
}
-(void) screenShotAction
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    //写入相册
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}
- (void)showImageViewAction{
    self.showGreatImageView.hidden  = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
