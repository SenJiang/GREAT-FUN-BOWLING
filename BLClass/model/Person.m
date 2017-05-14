//
//  Person.m
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/6.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import "Person.h"

@implementation Board
-(id)copyWithZone:(NSZone *)zone
{
    Board *board = [self.class allocWithZone:zone];
    board.firstScore = [self.firstScore copyWithZone:zone];
    board.secondScore = [self.secondScore copyWithZone:zone];
    board.resultScore = [self.resultScore copyWithZone:zone];
    board.firstFinish = [self.firstFinish copyWithZone:zone];
    board.firstFinish = [self.secondFinish copyWithZone:zone];
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
}
@end
@implementation Person
-(id)copyWithZone:(NSZone *)zone
{
    Person *person = [self.class allocWithZone:zone];
    person.name = [self.name copyWithZone:zone];
    person.image = [self.image copyWithZone:zone];
    person.total = [self.total copyWithZone:zone];

    return person;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.total = [aDecoder decodeObjectForKey:@"total"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.total forKey:@"total"];
}

@end

