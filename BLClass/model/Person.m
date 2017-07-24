//
//  Person.m
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/6.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import "Person.h"
#import "Manager.h"
@implementation Board
-(id)copyWithZone:(NSZone *)zone
{
    Board *board = [self.class allocWithZone:zone];
    board.firstScore = [self.firstScore copyWithZone:zone];
    board.secondScore = [self.secondScore copyWithZone:zone];
    board.resultScore = [self.resultScore copyWithZone:zone];
    board.firstFinish = [self.firstFinish copyWithZone:zone];
    board.secondFinish = [self.secondFinish copyWithZone:zone];
    board.threeScore = [self.threeScore copyWithZone:zone];
    board.threeFinish = [self.threeFinish copyWithZone:zone];
    return board;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.firstScore = [aDecoder decodeObjectForKey:@"firstScore"];
        self.secondScore = [aDecoder decodeObjectForKey:@"secondScore"];
        self.resultScore = [aDecoder decodeObjectForKey:@"resultScore"];
        self.firstFinish = [aDecoder decodeObjectForKey:@"firstFinish"];
        self.secondFinish = [aDecoder decodeObjectForKey:@"secondFinish"];
        self.threeScore = [aDecoder decodeObjectForKey:@"threeScore"];
        self.threeFinish = [aDecoder decodeObjectForKey:@"threeFinish"];

    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.firstScore forKey:@"firstScore"];
    [aCoder encodeObject:self.secondScore forKey:@"secondScore"];
    [aCoder encodeObject:self.resultScore forKey:@"resultScore"];
    [aCoder encodeObject:self.firstFinish forKey:@"firstFinish"];
    [aCoder encodeObject:self.secondFinish forKey:@"secondFinish"];
    [aCoder encodeObject:self.threeScore forKey:@"threeScore"];
    [aCoder encodeObject:self.threeFinish forKey:@"threeFinish"];
}
@end
@implementation Person
-(id)copyWithZone:(NSZone *)zone
{
    Person *person = [self.class allocWithZone:zone];
    person.name = [self.name copyWithZone:zone];
    person.image = [self.image copyWithZone:zone];
    person.total = [self.total copyWithZone:zone];
    person.name_enabled = [self.name_enabled copyWithZone:zone];
    return person;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.total = [aDecoder decodeObjectForKey:@"total"];
        self.name_enabled = [aDecoder decodeObjectForKey:@"name_enabled"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.total forKey:@"total"];
    [aCoder encodeObject:self.name_enabled forKey:@"name_enabled"];
}
//计算总分
+(int)getTotal:(Person *)person{
    
    int total = 0;
    for (int i= 0; i<person.socreData.count; i++) {
        Board *board  = person.socreData[i];
        total += board.resultScore.intValue;
    }
    return total;
};

+(BOOL)isGameEnd:(NSArray *)personArray{
    BOOL ret = YES;
    
    for (int i= 0; i<[Manager sharedInstance].nums; i++) {
        Person *per  = personArray[i];
        for (int j = 0; j<per.socreData.count; j++) {
            Board *board = per.socreData[j];
            if ([board.resultScore isEqualToString:@""]) {
                ret = NO;
                break;
            }
        }
    }
    
    if (ret) {
        NSComparator cmptr = ^(Person *obj1, Person *obj2){
            
            if ([obj1.total integerValue] > [obj2.total integerValue]) {
                
                return (NSComparisonResult)NSOrderedAscending;
                
            }
            
            if ([obj1.total integerValue] < [obj2.total integerValue]) {
                
                return (NSComparisonResult)NSOrderedDescending;
                
            }
            return (NSComparisonResult)NSOrderedSame;
            
        };
        
        NSArray *array = [personArray sortedArrayUsingComparator:cmptr];
        Person * per = [array firstObject];
        [Manager sharedInstance].winnner_name = per.name;
        //判断跟第一名平分
        for (int i = 1 ; i<array.count; i++) {
            Person *samePer = array[i];
            if ([samePer.total isEqualToString:per.total]) {
                [Manager sharedInstance].winnner_name = [NSString stringWithFormat:@"%@,%@",[Manager sharedInstance].winnner_name,samePer.name];
            }
        }
        [[Manager sharedInstance] writeAllDataWithArray:array];
     }
    
    
    return ret;
}

-(int)getNeedCacolateBoard:(Person *)person{
    int row = 0;
    for (int i=0; i<person.socreData.count; i++) {
        Board *bbb = person.socreData[i];
        
        if (([bbb.resultScore isEqualToString:@""] && ![bbb.firstFinish isEqualToString:@"yes"])||(bbb.firstScore.intValue !=6 && ![bbb.secondFinish isEqualToString:@"yes"])) {
            row = i;
            break;
        }
        if (i==9) {
            if ([bbb.resultScore isEqualToString:@""] ) {
                row = i;
            }
        }
    }
    return row;
}

+(int)getPersons//获取比赛人数
{
    NSArray * arr = [[Manager sharedInstance]  getDataWithIdentifier:STORAGE];
    int num = 1;
    for (int i = 1; i<4; i++) {
        Person *per = arr[i];
      num =  [per.name isEqualToString:[NSString stringWithFormat:@"Player %d",i+1]]? num:++num;
    }
    [Manager sharedInstance].nums = num;;
    return num;
}
+(int)isPersonEnd:(NSArray *)personArr andColumnIndex:(int)columnIndex{
    int ret = 0;
    //判断这个是否打完
    Person *person = personArr[columnIndex];
    for (int i=0; i<person.socreData.count; i++) {
        Board *board = person.socreData[i];
        if ([board.resultScore isEqualToString:@""]) {
            return  columnIndex;
        }
    }
    
    //判断这个以下是否打完
    for (int j=  columnIndex; j<[Manager sharedInstance].nums; j++) {
        
        Person *person1 = personArr[j];
        for (int i=0; i<person1.socreData.count; i++) {
            Board *board = person1.socreData[i];
            if ([board.resultScore isEqualToString:@""]) {
                return  j;
            }
        }
    }
    
    //判断这个以上是否打完
    for (int j=  0; j<columnIndex; j++) {
        
        Person *person1 = personArr[j];
        for (int i=0; i<person1.socreData.count; i++) {
            Board *board = person1.socreData[i];
            if ([board.resultScore isEqualToString:@""]) {
                return  j;
            }
        }
    }
    
    return ret;
}
@end

