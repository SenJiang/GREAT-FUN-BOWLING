//
//  ZZNUIManager.m
//  zzn
//
//  Created by WangYa on 15-5-15.
//  Copyright (c) 2015年 DETU. All rights reserved.
//

#import "ZZNUIManager.h"
#import <objc/runtime.h>
#import "ZZNAlterView.h"
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>

CFTimeInterval const ZZNAnimationDuration_0d5 = 0.5;
CFTimeInterval const ZZNAnimationDuration_2d0 = 2;
CFTimeInterval const ZZNAnimationDuration_0d25 = 0.25;

@implementation ZZNUIManager
+ (instancetype) sharedInstance{
    static id obj = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        obj = [[self alloc] init];
    });
    return obj;
   
}

+ (BOOL) getVariableWithClass:(Class) myClass varName:(NSString *)name{	unsigned int outCount, i;
    Ivar *ivars = class_copyIvarList(myClass, &outCount);
    for (i = 0; i < outCount; i++) {
        Ivar property = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        keyName = [keyName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        if ([keyName isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}

// UI风格统一处理
- (void) configUI{
    //导航栏颜色设置
    [[UINavigationBar appearance] setBarTintColor:ZZN_UI_BACK_COLOR];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UITabBar appearance] setBarTintColor:ZZN_UI_COLOR_BROWN];
    [[UITabBar appearance] setTranslucent:NO];
    
    //UISwitch颜色设置
    [[UISwitch appearance] setThumbTintColor:ZZN_UI_COLOR_WHITE];//
    [[UISwitch appearance] setTintColor:[UIColor whiteColor]];//
    [[UISwitch appearance] setOnTintColor:ZZN_UI_COLOR_ORANGE];//0xf6bd1f
//    [[UISwitch appearance] setOnImage:[UIImage imageWithColor:ZZN_UI_COLOR_WHITE]];
//    [[UISwitch appearance] setOffImage:[UIImage imageWithColor:ZZN_UI_BACK_COLOR]];

    
    // 所有控制器只支持横屏
    
//    [UIViewController aspect_hookSelector:@selector(supportedInterfaceOrientations) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo) {
//        UIInterfaceOrientationMask orientation;
//        id controller = [aspectInfo instance];
//        if ([controller isKindOfClass:[CustomUINavigationController class]]) {
//            orientation = UIInterfaceOrientationMaskAllButUpsideDown;
//        }else{
//            orientation = UIInterfaceOrientationMaskPortrait;
//        }
//
//        NSInvocation* invocation = aspectInfo.originalInvocation;
//        [invocation invoke];
//        [invocation setReturnValue:&orientation];
//    } error:&error];
//    if (error) {
//        ZZNLogError(@"%@",error);
//        error = nil;
//    }
    
//    [UIViewController aspect_hookSelector:@selector(prefersStatusBarHidden) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo) {
//        id controller = [aspectInfo instance];
//        BOOL isHideStatusBar;
//        if ([controller isKindOfClass:[CustomUINavigationController class]]) {
//            isHideStatusBar = YES;
//        }else{
//            isHideStatusBar = NO;
//        }
//        NSInvocation* invocation = aspectInfo.originalInvocation;
//        [invocation invoke];
//        [invocation setReturnValue:&isHideStatusBar];
//        
//    } error:&error];
//    if (error) {
//        ZZNLogError(@"%@",error);
//        error = nil;
//    }

   

    
    // UIImageView 用 sd_setImageWithURL 时,如果图片加在于非内存,则显示渐变效果
//    [UIImageView aspect_hookSelector:@selector(sd_setImageWithURL:placeholderImage:options:progress:completed:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo) {
//        UIImageView* imageView = aspectInfo.instance;
//        [imageView.pop_stop alpha];
//        imageView.alpha = 1;
//        
//        NSArray* arguments = aspectInfo.arguments;
//        SDWebImageCompletionBlock block = [arguments objectAtIndex:4]==[NSNull null]?nil:[arguments objectAtIndex:4];
//        
//        @weakify(imageView);
//        SDWebImageCompletionBlock newBlock = ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            @strongify(imageView);
//            if (block) {
//                block(image,error,cacheType,imageURL);
//            }
//            if (error) {
//                ZZNLogWarn(@"请求图片(%@)失败,error:%@",imageURL,error);
//            }
//            if (cacheType != SDImageCacheTypeMemory && image) {
//                imageView.alpha = 0;
//                imageView.pop_duration = ZZNAnimationDuration_0d25;
//                imageView.pop_linear.alpha = 1;
//            }
//        };
    
//        NSInvocation *invocation = aspectInfo.originalInvocation;
//        [invocation setArgument:&newBlock atIndex:6];
//        
//        [invocation invoke];
//    } error:&error];
//    if (error) {
//        ZZNLogError(@"%@",error);
//        error = nil;
//    }
    
    // 调试,部分ui在 enabled 为 no 时，显示为纯黑色
//    [UIControl aspect_hookSelector:@selector(initWithFrame:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
//        UIControl* control = aspectInfo.instance;
//        control.backgroundColor = ZZN_UI_COLOR_TEMP_RANDOM;
//        RAC(control.layer,borderWidth) = [RACObserve(control, enabled) map:^id(id value) {
//            return [value boolValue] ? @(0) : @(1000);
//        }];
//    } error:&error];
//    if (error) {
//        ZZNLogError(@"%@",error);
//        error = nil;
//    }
}

//弹出提示信息
- (void)showAlertMsg:(NSString *)msg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ZZNAlterView showmessage:ZZN_LOCALIZED_STRING(@"Notice", nil) subtitle:msg cancelbutton:ZZN_LOCALIZED_STRING(@"Determine", nil)];
    });
}

//edit show
- (void)eidtShowFirstBlock:(void(^)(void))firstBlock secondBlock:(void(^)(void))secondBlock thirdBlock:(void(^)(void))thirdBlock{
    ZZNAlterView *alter = [[ZZNAlterView alloc] initWithleftBlock:firstBlock rightBlock:secondBlock thirdBlock:thirdBlock];
    [alter showNewGame];
    
}
//edit show 三个分选择
- (void)eidtShowFirstBlock:(void(^)(void))firstBlock secondBlock:(void(^)(void))secondBlock thirdBlock:(void(^)(void))thirdBlock threeBlock:(void(^)())threeBlock{
    ZZNAlterView *alter = [[ZZNAlterView alloc] initWithleftBlock:firstBlock rightBlock:secondBlock thirdBlock:thirdBlock alertBlock:threeBlock];
    [alter showNewGame];
}

//弹出操作提示
- (void)showAlertSelect:(NSString *)msg leftTitle:(NSString*)leftTitle rightTitle:(NSString*)rightTitle leftBlock:(void(^)(void))leftBlock rightBlock:(void(^)(void))rightBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        ZZNAlterView *alter = [[ZZNAlterView alloc] initWithTitle:ZZN_LOCALIZED_STRING(@"Notice", nil) contentText:msg leftButtonTitle:leftTitle rightButtonTitle:rightTitle leftBlock:leftBlock rightBlock:rightBlock];
        [alter show];

    });
}

// 四个选项的提示
- (void)showThreeSelectAlert:(NSString *)msg firstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTittle thirdTitle:(NSString *)thirdTitle alertBlock:(void(^)())alertBlock firstBlock:(void(^)(void))firstBlock secondBlock:(void(^)(void))secondBlock thirdBlock:(void(^)(void))thirdBlock {
    
    dispatch_async(dispatch_get_main_queue(), ^{
      ZZNAlterView *alter = [[ZZNAlterView alloc]initWithTitle:msg contentText:nil leftButtonTitle:firstTitle rightButtonTitle:secondTittle thirdButtonTittle:thirdTitle alertBlock:alertBlock leftBlock:firstBlock rightBlock:secondBlock thirdBlock:thirdBlock];
    
        [alter showThree];
    });
    
    
}
//三个选项的提示
- (void)showThreeSelectAlert:(NSString *)msg firstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTittle thirdTitle:(NSString *)thirdTitle firstBlock:(void(^)(void))firstBlock secondBlock:(void(^)(void))secondBlock thirdBlock:(void(^)(void))thirdBlock {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        ZZNAlterView *alter = [[ZZNAlterView alloc] initWithTitle:L(@"Notice") contentText:msg leftButtonTitle:firstTitle rightButtonTitle:secondTittle thirdButtonTittle:thirdTitle leftBlock:firstBlock rightBlock:secondBlock thirdBlock:thirdBlock];
        [alter showNewGame];
    });
    
    
}
//按钮
- (void)showButtonWithFrame:(CGRect)frame alertBlock:(void(^)())alertBlock;{
    dispatch_async(dispatch_get_main_queue(), ^{
        ZZNAlterView *alter = [[ZZNAlterView alloc]initWithCellFrame:frame alertBlock:alertBlock];
        [alter showButton];
    });
}
//弹出窗口
- (UIViewController*)presentViewControllerOnMainWindow:(Class)viewController {
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    UIViewController* controller = [[viewController alloc] init];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:controller];
    dispatch_async(dispatch_get_main_queue(), ^{
        [window.rootViewController presentViewController:navController animated:YES completion:nil];
    });
    return controller;
}

@end
