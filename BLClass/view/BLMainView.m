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
        if (row>0) {
            //上一个没完成，不能点击后面的
            Board *boardFront = person0.socreData[row-1];
            if (![boardFront.secondFinish isEqualToString:@"yes"]) {
                return;
            }
        }
        
        
       
        
            if ([board.firstFinish isEqualToString:@"yes"]) {
                
                [[ZZNUIManager sharedInstance]eidtShowFirstBlock:^{
                    [self initScoreButtonView:scoreCell.frame Arrowframe:frame cellRow:row board:board];
                } secondBlock:^{
                    if (board.firstScore.intValue == 6) {
                        return ;
                    }
                } thirdBlock:^{
                    
                }];
                return;
                

            }else{
                [self initScoreButtonView:scoreCell.frame Arrowframe:frame cellRow:row board:board];
#if 0
                if (self.buttonContro || self.scoreViewBut) {
                    [self hideButtonView];
                }
                
                self.buttonContro = [[UIControl alloc]initWithFrame:self.frame];
                [self.buttonContro addTarget:self action:@selector(hideButtonView) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:self.buttonContro];
                self.scoreViewBut = [[ScoreBoardView alloc]initWithFrame:scoreCell.frame ArrowFrame:frame  cellRow:row board:board];
                [self.buttonContro addSubview:self.scoreViewBut];
                self.scoreViewBut.delegate = self;
#endif
            }
    };
    return cell;
}

- (void)initScoreButtonView :(CGRect )cellFrame Arrowframe:(CGRect)ArrowFrame cellRow:(int)row board:(Board *)board{
    if (self.buttonContro || self.scoreViewBut) {
        [self hideButtonView];
    }
    
    self.buttonContro = [[UIControl alloc]initWithFrame:self.frame];
    [self.buttonContro addTarget:self action:@selector(hideButtonView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.buttonContro];
    self.scoreViewBut = [[ScoreBoardView alloc]initWithFrame:cellFrame ArrowFrame:ArrowFrame  cellRow:row board:board];
    [self.buttonContro addSubview:self.scoreViewBut];
    self.scoreViewBut.delegate = self;

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
    
    [self.buttonContro removeFromSuperview];
    
}
- (void)showButtonView{
    if (self.isShowButton) {
        self.scoreViewBut.hidden = NO;
        self.buttonContro.hidden = NO;
    }
}

#pragma mark - ScoreBoardViewDelegate
- (void)clickBtnRefreshWith:(ButtonModel *)btnModel{
    
    //不能大于10个
    if (btnModel.row>=10) {
        return;
    }
    //干得漂亮
    if (btnModel.buttonTag == 6) {
        if (self.greatShowCall) {
            self.greatShowCall(bravo);
        }
    }
    Person * per = self.scoreArray[self.columnIndex];
    Board * ball =  per.socreData[btnModel.row];
    int total = 0;//记总分
    if (!ball.firstFinish) {
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
        
       
        for (int i=0; i<per.socreData.count; i++) {
            Board *b = per.socreData[i];
            total += b.resultScore.intValue;
        }
        
    }
    //替换数据用来保存
    [per.socreData replaceObjectAtIndex:btnModel.row withObject:ball];
    
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
    
    if (btnModel.row>=9&&[ball.secondFinish isEqualToString:@"yes"]) {
        
        if (self.greatShowCall) {
            //游戏结束
            [self hideButtonView];
            self.greatShowCall(game_end);
        }
    }
    
    ScoreCollectionViewCell * cell = (ScoreCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.indexPath];
    cell.dataSource = per.socreData;
    
    
    if (total>0) {
        cell.label_totalScore.text = [NSString stringWithFormat:@"%d",total];
    }
   
    
    //打完一组就换下一组
    if ([ball.secondFinish isEqualToString:@"yes"]&&(btnModel.row < 9)) {
        btnModel.row ++;
    }
  
    if (btnModel.row>=2) {
        [cell.tableView_mark scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:btnModel.row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    

    
#if 0  //chen
    //写数据
    {
        Person * per = self.scoreArray[self.columnIndex];
        Board * ball =  per.socreData[btnModel.row];
        ball.areadyBall --;
        ball.type = btnModel.buttonTag;
        
        // 记分规则
        [self caculateScore:ball :^(Board *board){
            
        }];
        // UI刷新
    }

    self.scoreViewBut.delegate = nil;
    [self.scoreViewBut removeFromSuperview];
    [self.buttonContro removeFromSuperview];
#endif
    [self hideButtonView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.buttonContro = [[UIControl alloc]initWithFrame:self.frame];
        [self.buttonContro addTarget:self action:@selector(hideButtonView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.buttonContro];
        self.scoreViewBut = [[ScoreBoardView alloc]initWithFrame:btnModel.cellFrame   ArrowFrame:btnModel.arrowFrame  cellRow:btnModel.row board:btnModel.board];
        self.scoreViewBut.delegate = self;
        [self.buttonContro addSubview:self.scoreViewBut];

    });
    
    

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
//
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
