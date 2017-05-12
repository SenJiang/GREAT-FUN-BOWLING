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
    [[NSUserDefaults standardUserDefaults]setObject:boadData forKey:name];
    [[NSUserDefaults standardUserDefaults]synchronize];
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
    Person *person2 = personArr[1];
    Person *person3 = personArr[2];
    Person *person4 = personArr[3];
    
    person1.socreData = [boardArr1 mutableCopy];
    person2.socreData = [boardArr2 mutableCopy];
    person3.socreData = [boardArr3 mutableCopy];
    person4.socreData = [boardArr4 mutableCopy];
    
    self.allPersonArr = @[person1,person2,person3,person4];
    
    return self.allPersonArr;
}


@end
