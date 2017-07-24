//
//  UIImage+WZ.h
//  DeTuZZN
//
//  Created by wuze mini on 15/8/12.
//  Copyright (c) 2015年 DETU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WZ)
/**
 *  返回没有渲染的原始图片
 *
 *  @param name 文件名
 */
+ (UIImage *)originalImageWithName:(NSString *)name;

/**
 *  加载项目中的图片
 *
 *  @param name 文件名
 *
 *  @return 一个新的图片对象
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  返回能够自由拉伸不变形的图片
 *
 *  @param name 文件名
 *
 *  @return 能够自由拉伸不变形的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

/**
 *   返回能够自由拉伸不变形的图片
 *
 *  @param name      文件名
 *  @param leftScale 左边需要保护的比例（0~1）
 */
+ (UIImage *)resizedImage:(NSString *)name leftScale:(CGFloat)leftScale topScale:(CGFloat)topScale;
+ (UIImage *)imageWithZZNColor:(UIColor *)color alpha:(float )a;
+ (UIImage *)imageWithColor:(UIColor *)color;

//截图
+ (instancetype)captureWithView:(UIView *)view;
/**
 *  自定义长宽
 *
 *  @param image  需要改变尺寸的图片
 *  @param reSize 目的尺寸
 *
 *
 */
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
@end
