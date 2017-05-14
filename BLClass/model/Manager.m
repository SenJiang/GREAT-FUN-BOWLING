//
//  Manager.m
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/11.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import "Manager.h"
#import "Person.h"
@implementation Manager

+ (instancetype) sharedInstance{
    static id obj = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        obj = [[self alloc] init];
    });
    return obj;
    
}


- (void)writeDataWithArray:(NSArray *)array andName:(NSString *)name;{
    NSData *boadData = [NSKeyedArchiver archivedDataWithRootObject:array];
    [[NSUserDefaults standardUserDefaults] setObject:boadData forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (NSArray *)getDataWithIdentifier:(NSString *)name;
{
    NSData *boardData = [[NSUserDefaults standardUserDefaults]objectForKey:name];
    return [NSKeyedUnarchiver unarchiveObjectWithData:boardData];
}
- (NSArray *)getAllDataSource{
    NSArray *boardArr1 = [self getDataWithIdentifier:firstBoard];
    NSArray *boardArr2 = [self getDataWithIdentifier:secondBoard];
    NSArray *boardArr3 = [self getDataWithIdentifier:threeBoard];
    NSArray *boardArr4 = [self getDataWithIdentifier:fourBoard];
    
    NSArray *personArr = [self getDataWithIdentifier:STORAGE];//4个人
    
    Person *person1 = personArr[0];
    int total1 = 0;
    for (int i= 0; i<boardArr1.count; i++) {
        Board *b = boardArr1[i];
        total1 += b.resultScore.intValue;
    }
    if (total1>0) {
        person1.total = [NSString stringWithFormat:@"%d",total1];
    }
    
    
    Person *person2 = personArr[1];
    int total2 = 0;
    for (int i= 0; i<boardArr2.count; i++) {
        Board *b = boardArr2[i];
        total2 += b.resultScore.intValue;
    }
    if (total2>0) {
        person1.total = [NSString stringWithFormat:@"%d",total2];
    }

    Person *person3 = personArr[2];
    int total3 = 0;
    for (int i= 0; i<boardArr3.count; i++) {
        Board *b = boardArr3[i];
        total3 += b.resultScore.intValue;
    }
    if (total3>0) {
        person1.total = [NSString stringWithFormat:@"%d",total3];
    }

    Person *person4 = personArr[3];
    int total4 = 0;
    for (int i= 0; i<boardArr4.count; i++) {
        Board *b = boardArr4[i];
        total4 += b.resultScore.intValue;
    }
    if (total4>0) {
        person1.total = [NSString stringWithFormat:@"%d",total4];
    }

    person1.socreData = [boardArr1 mutableCopy];
    person2.socreData = [boardArr2 mutableCopy];
    person3.socreData = [boardArr3 mutableCopy];
    person4.socreData = [boardArr4 mutableCopy];
    
    self.allPersonArr = @[person1,person2,person3,person4];
    
    return self.allPersonArr;
}

- (NSArray *)removeAllScore{
    
    NSMutableArray *boardArr1 = [NSMutableArray new];
    NSMutableArray *boardArr2 = [NSMutableArray new];
    NSMutableArray *boardArr3 = [NSMutableArray new];
    NSMutableArray *boardArr4 = [NSMutableArray new];
   
    for (int i = 0; i<10; i++) {
        Board *board1 = [[Board alloc]init];
        board1.resultScore = board1.secondScore = board1.threeScore = board1.firstScore = @"";
        [boardArr1 addObject:board1];
        Board *board2 = [[Board alloc]init];
        board2.resultScore = board2.secondScore = board2.threeScore= board2.firstScore = @"";
        [boardArr2 addObject:board2];
        Board *board3 = [[Board alloc]init];
        board3.resultScore = board3.secondScore = board3.threeScore= board3.firstScore = @"";
        [boardArr3 addObject:board1];
        Board *board4 = [[Board alloc]init];
        board4.resultScore = board4.secondScore = board4.threeScore= board4.firstScore = @"";
        [boardArr4 addObject:board4];
        
    }
    
    [[Manager sharedInstance] writeDataWithArray:boardArr1 andName:firstBoard];
    [[Manager sharedInstance] writeDataWithArray:boardArr2 andName:secondBoard];
    [[Manager sharedInstance] writeDataWithArray:boardArr3 andName:threeBoard];
    [[Manager sharedInstance] writeDataWithArray:boardArr4 andName:fourBoard];
    
    NSMutableArray *personArr = [NSMutableArray new];
    for (int i = 0; i<4; i++) {
        Person *person = self.allPersonArr[i];
        if (i == 0) {
           
             person.socreData = boardArr1;
        }else if(i == 1){
            person.socreData = boardArr2;
        }else if (i == 2){
            person.socreData = boardArr3;
        }else if (i == 3){
            person.socreData = boardArr3;
        }
        person.total = @"";
        [personArr addObject:person];
    }
    self.allPersonArr = personArr;
    return personArr;

}

- (NSArray *)removeAllScoreAndAllPhotos{
    NSMutableArray *boardArr1 = [NSMutableArray new];
    NSMutableArray *boardArr2 = [NSMutableArray new];
    NSMutableArray *boardArr3 = [NSMutableArray new];
    NSMutableArray *boardArr4 = [NSMutableArray new];
    
    for (int i = 0; i<10; i++) {
        Board *board1 = [[Board alloc]init];
        board1.resultScore = board1.secondScore = board1.firstScore = @"";
        [boardArr1 addObject:board1];
        Board *board2 = [[Board alloc]init];
        board2.resultScore = board2.secondScore = board2.firstScore = @"";
        [boardArr2 addObject:board2];
        Board *board3 = [[Board alloc]init];
        board3.resultScore = board3.secondScore = board3.firstScore = @"";
        [boardArr3 addObject:board1];
        Board *board4 = [[Board alloc]init];
        board4.resultScore = board4.secondScore = board4.firstScore = @"";
        [boardArr4 addObject:board4];
        
    }
    
    [[Manager sharedInstance] writeDataWithArray:boardArr1 andName:firstBoard];
    [[Manager sharedInstance] writeDataWithArray:boardArr2 andName:secondBoard];
    [[Manager sharedInstance] writeDataWithArray:boardArr3 andName:threeBoard];
    [[Manager sharedInstance] writeDataWithArray:boardArr4 andName:fourBoard];
    
    NSMutableArray *personArr = [NSMutableArray new];
    for (int i = 0; i<4; i++) {
        Person *person = self.allPersonArr[i];
      
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/bowling%d.png",i]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
        
        if (i == 0) {
            person.socreData = boardArr1;
        }else if(i == 1){
            person.socreData = boardArr2;
        }else if (i == 2){
            person.socreData = boardArr3;
        }else if (i == 3){
            person.socreData = boardArr3;
        }
        person.image = [NSString stringWithFormat:@"%d",i];
        person.name = [NSString stringWithFormat:@"P%d",i+1];
        person.total = @"";
        [personArr addObject:person];
    }
    [self writeDataWithArray:personArr andName:STORAGE];
    self.allPersonArr = personArr;
    return personArr;
}

@end
