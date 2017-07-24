//
//  Person.h
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/6.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Board : NSObject<NSCopying,NSCoding>

@property (nonatomic,copy)NSString *firstScore;

@property (nonatomic,copy)NSString *secondScore;

@property (nonatomic,copy)NSString *resultScore;

@property (nonatomic, copy)NSString *firstFinish ;

@property (nonatomic, copy)NSString *secondFinish  ;

@property (nonatomic, copy)NSString *threeScore;

@property (nonatomic, copy)NSString *threeFinish;

@property (nonatomic, assign)int areadyBall ;  //X second 需要 1是偏移
@property (nonatomic, assign)int needNumber ;  // 012
@property (nonatomic, assign)int type ;        // 01234567(x/) 



@end

@interface Person : NSObject<NSCopying,NSCoding>

@property (nonatomic, copy)NSString *name;

@property (nonatomic, copy)NSString *image;

@property (nonatomic, copy)NSString *total;

@property (nonatomic, copy)NSString *name_enabled;


@property (nonatomic, strong)NSMutableArray<Board *> *socreData;

//计算总分
+(int)getTotal:(Person *)person;

//游戏是否结束
+(BOOL)isGameEnd:(NSArray *)personArray;

//获取该记哪个分数
-(int)getNeedCacolateBoard:(Person *)person;

//获取比赛人数
+(int)getPersons;

//判断哪一个还需要继续打
+(int)isPersonEnd:(NSArray *)personArr andColumnIndex:(int)columnIndex;

@end
