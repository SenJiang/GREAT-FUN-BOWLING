//
//  ZZNUIManager.h
//  zzn
//
//  Created by WangYa on 15-5-15.
//  Copyright (c) 2015年 DETU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>





//根据RGB自定义颜色
#define ZZN_UI_RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ZZN_UI_RGB_ALPHA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
// 白
#define ZZN_UI_COLOR_WHITE [UIColor whiteColor]

#define ZZNTestColor [UIColor yellowColor]


/******************************BOWLIG*****************************************/
//通知
#define BOWLING_Notification_Screen  @"BOWLING_Notification_Screen"

//橙色字体
#define ZZN_UI_COLOR_ORANGE UIColorFromRGB(0xffc600)

#define ZZN_UI_COLOR_BOWLing_BLUE UIColorFromRGB(0x02a3b4d)

//BOWLIG蓝色背景
#define BOWLING_BACKGROUD_COLOR [UIColor colorWithRed:20/255.0 green:50/255.0 blue:90/255.0 alpha:1.0]
//线条颜色
#define BOWLING_LINE_COLOR [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0]

//第一个分的颜色  35 46 66 蓝灰色
#define BOWLING_FIRST_COLOR [UIColor colorWithRed:19/255.0 green:33/255.0 blue:56/255.0 alpha:0.6]

//第二个分的颜色  140 152 172 灰色
#define BOWLING_SECOND_COLOR [UIColor colorWithRed:140/255.0 green:152/255.0 blue:172/255.0 alpha:1.0]

//横屏排行的颜色  152 173 193 灰色
#define BOWLING_RANK_COLOR [UIColor colorWithRed:152/255.0 green:173/255.0 blue:193/255.0 alpha:1.0]




// 1.7 ===========================================================================
// UI改版
// 棕色字体 & 主题色
#define ZZN_UI_COLOR_BROWN UIColorFromRGB(0x262626)

// 棕色(2f2f2f) 页面背景色
#define ZZN_UI_BACK_COLOR UIColorFromRGB(0x2f2f2f)


#define ZZN_UI_Segm_COLOR UIColorFromRGB(0x444444)
// ==============================================================================

// 黑色
#define ZZN_UI_COLOR_BLACK [UIColor blackColor]
// 背景色
#define ZZN_UI_COLOR_BACKGROUND [UIColor colorWithPatternImage:[UIImage imageNamed:@"zzn_home_background"]]
// 蓝
#define ZZN_UI_COLOR_BLUE [UIColor colorWithRed:0.196 green:0.545 blue:0.682 alpha:1.000]
// 灰白色
#define ZZN_UI_COLOR_WHITE_DARK [UIColor colorWithWhite:0.800 alpha:1.000]

// 橙色(ffbc08) 背景色
//#define ZZN_UI_BACK_COLOR UIColorFromRGB(0xffbc09)

//屏幕宽度
#define ZZN_UI_SCREEN_W [[UIScreen mainScreen] bounds].size.width

//屏幕高度
#define ZZN_UI_SCREEN_H [[UIScreen mainScreen] bounds].size.height
// 测试颜色－随机
#define ZZN_UI_TESTCOLOR  [UIColor randomColor]

//RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define BLWeak     __weak typeof(self)weakSelf = self;

#define BLStrong   __strong typeof(weakSelf)self = weakSelf;

// 字体
#define ZZN_UI_FONT_24 [UIFont systemFontOfSize:24]
#define ZZN_UI_FONT_18 [UIFont systemFontOfSize:18]
#define ZZN_UI_FONT_16 [UIFont systemFontOfSize:16]
#define ZZN_UI_FONT_12 [UIFont systemFontOfSize:12]
#define ZZN_UI_FONT_8 [UIFont systemFontOfSize:8]

//当前是否为iOS9判断
#define iOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)

// 国际化
#define AppLanguage @"appLanguage"

#define CustomLocalizedString(key, comment) \
[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:@"InfoPlist"]



#define L(key) CustomLocalizedString(key, nil)



#define ZZN_LOCALIZED_STRING(key, comment)  CustomLocalizedString(key, comment)
// 通知中心
#define ZZNNotificationCenter [NSNotificationCenter defaultCenter]

// 图片加载完成,透明度从0变成1的时间  ,  视图移动持续事件
extern CFTimeInterval const ZZNAnimationDuration_0d25;
// 指示器显示隐藏动画的持续时间
extern CFTimeInterval const ZZNAnimationDuration_0d5;
// 自动隐藏指示器的持续时间
extern CFTimeInterval const ZZNAnimationDuration_2d0;

// 返回按钮
#define ZZN_UI_BACK_BUTTON(TITLE) ({\
UIButton* button = [[UIButton alloc] init];\
[button setTitle:TITLE forState:UIControlStateNormal];\
[button setTitleColor:ZZN_UI_COLOR_BLUE forState:UIControlStateNormal];\
[button.titleLabel setFont:ZZN_UI_FONT_24];\
[button setImage:[UIImage imageNamed:@"zzn_back_button"] forState:UIControlStateNormal];\
[button setImage:[UIImage imageNamed:@"zzn_back_button"] forState:UIControlStateHighlighted];\
button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, -8);\
button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);\
button;\
})


@interface ZZNUIManager : NSObject
+ (instancetype)sharedInstance;
- (void) configUI;

//弹出提示信息
- (void)showAlertMsg:(NSString *)msg;

//edit show
- (void)eidtShowFirstBlock:(void(^)(void))firstBlock secondBlock:(void(^)(void))secondBlock thirdBlock:(void(^)(void))thirdBlock;


//edit show 三个分选择
- (void)eidtShowFirstBlock:(void(^)(void))firstBlock secondBlock:(void(^)(void))secondBlock thirdBlock:(void(^)(void))thirdBlock threeBlock:(void(^)())threeBlock;

//
- (void)showAlertSelect:(NSString *)msg leftTitle:(NSString*)leftTitle rightTitle:(NSString*)rightTitle leftBlock:(void(^)(void))leftBlock rightBlock:(void(^)(void))rightBlock;

//三个选项的提示
- (void)showThreeSelectAlert:(NSString *)msg firstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTittle thirdTitle:(NSString *)thirdTitle firstBlock:(void(^)(void))firstBlock secondBlock:(void(^)(void))secondBlock thirdBlock:(void(^)(void))thirdBlock;

//四个选项的提示
- (void)showThreeSelectAlert:(NSString *)msg firstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTittle thirdTitle:(NSString *)thirdTitle alertBlock:(void(^)())alertBlock firstBlock:(void(^)(void))firstBlock secondBlock:(void(^)(void))secondBlock thirdBlock:(void(^)(void))thirdBlock;

//5个选项的提示 save
- (void)showThreeSelectAlert:(NSString *)msg  firstBlock:(void(^)())firstBlock secondBlock:(void(^)(void))secondBlock thirdBlock:(void(^)(void))thirdBlock fourBlock:(void(^)(void))fourBlock fiveBlock:(void(^)(void))fiveBlock;
//按钮
- (void)showButtonWithFrame:(CGRect)frame alertBlock:(void(^)())alertBlock;
/**
 *  将某个ViewController显示到主窗口之上
 *
 *  @param viewController 显示的vc的类
 */
- (UIViewController*)presentViewControllerOnMainWindow:(Class)viewController;

@end
