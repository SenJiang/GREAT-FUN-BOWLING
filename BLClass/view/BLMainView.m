//
//  BLMainView.m
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/4.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import "BLMainView.h"
#import "ZZNUIManager.h"
#import "ScoreCollectionViewCell.h"
#import "Masonry.h"
#import "Person.h"
#import "ScoreBoardView.h"
#import "Manager.h"
@interface BLMainView ()<UICollectionViewDelegate,UICollectionViewDataSource,ScoreBoardViewDelegate>



@property(nonatomic,strong) ScoreBoardView *scoreViewBut;//按钮view

@property(nonatomic,strong) UIControl *buttonContro;     //放按钮view的容器

@property(nonatomic,assign) BOOL isShowButton;

@property(nonatomic,strong) NSIndexPath *indexPath; //刷新分数
@property(nonatomic,assign) NSUInteger rowIndex;    // 当前横向点击的第几个cell
@property(nonatomic,assign) NSUInteger columnIndex; // 当前纵向点击的第几个cell
@end

@implementation BLMainView

//5686 5726


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60, ZZN_UI_SCREEN_W, ZZN_UI_SCREEN_H-100) collectionViewLayout:layout];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.bounces = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.scrollEnabled = NO;
        [collectionView registerNib:[UINib nibWithNibName:@"ScoreCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"scoreCell"];
        [self addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@40);
            make.right.equalTo(@0);
            make.left.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        //适配5s
        if (ZZN_UI_SCREEN_W < 350) {
            [collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@20);
                make.right.equalTo(@0);
                make.left.equalTo(@0);
                make.bottom.equalTo(@0);
            }];
        }
        
        _collectionView = collectionView;
        
    }
    return self;
}

-(void)setScoreArray:(NSArray *)scoreArray
{
    _scoreArray = scoreArray;
    [self reload];
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.scoreArray.count;
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ScoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"scoreCell" forIndexPath:indexPath];
    
    Person *person = self.scoreArray[indexPath.row];
    cell.person = person;
    cell.dataSource = person.socreData;
    __weak typeof(self)weakSelf = self;
    
    //点击照片的回调
    cell.cellBlock = ^(ScoreCollectionViewCell *scoreCell , int select){
      __strong typeof(weakSelf)self = weakSelf;
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:scoreCell];

        if (self.photoBlock) {
            self.photoBlock(scoreCell,(int)indexpath.row,select);
        }
    };
    
    //点击tableviewCell的回调
    
    cell.tabVCellBlock = ^(ScoreCollectionViewCell *scoreCell ,CGRect frame,int row){
        __strong typeof(weakSelf)self = weakSelf;

        self.columnIndex = indexPath.row;
        self.rowIndex = row;
        self.indexPath = [collectionView indexPathForCell:scoreCell];
            self.isShowButton = YES;
            if (indexPath.row!=0) {
                //第二 三 四 个记分板好像没做
                return ;
            }
        
        Person *person0 = [Manager sharedInstance].allPersonArr[self.columnIndex];
        Board *board = person0.socreData[row];
        if (row>0&&row<9) {
            //上一个没完成且下一个为空不能点击后面的
            Board *boardFront = person0.socreData[row-1];
            Board *boardLast = person0.socreData[row+1];
            if (![boardFront.secondFinish isEqualToString:@"yes"] &&![boardLast.secondFinish isEqualToString:@""]) {
                return;
            }
        }
        
        if ([board.firstFinish isEqualToString:@"yes"]) {
            
            [[ZZNUIManager sharedInstance]eidtShowFirstBlock:^{
               
            [self click:1 WithScoreButtonView:scoreCell.frame Arrowframe:frame cellRow:row board:board];
                
            } secondBlock:^{
                [self click:2 WithScoreButtonView:scoreCell.frame Arrowframe:frame cellRow:row board:board];                } thirdBlock:^{
                
            }];
            return;
            

        }else{
            [self initScoreButtonView:scoreCell.frame Arrowframe:frame cellRow:row board:board];
        }
    };
    return cell;
}


// 上左下右
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //适配5s
    if (ZZN_UI_SCREEN_W < 350) {
        return UIEdgeInsetsMake(0, 10, 0, 10) ;
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
// 每一个item之间的最小间距:
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
// 每一行item之间的最小间距:
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
// 每一个item的大小:
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //适配5s
    if (ZZN_UI_SCREEN_W < 350) {
       return  CGSizeMake(ZZN_UI_SCREEN_W-20, (self.frame.size.height-self.frame.origin.y-35)/4);
    }
    
    return CGSizeMake(ZZN_UI_SCREEN_W-20, (self.frame.size.height-self.frame.origin.y-35-30)/4);
}

- (void)reload{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
}

- (void)hideButtonView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.scoreViewBut removeFromSuperview];
        [self.buttonContro removeFromSuperview];
    });
   
    
}
- (void)showButtonView{
    if (self.isShowButton) {
        self.scoreViewBut.hidden = NO;
        self.buttonContro.hidden = NO;
    }
}
//TODO:点击first 和second  重新记分 select == 1 点击第一个， select ＝ 2点击了第二个
- (void)click:(int)select WithScoreButtonView :(CGRect )cellFrame Arrowframe:(CGRect)ArrowFrame cellRow:(int)row board:(Board *)board{
    
    Person * per = self.scoreArray[self.columnIndex];
    Board * ball =  per.socreData[row];
    if (select == 1) {
        //清空第一个
        ball.firstScore = @"";
        
        ball.firstFinish = @"";
       
    }else{
        ball.areadyBall = 1;
    }
    ball.secondScore = @"";
    ball.secondFinish = @"";
    ball.resultScore = @"";
    NSString *storeName = @"";
    if (self.columnIndex == 0) {
        storeName = firstBoard;
    }else if(self.columnIndex == 1){
        storeName = secondBoard;
    }else if (self.columnIndex == 2){
        storeName = threeBoard;
    }else if (self.columnIndex == 3){
        storeName = fourBoard;
    }
    
    
    //写入数据
    [[Manager sharedInstance] writeDataWithArray:per.socreData andName:storeName];
    
    //刷新UI
    ScoreCollectionViewCell * cell = (ScoreCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.indexPath];
    cell.dataSource = per.socreData;
    
    
    [self initScoreButtonView:cellFrame Arrowframe:ArrowFrame cellRow:row board:ball];
}

//创建新的button view
- (void)initScoreButtonView :(CGRect )cellFrame Arrowframe:(CGRect)ArrowFrame cellRow:(int)row board:(Board *)board{
    if (self.buttonContro || self.scoreViewBut) {
        [self hideButtonView];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.buttonContro = [[UIControl alloc]initWithFrame:self.frame];
        [self.buttonContro addTarget:self action:@selector(hideButtonView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.buttonContro];
        self.scoreViewBut = [[ScoreBoardView alloc]initWithFrame:cellFrame ArrowFrame:ArrowFrame  cellRow:row board:board];
        [self.buttonContro addSubview:self.scoreViewBut];
        self.scoreViewBut.delegate = self;
        
    });
    
}

#pragma mark - ScoreBoardViewDelegate
- (void)clickBtnRefreshWith:(ButtonModel *)btnModel{
    
    //不能大于10个
    if (btnModel.row>=10) {
        return;
    }
    //干得漂亮
    if (btnModel.buttonTag == bravo) {
        if (self.greatShowCall) {
            self.greatShowCall(bravo);
        }
    }else if (btnModel.buttonTag == good_job){
        if (self.greatShowCall) {
            self.greatShowCall(good_job);
        }
    }
    Person * per = self.scoreArray[self.columnIndex];
    Board * ball =  per.socreData[btnModel.row];
    if (![ball.firstFinish isEqualToString:@"yes"]) {
        //第一次打球
        ball.firstScore = [NSString stringWithFormat:@"%d",btnModel.buttonTag];
        if (btnModel.buttonTag == 6) {
            ball.secondScore = nil;
            ball.firstFinish = @"yes";
            ball.secondFinish = @"yes";
            
        }else{
            ball.firstFinish = @"yes";
        }
    }else{
        //第二次打完球 记分
        ball.secondScore = [NSString stringWithFormat:@"%d",btnModel.buttonTag];
        ball.secondFinish = @"yes";
        ball.resultScore = [NSString stringWithFormat:@"%d",ball.firstScore.intValue + ball.secondScore.intValue];
        
    }
    
//TODO:开始计算分数
    per =  [self caculateScore];
    
    
    //替换数据用来保存
//    [per.socreData replaceObjectAtIndex:btnModel.row withObject:ball];
    
    //存取的 key
    NSString *storeName = @"";
    if (self.columnIndex == 0) {
        storeName = firstBoard;
    }else if(self.columnIndex == 1){
        storeName = secondBoard;
    }else if (self.columnIndex == 2){
        storeName = threeBoard;
    }else if (self.columnIndex == 3){
        storeName = fourBoard;
    }
    //写入数据
    [[Manager sharedInstance] writeDataWithArray:per.socreData andName:storeName];
    
        //刷新UI
    ScoreCollectionViewCell * cell = (ScoreCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.indexPath];
    cell.dataSource = per.socreData;
    int total = 0;
    total = [Person getTotal:per];
    if (total>0) {
        cell.label_totalScore.text = [NSString stringWithFormat:@"%d",total];
    }
    
    if ([Person isGameEnd:per]) {
        if (self.greatShowCall) {
            //游戏结束
            [self hideButtonView];
            self.greatShowCall(game_end);
            return;
        }
    }

    //打完一组就换下一组
    if ([ball.secondFinish isEqualToString:@"yes"]&&(btnModel.row < 9)) {
        btnModel.row ++;
        ball = per.socreData[btnModel.row];
        for (int i=0; i<per.socreData.count; i++) {
            Board *bb = per.socreData[i];
            if (![bb.firstFinish isEqualToString:@"yes"] || ![bb.secondFinish isEqualToString:@"yes"]) {
                btnModel.row = i;
                break;
            }
           
        }
    }
  
    
    
    
    if (btnModel.row>=2) {
        [cell.tableView_mark scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:btnModel.row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    
    
    [self hideButtonView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.buttonContro = [[UIControl alloc]initWithFrame:self.frame];
        [self.buttonContro addTarget:self action:@selector(hideButtonView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.buttonContro];
        self.scoreViewBut = [[ScoreBoardView alloc]initWithFrame:btnModel.cellFrame   ArrowFrame:btnModel.arrowFrame  cellRow:btnModel.row board:ball];
        self.scoreViewBut.delegate = self;
        [self.buttonContro addSubview:self.scoreViewBut];

    });
    
}


- (Person *)caculateScore
{
    Person * per = self.scoreArray[self.columnIndex];
    /* Board * ball =  per.socreData[_rowIndex];
     
     
     for (int i = 0; i <per.socreData.count ; i ++) {
     Board * b = per.socreData[i];
     if (b.areadyBall == 0) {
     break;
     }
     else if (b.areadyBall == 1) {
     b.firstScore = [NSString stringWithFormat:@"%d", b.type];
     }
     else if (b.type == 0) {
     b.secondScore = [NSString stringWithFormat:@""];
     }
     
     ball = [self caculateTotalScore:i];
     }
     if(res)res(ball);*/
    
    for(int i=0;i<per.socreData.count;i++)
    {
        Board *boad = per.socreData[i];
        //boad.resultScore = nil;
        boad.resultScore = [NSString stringWithFormat:@""];
        
        // per.socreData[i]=nil;
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
                        //int scoret = IntegerparseInt(score.score_m[ib]);
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
                    //scoreG10[0]= IntegerparseInt(score.score_m[9]);
                    scoreG10[0]=b9.resultScore.intValue;
                    
                    if(b9.secondScore.intValue == 6)
                    {
                        //XXX
                        scoreG10[0]+=6;//再添6分
                        ////scoreG10[1]=6;
                        
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
                        
                    }
                    int sum=scoreG10[0]+scoreG10[1]+scoreG10[2];
                    
                    //score.score_m[9]=sum+"";
                    b9.resultScore = [NSString stringWithFormat:@"%d", sum];
                }
                
            } else {
                //int lscore = IntegerparseInt(score.score_l[i]);
                
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
                        scoret+=sum;//奖一组得分
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


//- (void)caculateScore:(Board *)board :(void(^)(Board *))res
//{
//    Person * per = self.scoreArray[self.columnIndex];
//    Board * ball =  per.socreData[_rowIndex];
//    
//    
//    for (int i = 0; i <per.socreData.count ; i ++) {
//        Board * b = per.socreData[i];
//        if (b.areadyBall == 0) {
//            break;
//        }
//        else if (b.areadyBall == 1) {
//            b.firstScore = [NSString stringWithFormat:@"%d", b.type];
//        }
//        else if (b.type == 0) {
//            b.secondScore = [NSString stringWithFormat:@"%d", b.type];
//        }
//        
//        [self caculateTotalScore:i];
//    }
//    if(res)res(ball);
//}


//- (void)caculateTotalScore:(int)index
//{
//    Person * per = [Manager sharedInstance].allPersonArr[self.columnIndex];
//    Board * b =  per.socreData[index];
//    
//    if (b.areadyBall == 1)
//    {
//        if (b.firstScore.intValue == 6) { // x
//            b.needNumber = 2;
//            b.resultScore = nil;
//            
//            Board * b_ = per.socreData[index+1];
//            if (b_.areadyBall == 2)
//            {
//                if (b_.secondScore.intValue == 7) {
//                    b.resultScore = [NSString stringWithFormat:@"12"];
//                }
//                else
//                {
//                    b.resultScore = [NSString stringWithFormat:@"%d", 6 + b_.firstScore.intValue + b_.secondScore.intValue];
//                }
//            }else if (b_.areadyBall == 1)
//            {
//                Board * b__ = per.socreData[index+2];
//                if (!b__.firstScore) {
//                    b.resultScore = nil;
//                }else
//                    b.resultScore = [NSString stringWithFormat:@"%d", b.firstScore.intValue + b_.firstScore.intValue + b__.firstScore.intValue];
//            }else {
//                b.resultScore = nil;
//            }
//            
//        } else if (b.firstScore.intValue == 7)
//        {
//            b.needNumber = 1;
//            Board * b__ = per.socreData[index+2];
//            if (!b__.firstScore) {
//                b.resultScore = nil;
//            }else
//                b.resultScore = [NSString stringWithFormat:@"%d", b.firstScore.intValue + b__.firstScore.intValue];
//        }else {
//            b.resultScore = nil;
//        }
//    }else if(b.areadyBall == 2)
//    {
//        // 第二球不可能为x，最好的情况只能补分
//        if (b.secondScore.intValue == 7) {
//            b.needNumber = 1;
//            Board * b__ = per.socreData[index+2];
//            if (!b__.firstScore) {
//                b.resultScore = nil;
//            }else
//                b.resultScore = [NSString stringWithFormat:@"%d", 6 + b__.firstScore.intValue];
//        }
//        else {
//            b.resultScore = [NSString stringWithFormat:@"%d", b.firstScore.intValue + b.secondScore.intValue];;
//        }
//    }else
//    {
//        b.resultScore = nil;
//    }
//    if (b.resultScore) {
//        per.total = b.resultScore;
//    }
//    NSLog(@"b.score == %@",b.resultScore);
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
