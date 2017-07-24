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
//#import "ScoreCollectionViewCell.h"
#import "TakePhotoViewController.h"
#import "Manager.h"
#import "BLCollectionViewCell.h"
#import "NumView.h"
#import "GameEndView.h"


@interface ScoreboardViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic, strong)BLMainView *mainView;

@property(nonatomic, strong)NumView *numView; //横屏时

@property(nonatomic, strong)NSMutableArray *dataSource;

@property(nonatomic, strong)UIImagePickerController *imagePicker;

@property(nonatomic, strong)BLCollectionViewCell *scoreCell;//

@property(nonatomic, strong)UIImageView *showGreatImageView;        //X / 的弹框

@property(nonatomic, strong)GameEndView *showGameEndImageView;      //游戏结束的弹框

@property(nonatomic, strong)UIButton *backGroudBlackView;           //横屏的背景view

@property(nonatomic, strong)UILabel *label_great;                   //弹框展示的不同文字

@property(nonatomic ,assign)int indexPx;                            //第几个cell

@property(nonatomic, assign)int select;                             //1 是取相册，2是拍照

@property(nonatomic, strong)UIImageView *backGroudImageView;        //背景图片

@property(nonatomic, strong)UIButton *back_button;                  //返回

@property(nonatomic, strong)UIButton *setting_button;               //设置

@property(nonatomic, assign)int showIndex;                          //show 哪种图

@property(nonatomic, strong)UIView *cutView;                        //截图

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
    [self refreshConstrat];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self setNav];
    [self initMainView];
    [self setDatasource];
    __weak typeof(self) weak = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(weak) self = weak;
        [self refreshConstrat];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(weak) self = weak;
        [self reStartAnimation];
        
    }];
}

- (void)reStartAnimation
{
    [self.showGameEndImageView startAnimation];
}
- (void)initUI{
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"game_bg.jpg"];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    self.backGroudImageView = imageView;
    self.view.opaque = YES;
}

- (void)initMainView
{
    //容器view
    BLMainView *mainView = [BLMainView new];
    self.mainView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:mainView];
    BLWeak

    self.mainView = mainView;
    
    //消失的时间
     UITapGestureRecognizer *tapEnd = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showGameEndImageViewAction)];
    
    //弹框黑色的背景
    self.backGroudBlackView = [[UIButton alloc]initWithFrame:self.view.frame];
    [self.backGroudBlackView addTarget:self action:@selector(endImageViewAction) forControlEvents:UIControlEventTouchUpInside];
    self.backGroudBlackView.hidden = YES;
    self.backGroudBlackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.backGroudBlackView];
    
    //游戏结束
    self.showGameEndImageView = [[GameEndView alloc]initWithFrame:self.view.frame];
    self.showGameEndImageView.hidden = YES;
    self.showGameEndImageView.userInteractionEnabled = YES;
    [self.showGameEndImageView addGestureRecognizer:tapEnd];
    [self.view addSubview:self.showGameEndImageView];
    
    //
    
    //横屏顶部的view
    self.numView = [[NumView alloc]init];
    [self.mainView addSubview:self.numView];
    
    //打得好
    self.showGreatImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    self.showGreatImageView.hidden = YES;
    self.showGreatImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImageViewAction)];
    [self.showGreatImageView addGestureRecognizer:tap];
    [self.view addSubview:self.showGreatImageView];
    
    self.label_great = [UILabel new];
    self.label_great.text  = @"";
    self.label_great.textColor = [UIColor whiteColor];
    [self.label_great setLineBreakMode:NSLineBreakByWordWrapping];
    self.label_great.font = [UIFont systemFontOfSize:24];
    self.label_great.numberOfLines = 2;
    self.label_great.textAlignment = NSTextAlignmentCenter;
    self.label_great.backgroundColor = [UIColor clearColor];
    [self.showGreatImageView addSubview:self.label_great];
    //系统相册类
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    
    //拍照或者拍摄
    self.mainView.photoBlock = ^(BLCollectionViewCell *soreCell,int index,int select){
        
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
    
    //TODO: show 图
    self.mainView.greatShowCall = ^(int showIndex,NSString *name){
        __strong typeof(weakSelf)self = weakSelf;
        self.backGroudBlackView.hidden = NO;
        if (showIndex == good_job) {
            self.showGreatImageView.image = [UIImage imageNamed:@"good_job_bg.jpg"];
            self.showGreatImageView.hidden = NO;
            self. showIndex = showIndex;
        }else if (showIndex == game_end){
            //游戏结束
            self.showGameEndImageView.winner = name;
            self.showGameEndImageView.hidden = NO;
            self.mainView.scoreArray = [Manager sharedInstance].allPersonArr;
        }else if (showIndex == well_done){
            self.showGreatImageView.image = [UIImage imageNamed:@"well_done_bg.jpg"];
            self.showGreatImageView.hidden = NO;
            self. showIndex = showIndex;
        }else if (showIndex == bravo){
            self.showGreatImageView.image = [UIImage imageNamed:@"bravo_bg.jpg"];
            self.showGreatImageView.hidden = NO;
            self. showIndex = showIndex;
        }else if (showIndex == fantastic){
            self.showGreatImageView.image = [UIImage imageNamed:@"fantastic_bg.jpg"];
            self.showGreatImageView.hidden = NO;
            self. showIndex = showIndex;
        }else if (showIndex == bravo_three){
            self.showGreatImageView.image = [UIImage imageNamed:@"bravo_bg.jpg"];
            self.showGreatImageView.hidden = NO;
            self. showIndex = showIndex;
        }
        //重新给图
        [self refreshConstrat];
    };
    
    //show 图
    
    self.mainView.greatShowText = ^(NSString *string){
        __strong typeof(weakSelf)self = weakSelf;
        
        self.label_great.text = string;
        
    };
    
    [self refreshConstrat];
    
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{

    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) NSLog(@"横向");
    
    else if(UIDeviceOrientationIsPortrait(deviceOrientation)) NSLog(@"纵向");
    
    // // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft); // 只支持向左横向, YES 表示支持所有方向
}
//TODO:横竖屏
- (void)refreshConstrat
{

    if (self.mainView.scoreViewBut) {
        [self.mainView hideButtonView];
    }
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        BLWeak
        self.numView.hidden = YES;
        self.backGroudImageView.image = [UIImage imageNamed:@"game_bg.jpg"];
        [self.mainView mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.top.equalTo(self.view.mas_top).offset(90);
            make.right.equalTo(@0);
            make.left.equalTo(@5);
            make.bottom.equalTo(@0);
        }];
        if (ZZN_UI_SCREEN_W < 350) {
            [self.mainView mas_remakeConstraints:^(MASConstraintMaker *make) {
                BLStrong
                make.top.equalTo(self.view.mas_top).offset(60);
                make.right.equalTo(@0);
                make.left.equalTo(@5);
                make.bottom.equalTo(@0);
            }];

        }
        [self.showGreatImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        [self.showGameEndImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        [self.label_great mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.bottom.mas_equalTo(self.showGreatImageView).offset(-60);
            make.centerX.mas_equalTo(self.showGreatImageView).offset(0);
            make.height.mas_equalTo(80);
            make.width.mas_equalTo(@250);
        }];
        if (ZZN_UI_SCREEN_W < 350) {
            [self.label_great mas_remakeConstraints:^(MASConstraintMaker *make) {
                BLStrong
                make.bottom.mas_equalTo(self.showGreatImageView).offset(-40);
                make.centerX.mas_equalTo(self.showGreatImageView).offset(0);
                make.height.mas_equalTo(80);
                make.width.mas_equalTo(@250);
            }];

        }
        switch (self.showIndex) {
            case good_job:
                self.showGreatImageView.image = [UIImage imageNamed:@"good_job_bg.jpg"];
                break;
            case game_end:
//                self.showGreatImageView.image = [UIImage imageNamed:@"good_job_bg.jpg"];
                break;
            case well_done:
                self.showGreatImageView.image = [UIImage imageNamed:@"well_done_bg.jpg"];
                break;
            case bravo:
                self.showGreatImageView.image = [UIImage imageNamed:@"bravo_bg.jpg"];
                break;
            case fantastic:
                self.showGreatImageView.image = [UIImage imageNamed:@"fantastic_bg.jpg"];
                break;
            case bravo_three:
                self.showGreatImageView.image = [UIImage imageNamed:@"bravo_bg.jpg"];
                break;
     
            default:
                break;
        }
       

    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        self.numView.hidden = NO;
        self.backGroudImageView.image = [UIImage imageNamed:@"gamehbg"];
        BLWeak
        [self.mainView mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.top.equalTo(self.view.mas_top).offset(40);
            make.right.equalTo(@0);
            make.left.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        if (ZZN_UI_SCREEN_H < 350) {
            [self.mainView mas_remakeConstraints:^(MASConstraintMaker *make) {
                BLStrong
                make.top.equalTo(self.view.mas_top).offset(30);
                make.right.equalTo(@0);
                make.left.equalTo(@0);
                make.bottom.equalTo(@0);
            }];
            
        }
        
        [self.numView mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.bottom.equalTo(self.mainView.collectionView.mas_top).offset(10);
            make.left.equalTo(self.mainView.collectionView.mas_left).offset(10);;
            make.right.equalTo(self.mainView.collectionView.mas_right).offset(-10);;
            make.height.equalTo(@20);
        }];
        [self.backGroudBlackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        [self.showGreatImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        [self.showGameEndImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        [self.label_great mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.right.mas_equalTo(self.showGreatImageView).offset(-40);
            make.centerY.mas_equalTo(self.showGreatImageView).offset(30);
            make.height.mas_equalTo(80);
            make.width.mas_equalTo(@300);
        }];
        if (ZZN_UI_SCREEN_H < 350) {
            [self.label_great mas_remakeConstraints:^(MASConstraintMaker *make) {
                BLStrong
                make.right.mas_equalTo(self.showGreatImageView).offset(0);
                make.centerY.mas_equalTo(self.showGreatImageView).offset(30);
                make.height.mas_equalTo(80);
                make.width.mas_equalTo(@300);
            }];
            
        }

        //获取一下比赛人数
        [Person getPersons];
        switch (self.showIndex) {
            case good_job:
                self.showGreatImageView.image = [UIImage imageNamed:@"good_job_bgh"];
                break;
            case game_end:
                //                self.showGreatImageView.image = [UIImage imageNamed:@"good_job_bg.jpg"];
                break;
            case well_done:
                self.showGreatImageView.image = [UIImage imageNamed:@"well_done_bgh"];
                break;
            case bravo:
                self.showGreatImageView.image = [UIImage imageNamed:@"bravo_bgh"];
                break;
            case fantastic:
                self.showGreatImageView.image = [UIImage imageNamed:@"fantastic_bgh"];
                break;
            case bravo_three:
                self.showGreatImageView.image = [UIImage imageNamed:@"bravo_bgh"];
                break;
                
            default:
                break;
        }
        

    }

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
    UIButton *back_button = [UIButton new];
    [back_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back_button];
    self.back_button = back_button;
    [back_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
    }];
    
    //设置
    UIButton *setting_button = [UIButton new];
    [setting_button addTarget:self action:@selector(popAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setting_button];
    self.setting_button = setting_button;
    [setting_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
    }];
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
//设置窗口
- (void)popAlertView
{
    if (self.mainView.scoreViewBut) {
        [self.mainView hideButtonView];
    }
    BLWeak
    [[ZZNUIManager sharedInstance] showThreeSelectAlert:@"save" firstBlock:^{
        BLStrong
        self.mainView.scoreArray = [[Manager sharedInstance] removeAllScore];
        [self.mainView reload];
    } secondBlock:^{
        BLStrong;
        BLWeak
        [[ZZNUIManager sharedInstance] showThreeSelectAlert:nil firstTitle:@"clear score" secondTitle:@"clear all" thirdTitle:@"cancel" firstBlock:^{
            BLStrong
            self.mainView.scoreArray = [[Manager sharedInstance] removeAllScoreAndAllPhotos];
            [self.mainView reload];
        } secondBlock:^{
            BLStrong
            self.mainView.scoreArray = [[Manager sharedInstance] removeAllScore];
            [self.mainView reload];
        } thirdBlock:^{
        }];
    } thirdBlock:^{
        BLStrong
        [self screenShotAction];
    } fourBlock:^{
        TakePhotoViewController *vc = [TakePhotoViewController new];
        BLStrong
        self.view.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } fiveBlock:^{
    }];
}
-(void) screenShotAction
{
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //强制翻转屏幕，Home键在右边。
        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
        //刷新
        [UIViewController attemptRotationToDeviceOrientation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIGraphicsBeginImageContext(self.view.bounds.size);
            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            //写入相册
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
            [self showAlertIndictorWithMessage:@"The photo has been saved to the photo ablum" withDelay:1];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
            //刷新
            [UIViewController attemptRotationToDeviceOrientation];
            [self.mainView.collectionView reloadData];
        });
    
    }else{
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //写入相册
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
        [self showAlertIndictorWithMessage:@"The photo has been saved to the photo ablum" withDelay:1];
    }
    
   
}
- (void)showImageViewAction{
    self.showGreatImageView.hidden  = YES;
    if (self.showGameEndImageView.hidden) {
         self.backGroudBlackView.hidden = YES;
    }
}
- (void)showGameEndImageViewAction{
    self.showGameEndImageView.hidden  = YES;
    self.backGroudBlackView.hidden = YES;
}
- (void)endImageViewAction
{
    self.showGreatImageView.hidden  = YES;
    self.backGroudBlackView.hidden = YES;
    self.showGameEndImageView.hidden  = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (BOOL)shouldAutorotate{
    return YES;
}

- (void)cature
{
    self.numView.hidden = NO;
    self.backGroudImageView.image = [UIImage imageNamed:@"gamehbg"];
    BLWeak
    [self.mainView mas_remakeConstraints:^(MASConstraintMaker *make) {
        BLStrong
        make.top.equalTo(self.view.mas_top).offset(40);
        make.right.equalTo(@0);
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    if (ZZN_UI_SCREEN_H < 350) {
        [self.mainView mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.top.equalTo(self.view.mas_top).offset(40);
            make.right.equalTo(@0);
            make.left.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
    }
    [self.numView mas_remakeConstraints:^(MASConstraintMaker *make) {
        BLStrong
        make.bottom.equalTo(self.mainView.collectionView.mas_top).offset(10);
        make.left.equalTo(self.mainView.collectionView.mas_left).offset(10);;
        make.right.equalTo(self.mainView.collectionView.mas_right).offset(-10);;
        make.height.equalTo(@20);
    }];
    [self.backGroudBlackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.showGreatImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.showGameEndImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.label_great mas_remakeConstraints:^(MASConstraintMaker *make) {
        BLStrong
        make.right.mas_equalTo(self.showGreatImageView).offset(-40);
        make.centerY.mas_equalTo(self.showGreatImageView).offset(30);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(@300);
    }];
    if (ZZN_UI_SCREEN_H < 350) {
        [self.label_great mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.right.mas_equalTo(self.showGreatImageView).offset(0);
            make.centerY.mas_equalTo(self.showGreatImageView).offset(30);
            make.height.mas_equalTo(80);
            make.width.mas_equalTo(@300);
        }];
        
    }
    
    self.view.transform = CGAffineTransformMakeRotation(-M_PI / 2);

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
