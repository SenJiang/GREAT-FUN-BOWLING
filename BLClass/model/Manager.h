//
//  Manager.h
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/11.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"


#define firstBoard  @"STORAGE_boardData"
#define STORAGE    @"STORAGE_personData"

#define secondBoard     @"STORAGE_Second_boardData"
//#define secondPerson    @"STORAGE_second_personData"

#define threeBoard     @"STORAGE_Three_boardData"
//#define threePerson    @"STORAGE_Three_personData"

#define fourBoard     @"STORAGE_Four_boardData"
//#define fourPerson    @"STORAGE_Four_personData"

typedef enum {
    well_done   = 1,
    bravo_three = 2,
    fantastic   = 3,
    game_end    = 4,
    result      = 5,
    bravo       = 6,
    good_job    = 7,
}showIndex;

@interface Manager : NSObject
+ (instancetype) sharedInstance;
@property (nonatomic,strong)NSArray *personArr;

@property (nonatomic,strong)NSArray *allPersonArr;

@property (nonatomic,assign)BOOL  horizontal;//横屏

@property (nonatomic,assign)int  nums;  //参与比赛的人数

@property (nonatomic, copy)NSString *winnner_name;

- (void)writeDataWithArray:(NSArray *)array andName:(NSString *)name;

- (void)writeAllDataWithArray:(NSArray *)array;

- (NSArray *)getDataWithIdentifier:(NSString *)name;

- (NSArray *)getAllDataSource;

//删除所有的分数
- (NSArray *)removeAllScore;

- (NSArray *)removeAllScoreAndAllPhotos;
//计算分数
- (Person *)caculateScore:(int)index;
@end
