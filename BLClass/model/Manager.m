//
//  Manager.m
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/11.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import "Manager.h"
@implementation Manager

+ (instancetype) sharedInstance{
    static id obj = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        obj = [[self alloc] init];
    });
    return obj;
    
}
-(void)setAllPersonArr:(NSArray *)allPersonArr

{
    _allPersonArr = allPersonArr;
}

- (void)writeDataWithArray:(NSArray *)array andName:(NSString *)name{
    NSData *boadData = [NSKeyedArchiver archivedDataWithRootObject:array];
    [[NSUserDefaults standardUserDefaults] setObject:boadData forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (void)writeAllDataWithArray:(NSArray *)array
{
    for (int i=0; i<array.count; i++) {
        Person *per = array[i];
        if (i==0) {
            [self writeDataWithArray:per.socreData andName:firstBoard];
        }else if (i==1){
            [self writeDataWithArray:per.socreData andName:secondBoard];
        }else if (i==2){
            [self writeDataWithArray:per.socreData andName:threeBoard];
        }else if (i==3){
            [self writeDataWithArray:per.socreData andName:fourBoard];
        }
    }
    [self writeDataWithArray:array andName:STORAGE];
    self.allPersonArr = array;
}
- (NSArray *)getDataWithIdentifier:(NSString *)name
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
     NSMutableArray *persons = [NSMutableArray new];
    for (int i=0; i<personArr.count ; i++) {
        Person *per = personArr[i];
        if (i==0) {
            per.socreData = [boardArr1 mutableCopy];
        }else if (i==1){
            per.socreData = [boardArr2 mutableCopy];
        }else if (i==2){
            per.socreData = [boardArr3 mutableCopy];
        }else if (i==3){
            per.socreData = [boardArr4 mutableCopy];
        }
        [persons addObject:per];
    }
    self.allPersonArr = persons;
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
        [boardArr3 addObject:board3];
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
            person.socreData = boardArr4;
        }
        person.total = @"";
        [personArr addObject:person];
    }
    [[Manager sharedInstance] writeDataWithArray:personArr andName:STORAGE];
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
        board1.resultScore = board1.secondScore = board1.firstScore = board1.threeScore = @"";
        [boardArr1 addObject:board1];
        Board *board2 = [[Board alloc]init];
        board2.resultScore = board2.secondScore = board2.firstScore = board2.threeScore = @"";
        [boardArr2 addObject:board2];
        Board *board3 = [[Board alloc]init];
        board3.resultScore = board3.secondScore = board3.firstScore = board3.threeScore = @"";
        [boardArr3 addObject:board3];
        Board *board4 = [[Board alloc]init];
        board4.resultScore = board4.secondScore = board4.firstScore = board4.threeScore = @"";
        [boardArr4 addObject:board4];
        
    }
    
    [[Manager sharedInstance] writeDataWithArray:boardArr1 andName:firstBoard];
    [[Manager sharedInstance] writeDataWithArray:boardArr2 andName:secondBoard];
    [[Manager sharedInstance] writeDataWithArray:boardArr3 andName:threeBoard];
    [[Manager sharedInstance] writeDataWithArray:boardArr4 andName:fourBoard];
    
    NSMutableArray *personArr = [NSMutableArray new];
    for (int i = 0; i<4; i++) {
        Person *person = [[Person alloc]init];
        person.name_enabled = @"";
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/bowling%d.png",i]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
        
        if (i == 0) {
            person.socreData = boardArr1;
            person.name_enabled = @"yes";
        }else if(i == 1){
            person.socreData = boardArr2;
        }else if (i == 2){
            person.socreData = boardArr3;
        }else if (i == 3){
            person.socreData = boardArr4;
        }
        person.image = [NSString stringWithFormat:@"%d",i];
        person.name = [NSString stringWithFormat:@"Player %d",i+1];
       
        person.total = @"";
        
        [personArr addObject:person];
    }
    [self writeDataWithArray:personArr andName:STORAGE];
    self.allPersonArr = personArr;
    return personArr;
}
//计算分数
- (Person *)caculateScore:(int)index
{
    Person * per = self.allPersonArr[index];
    
    for(int i=0;i<per.socreData.count;i++)
    {
        Board *boad = per.socreData[i];
        boad.resultScore = [NSString stringWithFormat:@""];
        
    }
    
    Board * b0 = per.socreData[0];
    if(b0.firstScore !=nil)
    {
        //本路有分数了
        for(int i=0;i<10;i++) {
            Board * b = per.socreData[i];
            if (b.firstScore.intValue == 6) {
                //不计算得分先
                //score.score_m[i] = 6+"";//先得分
                b.resultScore = [NSString stringWithFormat:@"6"];
                int ib=i-1;
                if(ib>=0)
                {
                    //检查前一个是不是X
                    Board * Ib = per.socreData[ib];
                    if(Ib.firstScore.intValue == 6)
                    {
                        int scoret = Ib.resultScore.intValue;
                        scoret+=6;//加多一倍得分
                        //score.score_m[ib]=scoret+"";
                        Ib.resultScore = [NSString stringWithFormat:@"%d", scoret];
                        int ib2=i-2;
                        if(ib2>=0) {
                            Board * Ib2 = per.socreData[ib2];
                            //检查前2个是不是X
                            if (Ib2.firstScore.intValue == 6) {
                                // int scoret1 = IntegerparseInt(score.score_m[ib2]);
                                int scoret1 = Ib2.resultScore.intValue;
                                scoret1 += 6;//再加多一倍得分
                                //score.score_m[ib2]=scoret1+"";
                                Ib2.resultScore = [NSString stringWithFormat:@"%d", scoret1];
                            }
                        }
                    }
                    if(Ib.secondScore.intValue == 7)//(/)
                    {
                        //int scoret = IntegerparseInt(score.score_m[ib]);
                        int scoret = Ib.resultScore.intValue;
                        scoret+=6;//加多一倍得分
                        //score.score_m[ib]=scoret+"";
                        Ib.resultScore = [NSString stringWithFormat:@"%d", scoret];
                    }
                }
                //如果第10组分数的左是x右边是数字
                Board * b9 = per.socreData[9];
                if(i==9)
                {
                    int scoreG10[3]={};
                    scoreG10[0]=b9.resultScore.intValue;
                    
                    if(b9.secondScore.intValue == 6)
                    {
                        //XXX
                        scoreG10[0]+=6;//再添6分
                        ////scoreG10[1]=6;
                        
                        Board * Ib8 = per.socreData[8];
                        int scoret = Ib8.resultScore.intValue;
                        scoret += 6;//b8再添6分
                        Ib8.resultScore = [NSString stringWithFormat:@"%d", scoret];
                        
                        
                        if(b9.threeScore.intValue == 6)
                        {
                            scoreG10[0]+=6;//再添6分
                            ////scoreG10[1]+=6;
                            // //scoreG10[2]=6;
                            
                        }
                    }else{
                        //X??
                        
                        if(b9.threeScore.intValue == 7)//最后补中了就直接得6分
                        {
                            scoreG10[1]=6;
                            scoreG10[2]=0;
                        }else
                        {
                            //scoreG10[1]=IntegerparseInt(score.score_r[9]);
                            //scoreG10[2]=IntegerparseInt(score.score_r[10]);
                            scoreG10[1]=b9.secondScore.intValue;
                            scoreG10[2]=b9.threeScore.intValue;
                            
                        }
                        Board * Ib8 = per.socreData[8];
                        int scoret = Ib8.resultScore.intValue;
                        scoret += b9.secondScore.intValue;//b8再添b9.secondScore分
                        Ib8.resultScore = [NSString stringWithFormat:@"%d", scoret];
                        
                    }
                    int sum=scoreG10[0]+scoreG10[1]+scoreG10[2];
                    
                    //score.score_m[9]=sum+"";
                    b9.resultScore = [NSString stringWithFormat:@"%d", sum];
                }
                
            } else {
                
                int lscore = b.firstScore.intValue;
                int rscore = 0;
                if (b.secondScore.intValue == 7) {
                    rscore=6-lscore;
                    if(i==9)
                    {
                        Board * b9 = per.socreData[9];
                        if(b.secondScore.intValue == 6)
                        {
                            rscore+=6;
                        }
                        else
                        {
                            //rscore+=IntegerparseInt(score.score_r[10]);
                            rscore += b9.threeScore.intValue;
                        }
                    }
                } else {
                    //rscore = IntegerparseInt(score.score_r[i]);
                    rscore = b.secondScore.intValue;
                }
                
                int sum=lscore+rscore;
                //score.score_m[i] = sum + "";
                b.resultScore = [NSString stringWithFormat:@"%d", sum];
                
                int ib=i-1;
                if(ib>=0)
                {
                    //检查前一个是不是X
                    Board * Ib = per.socreData[ib];
                    if(Ib.firstScore.intValue == 6)
                    {
                        //int scoret = IntegerparseInt(score.score_m[ib]);
                        int scoret =Ib.resultScore.intValue;
                        if(ib == 8)//当第十组前两个得分不为x时，第九组的总分只加上第十组的前两次得分
                        {
                             if(b.secondScore.intValue == 7)
                             {
                                 scoret += 6;
                             }else
                             {
                                 scoret += (b.firstScore.intValue + b.secondScore.intValue);
                             }
                        }else
                        {
                            scoret+=sum;//奖一组得分
                        }
                        //score.score_m[ib]=scoret+"";
                        
                        Ib.resultScore = [NSString stringWithFormat:@"%d", scoret];
                        
                        //再检查前面2个是不是x
                        int ib2=i-2;
                        if(ib2>=0)
                        {
                            Board * Ib2 = per.socreData[ib2];
                            if(Ib2.firstScore.intValue == 6) {
                                //scoret = IntegerparseInt(score.score_m[ib2]);
                                scoret = Ib2.resultScore.intValue;
                                scoret+=lscore;//再奖一组得分
                                //score.score_m[ib2]=scoret+"";
                                Ib2.resultScore = [NSString stringWithFormat:@"%d", scoret];
                            }
                        }
                        
                    }
                    if(Ib.secondScore.intValue == 7)
                    {
                        //int scoret = IntegerparseInt(score.score_m[ib]);
                        int scoret =Ib.resultScore.intValue;
                        scoret+=lscore;//奖前一半得分()
                        //score.score_m[ib]=scoret+"";
                        Ib.resultScore = [NSString stringWithFormat:@"%d", scoret];
                    }
                }
                
            }
        }
    }
    
    //private void cover_score(player score) {
    //先处理第十组
    Board * b8 = per.socreData[8];
    Board * b9 = per.socreData[9];
    //Board * b10 = per.socreData[10];
    if(b9.firstScore.intValue == 6)//x后面有数才显示
    {
        if(([b9.secondScore isEqualToString:@""])||([b9.threeScore isEqualToString:@""]))
        {
            //score.score_m[9]="";
            // b9.resultScore = "";
            //b9.resultScore = [NSString stringWithFormat:@""];
            b9.resultScore = [NSString stringWithFormat:@""];
        }
    }else {
        if (b9.secondScore.intValue == 7)//?/后面有数才显示
        {
            if ([b9.threeScore isEqualToString:@""]) {
                //score.score_m[9] = "";
                //b9.resultScore = "";
                //b9.resultScore = nil;
                b9.resultScore = [NSString stringWithFormat:@""];
            }
        }else {
            if (([b9.secondScore isEqualToString:@""]) && (b9.firstScore.intValue != 6))//第一球非X,打两球才显示
            {
                //score.score_m[9] = "";
                //b9.resultScore = nil;
                b9.resultScore = [NSString stringWithFormat:@""];
                
            }
        }
    }
    
    
    if(b8.firstScore.intValue == 6)//x后面有数才显示
    {
        if(([b9.firstScore isEqualToString:@""])||([b9.secondScore isEqualToString:@""]))
        {
            //score.score_m[8]="";
            //b8.resultScore = nil;
            b8.resultScore = [NSString stringWithFormat:@""];
        }
    }else {
        if (b8.secondScore.intValue == 7)//?/后面有数才显示
        {
            if (b9.firstScore == nil) {
                //score.score_m[8] = "";
                // b8.resultScore = nil;
                b8.resultScore = [NSString stringWithFormat:@""];
            }
        }else {
            if (([b8.secondScore isEqualToString:@""]) && (b8.firstScore.intValue !=6))//第一球非X,打两球才显示
            {
                //score.score_m[8] = "";
                //b8.resultScore = nil;
                b8.resultScore = [NSString stringWithFormat:@""];
            }
        }
    }
    
    for(int i=0;i<8;i++)
    {
        Board * bp = per.socreData[i];
        Board * bp1 = per.socreData[i+1];
        Board * bp2 = per.socreData[i+2];
        
        if(bp.firstScore.intValue == 6)//x后面有数才显示
        {
            if(bp1.firstScore.intValue == 6)//x后面是x 再要下一组是x
            {
                if([bp2.firstScore isEqualToString:@""])//x后面是x 再要下一组非空
                {
                    //score.score_m[i] = "";
                    //bp.resultScore = nil;
                    bp.resultScore = [NSString stringWithFormat:@""];
                }
            }else {
                if (([bp1.firstScore isEqualToString:@""]) || ([bp1.secondScore isEqualToString:@""])) {//x 下一个不是x 但没有数据，不显示result
                    //score.score_m[i] = "";
                    //bp.resultScore = nil;
                    bp.resultScore = [NSString stringWithFormat:@""];
                }
            }
        }else {
            if (bp.secondScore.intValue == 7)//?/后面有数才显示
            {
                if ([bp1.firstScore isEqualToString:@""]) {
                    //score.score_m[i] = "";
                    //bp.resultScore = nil;
                    bp.resultScore = [NSString stringWithFormat:@""];
                }
            }else
            {
                if (([bp.secondScore isEqualToString:@""]) && (bp.firstScore.intValue != 6))//第一球非X,打两球才显示
                    
                {
                    //score.score_m[i] = "";
                    //bp.resultScore = nil;
                    bp.resultScore = [NSString stringWithFormat:@""];
                }
            }
        }
    }
    return per;
    
}
@end
