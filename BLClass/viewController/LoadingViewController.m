//
//  LoadingViewController.m
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/2.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import "LoadingViewController.h"
#import "PlayViewController.h"
#import "Masonry.h"
#import "Person.h"
#import "Manager.h"
@interface LoadingViewController ()
@property (nonatomic, strong)UILabel *label_loading;
@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, assign)BOOL isLoaded;//第一次进来
@end

@implementation UINavigationController (Rotate)

-(BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
    
}

-(NSUInteger)supportedInterfaceOrientations {
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

@end

@implementation LoadingViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (self.isLoaded) {
        //重新loading
        self.label_loading.text = @"LOADING.";
        [self presentPlayViewController];
    }
    self.isLoaded = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentPlayViewController];
    });
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstBowling"]) {
        [self setData];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstBowling"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    __weak typeof(self) weak = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(weak) self = weak;
        [self refreshConstrat];
    }];

    
}
- (void)initUI
{
    self.navigationController.navigationBar.hidden = YES;
    UIImageView *backImageView = [UIImageView new];
    backImageView.image = [UIImage imageNamed:@"loading_bg.jpg"];
    [self.view addSubview:backImageView];
    self.backImageView = backImageView;
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    UILabel *label_loading = [UILabel new];
    label_loading.backgroundColor = [UIColor clearColor];
    label_loading.font = [UIFont systemFontOfSize:14];
    label_loading.textColor = [UIColor yellowColor];
    label_loading.textAlignment = NSTextAlignmentLeft;
    label_loading.text = @"LOADING.";
    [self.view addSubview:label_loading];
    self.label_loading = label_loading;
    [label_loading mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.bottom.equalTo(@-40);
        make.height.equalTo(@21);
        make.width.equalTo(@90);
    }];
    [self refreshConstrat];
}
- (void)presentPlayViewController
{
    NSMutableString *str = [[NSMutableString alloc]initWithString:self.label_loading.text];
    NSString *loading = [str stringByAppendingString:@"."];
    self.label_loading.text = loading;
    if ([str isEqualToString:@"LOADING......"]) {
        PlayViewController *playVC = [PlayViewController new];
        [self.navigationController pushViewController:playVC animated:YES];
        return;
    }
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self presentPlayViewController];
        
    });
    
}
- (void)refreshConstrat
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
    //竖屏
        self.backImageView.image = [UIImage imageNamed:@"S0607001"];
        [self.backImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
    //横屏
        self.backImageView.image = [UIImage imageNamed:@"loading_bg2h"];
        [self.backImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    
    }
    
}

- (void)setData
{
    NSMutableArray *boardArr1 = [NSMutableArray new];
    NSMutableArray *boardArr2 = [NSMutableArray new];
    NSMutableArray *boardArr3 = [NSMutableArray new];
    NSMutableArray *boardArr4 = [NSMutableArray new];
    for (int i = 0; i<10; i++) {
        Board *board1 = [[Board alloc]init];
        board1.resultScore = board1.secondScore = board1.threeScore = board1.firstScore = @"";
        [boardArr1 addObject:board1];
        Board *board2 = [[Board alloc]init];
        board2.resultScore = board2.secondScore  = board2.threeScore = board2.firstScore = @"";
        [boardArr2 addObject:board2];
        Board *board3 = [[Board alloc]init];
        board3.resultScore = board3.secondScore = board3.threeScore =  board3.firstScore = @"";
        [boardArr3 addObject:board3];
        Board *board4 = [[Board alloc]init];
        board4.resultScore = board4.secondScore = board4.threeScore = board4.firstScore = @"";
        [boardArr4 addObject:board4];
        
    }
    
     [[Manager sharedInstance] writeDataWithArray:boardArr1 andName:firstBoard];
     [[Manager sharedInstance] writeDataWithArray:boardArr2 andName:secondBoard];
     [[Manager sharedInstance] writeDataWithArray:boardArr3 andName:threeBoard];
     [[Manager sharedInstance] writeDataWithArray:boardArr4 andName:fourBoard];
    
    NSMutableArray *personArr = [NSMutableArray new];
    for (int i = 0; i<4; i++) {
        Person *person = [[Person alloc]init];
        person.image = [NSString stringWithFormat:@"%d",i];
        person.name = [NSString stringWithFormat:@"Player %d",i+1];
        person.total = @"";
        [personArr addObject:person];
    }
    [[Manager sharedInstance] writeDataWithArray:personArr andName:STORAGE];
#if 0
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:personArr];
    [[NSUserDefaults standardUserDefaults]setObject:personData forKey:@"STORAGE_personData"];
    [[NSUserDefaults standardUserDefaults]synchronize];
#endif
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate

{
    
    return YES;
    
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
