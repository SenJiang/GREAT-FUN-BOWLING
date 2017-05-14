//
//  Manager.h
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/11.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import <Foundation/Foundation.h>



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
- (void)writeDataWithArray:(NSArray *)array andName:(NSString *)name;

- (NSArray *)getDataWithIdentifier:(NSString *)name;

- (NSArray *)getAllDataSource;

- (NSArray *)removeAllScore;

- (NSArray *)removeAllScoreAndAllPhotos;
@end
