//
//  BLMainView.m
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/4.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import "BLMainView.h"
#import "ZZNUIManager.h"
//#import "ScoreCollectionViewCell.h"
#import "Masonry.h"
#import "Person.h"
#import "ScoreBoardView.h"
#import "Manager.h"
//#import "ScoreSubCell.h"
#import "BLCollectionViewCell.h"
#import "NEWCell.h"
@interface BLMainView ()<UICollectionViewDelegate,UICollectionViewDataSource,ScoreBoardViewDelegate,UITextFieldDelegate>


@property(nonatomic,strong) UIControl *buttonContro;     //放按钮view的容器

@property(nonatomic,assign) BOOL isShowButton;

@property(nonatomic,strong) NSIndexPath *indexPathCol; //刷新分数 collectionview
@property(nonatomic,strong) NSIndexPath *indexPathTab; //刷新分数 tableview
@property(nonatomic,assign) NSUInteger rowIndex;    // 当前横向点击的第几个cell
@property(nonatomic,assign) NSUInteger columnIndex; // 当前纵向点击的第几个cell

@property(nonatomic, assign)BOOL isrefresh;

@end

@implementation BLMainView

//5686 5726

-(void)dealloc{

}
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
//        collectionView.userInteractionEnabled  = YES;
//        UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideEditbaord)];
//        [collectionView addGestureRecognizer:hideTap];
        [collectionView registerClass:[BLCollectionViewCell class] forCellWithReuseIdentifier:@"blcell"];
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        [self reLayoutSubviews];

        __weak typeof(self) weak = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(weak) self = weak;
            [self reLayoutSubviews];
        }];
        
       
    }

    return self;
}
- (void)hideEditbaord
{
    [self endEditing:YES];
}
-(void)reLayoutSubviews
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.left.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        //适配5s
        if (ZZN_UI_SCREEN_W < 350) {
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@20);
                make.right.equalTo(@0);
                make.left.equalTo(@0);
                make.bottom.equalTo(@0);
            }];
        }

    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@25);
            make.right.equalTo(@0);
            make.left.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        //适配5s
        if (ZZN_UI_SCREEN_W < 350) {
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@20);
                make.right.equalTo(@0);
                make.left.equalTo(@0);
                make.bottom.equalTo(@0);
            }];
        }
        
    }
    self.isrefresh = YES;
    [self reload];
}
-(void)setScoreArray:(NSArray *)scoreArray
{
    _scoreArray = scoreArray;
    self.isrefresh = NO;
    [self reload];
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.scoreArray.count;
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BLCollectionViewCell *cel = [collectionView dequeueReusableCellWithReuseIdentifier:@"blcell" forIndexPath:indexPath];
    cel.textfild_name.delegate = self;
    cel.textfild_name.tag = indexPath.row;
    Person *person = self.scoreArray[indexPath.row];
    cel.person = person;
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFiledEditChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:cel.textfild_name];
    if (indexPath.row<[Manager sharedInstance].nums&&![person.total isEqualToString:@""]) {
        cel.imageView_left.image = [UIImage imageNamed:[NSString stringWithFormat:@"ico_rank_%d",(int)indexPath.row+1]];
    
        cel.imageView_left.hidden = NO;
    }else{
        cel.imageView_left.hidden = YES;
    }
    
    //可被编辑
    if (indexPath.row == 0 ) {
        cel.person.name_enabled = @"yes";
    }
    cel.dataSource = person.socreData;
    __weak typeof(self)weakSelf = self;
    
    //点击照片的回调
    cel.cellBlock = ^(BLCollectionViewCell *scoreCell , int select){
        
        __strong typeof(weakSelf)self = weakSelf;
        NSIndexPath *indexpath = [self.collectionView indexPathForCell:scoreCell];
        
        Person *p_ = self.scoreArray[indexpath.row];
        if (self.photoBlock) {
            self.photoBlock(scoreCell,p_.image.intValue,select);
        }
    };
    
    //点击记分栏的回调
    cel.tabVCellBlock = ^(BLCollectionViewCell *scoreCell ,CGRect frame,int row){
        __strong typeof(weakSelf)self = weakSelf;
        
        self.columnIndex = indexPath.row;
        self.rowIndex = row;
        self.indexPathCol = [collectionView indexPathForCell:scoreCell];
        self.isShowButton = YES;
        
        Person *person0 = [Manager sharedInstance].allPersonArr[self.columnIndex];
        Board *board = person0.socreData[row];

        if (indexPath.row!=0) {
            if (self.columnIndex == 1) {
                if ([person0.name isEqualToString:@"Player 2"]) {
                    return ;
                }
            }else if (self.columnIndex == 2){
                if ([person0.name isEqualToString:@"Player 3"]) {
                    return ;
                }
            }else if (self.columnIndex == 3){
                if ([person0.name isEqualToString:@"Player 4"]) {
                    return ;
                }
            }
        }
        
            if (row>0 && [board.firstScore isEqualToString:@""]) {
            //上一个没完成且下一个为空不能点击后面的
            Board *boardFront = person0.socreData[row-1];
            
            if (row>=9) {
                if (![boardFront.secondFinish isEqualToString:@"yes"] ) {
                    return;
                }
            }else{
                Board *boardLast = person0.socreData[row+1];
                if (![boardFront.secondFinish isEqualToString:@"yes"] &&![boardLast.secondFinish isEqualToString:@""]) {
                    return;
                }
            }
            
        }
        
        //TODO:打第几个球的弹出框
        if ([board.firstFinish isEqualToString:@"yes"]) {
            
            if (row==9 && (![board.threeScore isEqualToString:@""]||[board.secondScore isEqualToString:@"6"]||[board.secondScore isEqualToString:@"7"]||([board.firstScore isEqualToString:@"6"]&&![board.secondScore isEqualToString:@""]))) {
                [[ZZNUIManager sharedInstance] eidtShowFirstBlock:^{
                    __strong typeof(weakSelf)self = weakSelf;
                    [self click:1 WithScoreButtonView:scoreCell.frame Arrowframe:frame cellRow:row board:board];
                } secondBlock:^{
                    __strong typeof(weakSelf)self = weakSelf;
                    [self click:2 WithScoreButtonView:scoreCell.frame Arrowframe:frame cellRow:row board:board];
                } thirdBlock:^{
                    //cancel
                } threeBlock:^{
                    __strong typeof(weakSelf)self = weakSelf;
                    [self click:3 WithScoreButtonView:scoreCell.frame Arrowframe:frame cellRow:row board:board];
                }];
                
                return;
            }
            
            //两个分的弹框
            BLWeak
            __weak typeof(board)weakBoard = board;
            __weak typeof(scoreCell)weakscoreCell = scoreCell;
            [[ZZNUIManager sharedInstance]eidtShowFirstBlock:^{
                __strong typeof(weakBoard)board = weakBoard;
                 __strong typeof(weakscoreCell)scoreCell = weakscoreCell;
                [self click:1 WithScoreButtonView:scoreCell.frame Arrowframe:frame cellRow:row board:board];
            } secondBlock:^{
                    BLStrong
                __strong typeof(weakBoard)board = weakBoard;
                __strong typeof(weakscoreCell)scoreCell = weakscoreCell;
                if (![board.firstScore isEqualToString:@"6"]||row==9) {
                    [self click:2 WithScoreButtonView:scoreCell.frame Arrowframe:frame cellRow:row board:board];
                }
                
            } thirdBlock:^{
                
            }];
            return;
            
        }else{
            [self initScoreButtonView:scoreCell.frame Arrowframe:frame cellRow:row board:board];
        }
    };

    
    return cel;
  
}


// 上左下右
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //适配5s
    if (ZZN_UI_SCREEN_W < 350) {
        return UIEdgeInsetsMake(10, 10, 10, 10) ;
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
    
    return CGSizeMake(ZZN_UI_SCREEN_W-20, (self.frame.size.height-50-30)/4);
}

- (void)reload{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
}

- (void)hideButtonView
{
    [self.scoreViewBut removeFromSuperview];
    [self.buttonContro removeFromSuperview];
   
    
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
        //这场分全部清空
        ball.firstScore = @"";
        ball.firstFinish = @"";
        ball.secondScore = @"";
        ball.secondFinish = @"";
        ball.resultScore = @"";
        ball.threeScore = @"";
         ball.threeFinish = @"";
    }else if(select == 2){
        //这场分清空第二个和第三个分数
        ball.secondScore = @"";
        ball.secondFinish = @"";
        ball.threeScore = @"";
        ball.resultScore = @"";
         ball.threeFinish = @"";
    }else{
        //这场分只清空第三个分数
        ball.threeScore = @"";
//        ball.secondFinish = @"";
        ball.threeFinish = @"";
        ball.resultScore = @"";
    }
    
//    NSString *storeName = @"";
//    if (self.columnIndex == 0) {
//        storeName = firstBoard;
//    }else if(self.columnIndex == 1){
//        storeName = secondBoard;
//    }else if (self.columnIndex == 2){
//        storeName = threeBoard;
//    }else if (self.columnIndex == 3){
//        storeName = fourBoard;
//    }
    
    
//    //写入数据
//    [[Manager sharedInstance] writeDataWithArray:per.socreData andName:storeName];
    

//    //刷新UI
//    BLCollectionViewCell * cell = (BLCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.indexPathCol];
//    cell.dataSource = per.socreData;
    
    //重新计算总分
    per = [[Manager sharedInstance] caculateScore:(int)self.columnIndex]; //[self caculateScore];
    
    
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
    BLCollectionViewCell * cell = (BLCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.columnIndex inSection:0]];
    cell.dataSource = per.socreData;
    int total = 0;
    total = [Person getTotal:per];
    if (total>0) {
        cell.label_totalScore.text = [NSString stringWithFormat:@"%d",total];
        cell.imageView_left.hidden = NO;
    }
    
    per.total = cell.label_totalScore.text;
    
    NSMutableArray *perArr = [[Manager sharedInstance].allPersonArr mutableCopy];
    [perArr replaceObjectAtIndex:self.columnIndex withObject:per];
    
    [[Manager sharedInstance] writeDataWithArray:perArr andName:STORAGE];
    [self initScoreButtonView:cellFrame Arrowframe:ArrowFrame cellRow:row board:ball];
}

//创建新的button view
- (void)initScoreButtonView :(CGRect )cellFrame Arrowframe:(CGRect)ArrowFrame cellRow:(int)row board:(Board *)board{
    if (self.buttonContro || self.scoreViewBut) {
        if (self.scoreViewBut) {
             [self hideButtonView];
        }
       
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.buttonContro = [[UIControl alloc]initWithFrame:self.frame];
        [self.buttonContro addTarget:self action:@selector(hideButtonView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.buttonContro];
        self.scoreViewBut = [[ScoreBoardView alloc]initWithFrame:cellFrame ArrowFrame:ArrowFrame  cellRow:row board:board columnIndex:(int)self.columnIndex];
        [self.buttonContro addSubview:self.scoreViewBut];
        self.scoreViewBut.delegate = self;
        
    });
    
}
-(NSString*) int2english:(int)xmun{
    NSMutableString* result = [[NSMutableString alloc]init];;
    switch(xmun){
        case 0:result=[NSMutableString stringWithFormat:@"zero"];break;
        case 1:result=[NSMutableString stringWithFormat:@"one"];break;
        case 2:result=[NSMutableString stringWithFormat:@"two"];break;
        case 3:result=[NSMutableString stringWithFormat:@"three"];break;
        case 4:result=[NSMutableString stringWithFormat:@"four"];break;
        case 5:result=[NSMutableString stringWithFormat:@"five"];break;
        case 6:result=[NSMutableString stringWithFormat:@"six"];break;
        case 7:result=[NSMutableString stringWithFormat:@"seven"];break;
        case 8:result=[NSMutableString stringWithFormat:@"eight"];break;
        case 9:result=[NSMutableString stringWithFormat:@"nine"];break;
        case 10:result=[NSMutableString stringWithFormat:@"ten"];break;
        case 11:result=[NSMutableString stringWithFormat:@"eleven"];break;
        case 12:result=[NSMutableString stringWithFormat:@"twelve"];break;
        default:break;
    }
    return result;
}
//row 遍历次数 ，per Person类对象 ，offset greatShowText 显示第几位增加量（如：起始位从0开始 －> 起始位从1开始计算）
- (int) continuityX:(int)row personData:(Person*)per offset:(int)x{
    int xsum =0,xmun = 0;
    
    xsum = [self traversal:row  personData:per];
    xmun = [self showText:xsum  personData:per offset:(int)x];
    
    return xmun;
}
//FUCTION:显示连续多少次获得X得分
//PAEAM:sum 连续X的次数 ，per Person类对象 ，offset greatShowText 显示第几位增加量（如：起始位从0开始 －> 起始位从1开始计算）
-(int) showText:(int)sum personData:(Person*) per offset:(int)x{
    int mun =0;
    
    if(sum >= 5 )
    {
        mun=6;
        if (self.greatShowText) {
            self.greatShowText([NSString stringWithFormat:@"%@ earned a wild turkey with %@ strike!", per.name,[self int2english:sum + x ]]);
        }
    }else if(sum >= 2)
    {
        mun=3;
        if (self.greatShowText) {
            self.greatShowText([NSString stringWithFormat:@"%@ gained a turkey with %@ strike!",per.name,[self int2english:sum + x ]]);
        }
    }else if(sum >= 0)
    {
        if (self.greatShowText) {
            self.greatShowText([NSString stringWithFormat:@"%@ is in a row with that perfect strike!",per.name]);
        }
    }
    return mun;
}
//FUCTION:遍历连续获得X次数
-(int)traversal:(int)row personData:(Person *)per
{
    int xsum = 0;
    for (int i = row; i >=0; i--)
    {
        Board * ball =  per.socreData[i];
        if(ball.firstScore.intValue == 6)
        {
            xsum++;
        }else
            break;
    }
    return xsum;
    
}

#pragma mark - ScoreBoardViewDelegate
- (void)clickBtnRefreshWith:(ButtonModel *)btnModel{
    
    Person * per = self.scoreArray[self.columnIndex];
    Board * ball =  per.socreData[btnModel.row];
    
    int xmun =0;
    //不能大于10个
    if (btnModel.row>=10) {
        return;
    }

    //干得漂亮
    if (btnModel.buttonTag == bravo) {
        
        if (self.greatShowText) {
            self.greatShowText([NSString stringWithFormat:@"%@ is in a row with that perfect strike!", per.name]);
        }
        if (btnModel.row >= 2) {
            
            if (btnModel.row < 9 )
            {
                xmun = [self continuityX:btnModel.row - 1 personData:per offset:1];
                
            }else if(btnModel.row == 9)
            {
                Board * ball =  per.socreData[9];
                if(ball.secondScore.intValue == 6)
                {
                    //第十个球 第3次为X
                    xmun = [self continuityX:btnModel.row personData:per offset:2];
                }else if(ball.firstScore.intValue == 6)
                {
                    //第十个球 第2次为X
                    xmun = [self continuityX:btnModel.row - 1 personData:per offset:2];
                }else
                {
                    //第十个球 第1次为X
                    xmun = [self continuityX:btnModel.row - 1 personData:per offset:1];
                }
            }
        }
        if (self.greatShowCall)
        {
            if(xmun == 0)
            {
                self.greatShowCall(well_done,per.name);
            }else if(xmun == 3)
            {
                self.greatShowCall(bravo_three,per.name);
            }else if(xmun == 6)
            {
                self.greatShowCall(fantastic,per.name);
            }
        }
    }else if (btnModel.buttonTag == good_job){
        if (self.greatShowCall) {
            if (self.greatShowText) {
                self.greatShowText([NSString stringWithFormat:@"%@ is in a row with that super spare!", per.name]);
            }
            self.greatShowCall(good_job,per.name);
        }
    }


        //给分
    if (![ball.firstFinish isEqualToString:@"yes"]) {
        //第一次打球
        ball.firstScore = [NSString stringWithFormat:@"%d",btnModel.buttonTag];
        
        
        if (btnModel.buttonTag == 6) {
            ball.secondScore = @"";
            ball.firstFinish = @"yes";
            //第十场球还是继续打
            if (btnModel.row != 9) {
                ball.secondFinish = @"yes";
            }
            
            
        }else{
            ball.firstFinish = @"yes";
        }
    }else{
        
        //第十场场第一个球打X,可以打三次
        if (btnModel.row == 9 && ball.firstScore.intValue == 6) {
            
            if ([ball.secondFinish isEqualToString:@"yes"]) {
                //第三次打球的分数
                ball.threeFinish = @"yes";
                
                ball.threeScore = [NSString stringWithFormat:@"%d",btnModel.buttonTag];
                
            }else{
                //第二次打球的分数
                ball.secondFinish = @"yes";
                ball.secondScore = [NSString stringWithFormat:@"%d",btnModel.buttonTag];
            }
          

        }else{
            
            //如果第十场第一球不是X，但是第二球是／
            if (ball.secondScore.intValue == 7 ) {
                //第三次打球
                ball.threeFinish = @"yes";
                ball.threeScore = [NSString stringWithFormat:@"%d",btnModel.buttonTag];
            }else{
                //第二次打球
                ball.secondFinish = @"yes";
                ball.secondScore = [NSString stringWithFormat:@"%d",btnModel.buttonTag];

                if (ball.secondScore.intValue != 7) {
                    ball.threeFinish = @"yes";
                }
            }


        }
        
    }

//TODO:开始计算分数
    per = [[Manager sharedInstance] caculateScore:(int)self.columnIndex]; //[self caculateScore];
    
    
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
    BLCollectionViewCell * cell = (BLCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.columnIndex inSection:0]];
    cell.dataSource = per.socreData;
    int total = 0;
    total = [Person getTotal:per];
    if (total>0) {
        cell.label_totalScore.text = [NSString stringWithFormat:@"%d",total];
        cell.imageView_left.hidden = NO;
    }
    
    per.total = cell.label_totalScore.text;
    
    NSMutableArray *perArr = [[Manager sharedInstance].allPersonArr mutableCopy];
    [perArr replaceObjectAtIndex:self.columnIndex withObject:per];
    
    [[Manager sharedInstance] writeDataWithArray:perArr andName:STORAGE];
    
    if (self.columnIndex<[Manager sharedInstance].nums&&![per.total isEqualToString:@""]) {
        cell.imageView_left.image = [UIImage imageNamed:[NSString stringWithFormat:@"ico_rank_%lu",self.columnIndex+1]];
        
        cell.imageView_left.hidden = NO;
    }else{
        cell.imageView_left.hidden = YES;
    }

    //前后都没打，就不用自动弹出buttonView
    if (btnModel.row!=0 && btnModel.row!=9 && [btnModel.board.secondFinish isEqualToString:@"yes"]) {
        Person *person0 = [Manager sharedInstance].allPersonArr[self.columnIndex];
        //上一个没完成且下一个为空不能点击后面的
        Board *boardFront = person0.socreData[btnModel.row-1];
        Board *boardLast = person0.socreData[btnModel.row+1];
        if ([boardFront.firstFinish isEqualToString:@""] && [boardLast.firstFinish isEqualToString:@""])
        {
            if (self.scoreViewBut) {
                [self hideButtonView];
            };
            return;
        }
    }
    
    //比赛的人数
   int nums = [Person getPersons];
    
    if ([Person isGameEnd:perArr]) {
        if (self.greatShowCall) {
            //游戏结束
            if (self.scoreViewBut) {
                [self hideButtonView];
            };
            self.scoreArray = [Manager sharedInstance].allPersonArr;
            self.greatShowCall(game_end,[Manager sharedInstance].winnner_name);
            return;
        }
    }

#if 1
    if (nums >=2) {
        //TODO:若果是多人比赛,上下移动  (最后一个判断 threeFinish 是否完成)
        if (([ball.secondFinish isEqualToString:@"yes"]&&(btnModel.row < 9))||(([ball.threeFinish isEqualToString:@"yes"]))) {
            self.columnIndex++;
            
            if (self.columnIndex >= nums) {
                self.columnIndex = 0;
            }
            //判断下一组是否已经打完
            self.columnIndex = [Person isPersonEnd:perArr andColumnIndex:(int)self.columnIndex ];
            
            //防止越界
            if (self.columnIndex >= nums) {
                self.columnIndex = 0;
            }
            Person * perMroe = self.scoreArray[self.columnIndex];
            //查找该打哪一场
            btnModel.row = [perMroe getNeedCacolateBoard:perMroe];
            ball = perMroe.socreData[btnModel.row];

            cell = (BLCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.columnIndex inSection:0]];
            btnModel.cellFrame = cell.frame;
            
        }
    }else{
        //单人比赛，左右移动  打完一组就换下一组
        if ([ball.secondFinish isEqualToString:@"yes"]&&(btnModel.row < 9)) {
            btnModel.row ++;
            ball = per.socreData[btnModel.row];
            for (int i=0; i<per.socreData.count; i++) {
                Board *bb = per.socreData[i];
                if (([bb.resultScore isEqualToString:@""] && ![bb.firstFinish isEqualToString:@"yes"])||(bb.firstScore.intValue !=6 && ![bb.secondFinish isEqualToString:@"yes"])) {
                    btnModel.row = i;
                    ball = bb;
                    break;
                }
                if (i==9) {
                    if ([bb.resultScore isEqualToString:@""] ) {
                        btnModel.row = i;
                    }
                }

            }
        }
    }
#endif
    
    //TODO:cell的居中偏移
    if (btnModel.row>=2) {
        [cell.collecView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:btnModel.row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];       
    }
    cell.offSetRow = btnModel.row;
    //销毁buttonview
    if (self.scoreViewBut) {
        [self hideButtonView];
    };
    

   
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btnModel.row inSection:0];
    BLWeak
    __weak typeof(indexPath)weakIndexPath = indexPath;
    __weak typeof(cell)weakCell = cell;
    [cell.collecView performBatchUpdates:^{
        __strong typeof(weakCell)cell = weakCell;
        __strong typeof(weakIndexPath)indexPath = weakIndexPath;
        
        [cell.collecView reloadItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        BLStrong
         __strong typeof(weakCell)cell = weakCell;
        __strong typeof(weakIndexPath)indexPath = weakIndexPath;
        UICollectionViewCell *scoreTabCell = [cell.collecView cellForItemAtIndexPath:indexPath];
        if (scoreTabCell) {
            CGRect rectInTableView = [cell.collecView convertRect:scoreTabCell.frame toView:cell.collecView];
            CGRect arrowFrame = [cell.collecView convertRect:rectInTableView toView:[cell.collecView superview]];
            
            if (self.scoreViewBut) {
                [self hideButtonView];
            };
            self.buttonContro = [[UIControl alloc]initWithFrame:self.frame];
            [self.buttonContro addTarget:self action:@selector(hideButtonView) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.buttonContro];
            self.scoreViewBut = [[ScoreBoardView alloc]initWithFrame:btnModel.cellFrame   ArrowFrame:arrowFrame  cellRow:btnModel.row board:ball columnIndex:(int)self.columnIndex];
            self.scoreViewBut.delegate = self;
            [self.buttonContro addSubview:self.scoreViewBut];

        } else {
            // 如果cell为空再滚动一次
            
            @try {
                
                 [cell.collecView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            } @finally {
                
            }
           
        }
        
    }];
    
    
    //后面没显示的cell 滑动不能及时更新，就用下面这个更新
    cell.scrollDidEndCall = ^(NEWCell *newCell,UICollectionView *collecView){
        BLStrong
        __strong typeof(weakCell)cell = weakCell;
        __strong typeof(weakIndexPath)indexPath = weakIndexPath;
        UICollectionViewCell *scoreTabCell = [cell.collecView cellForItemAtIndexPath:indexPath];
        CGRect rectInTableView = [cell.collecView convertRect:scoreTabCell.frame toView:cell.collecView];
        CGRect arrowFrame = [cell.collecView convertRect:rectInTableView toView:[cell.collecView superview]];
        
        if (self.scoreViewBut) {
            [self hideButtonView];
        };
        self.buttonContro = [[UIControl alloc]initWithFrame:self.frame];
        [self.buttonContro addTarget:self action:@selector(hideButtonView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.buttonContro];
        self.scoreViewBut = [[ScoreBoardView alloc]initWithFrame:btnModel.cellFrame   ArrowFrame:arrowFrame  cellRow:btnModel.row board:ball columnIndex:(int)self.columnIndex];
               self.scoreViewBut.delegate = self;
        [self.buttonContro addSubview:self.scoreViewBut];
            
    };


}
#pragma makr - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //写入数据
    Person *per = [Manager sharedInstance].allPersonArr[textField.tag];
    per.name = textField.text;
    NSMutableArray *perArr = [[Manager sharedInstance].allPersonArr mutableCopy];
    [perArr replaceObjectAtIndex:textField.tag withObject:per];
    
    if ((textField.tag +1) <4) {
        Person *per_next = [Manager sharedInstance].allPersonArr[textField.tag+1];
        if (![per.name isEqualToString:[NSString stringWithFormat:@"Player %ld",textField.tag+1]]) {
             per_next.name_enabled = @"yes";
        }
        [perArr replaceObjectAtIndex:textField.tag+1 withObject:per_next];
        BLCollectionViewCell * cell = (BLCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:0]];
        cell.person = per_next;
    }
    
    [[Manager sharedInstance] writeDataWithArray:perArr andName:STORAGE];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range {
    Person *per = [Manager sharedInstance].allPersonArr[textField.tag];
    per.name = textField.text;
    NSMutableArray *perArr = [[Manager sharedInstance].allPersonArr mutableCopy];
    if ((textField.tag +1) <4) {
        Person *per_next = [Manager sharedInstance].allPersonArr[textField.tag+1];
        if (![per.name isEqualToString:[NSString stringWithFormat:@"Player %ld",textField.tag+1]]) {
            per_next.name_enabled = @"yes";
        }
        [perArr replaceObjectAtIndex:textField.tag+1 withObject:per_next];
        BLCollectionViewCell * cell = (BLCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:0]];
        cell.person = per_next;
    }
    
    [[Manager sharedInstance] writeDataWithArray:perArr andName:STORAGE];
    
    return YES;

}
- (void)textFiledEditChanged:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[UITextField class]])
    {
        UITextField *textField = notification.object;
        
        Person *per = [Manager sharedInstance].allPersonArr[textField.tag];
        per.name = textField.text;
        NSMutableArray *perArr = [[Manager sharedInstance].allPersonArr mutableCopy];
        if ((textField.tag +1) <4) {
            Person *per_next = [Manager sharedInstance].allPersonArr[textField.tag+1];
            if (![per.name isEqualToString:[NSString stringWithFormat:@"Player %ld",textField.tag+1]]) {
                per_next.name_enabled = @"yes";
            }
            [perArr replaceObjectAtIndex:textField.tag+1 withObject:per_next];
            BLCollectionViewCell * cell = (BLCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:0]];
            cell.person = per_next;
        }
        
        [[Manager sharedInstance] writeDataWithArray:perArr andName:STORAGE];
    }
}
@end
