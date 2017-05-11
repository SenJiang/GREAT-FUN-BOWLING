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
@interface BLMainView ()<UICollectionViewDelegate,UICollectionViewDataSource,ScoreBoardViewDelegate>



@property(nonatomic,strong)ScoreBoardView *scoreViewBut;//按钮view

@property(nonatomic,strong)UIControl *buttonContro;//放按钮view的容器

@property(nonatomic,assign)BOOL isShowButton;

@end

@implementation BLMainView



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
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.collectionView reloadData];
//    });
    
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
    cell.tabVCellBlock = ^(ScoreCollectionViewCell *scorecell,int row){
            self.isShowButton = YES;
                if (indexPath.row!=0) {
                    //第二 三 四 个记分板好像没做
                    
                    return ;
                }
                [self.scoreViewBut removeFromSuperview];
                [self.buttonContro removeFromSuperview];
                self.buttonContro = [[UIControl alloc]initWithFrame:self.frame];
                [self.buttonContro addTarget:self action:@selector(hideButtonView) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:self.buttonContro];
        
                Person *person0 = ( Person *)self.scoreArray[0];
                Board *board = person0.socreData[row];
        
                self.scoreViewBut = [[ScoreBoardView alloc]initWithFrame:scorecell.frame cellRow:row board:board];
                [self.buttonContro addSubview:self.scoreViewBut];
                
                __weak typeof(self)weakSelf = self;
                self.scoreViewBut.boardBtnCall = ^(int score){
                    __strong typeof(weakSelf)self = weakSelf;
                    Person *person0 = self.scoreArray[0];
                    Board *board = person0.socreData[row];
                    board.firstScore = [NSString stringWithFormat:@"%d",score];
                    //数据存取
                    [self reload];
                };

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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}
- (void)reload{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
}

- (void)hideButtonView
{
    if (self.isShowButton) {
        self.scoreViewBut.hidden = YES;
        self.buttonContro.hidden = YES;
    }
}
- (void)showButtonView{
    if (self.isShowButton) {
        self.scoreViewBut.hidden = NO;
        self.buttonContro.hidden = NO;
    }
}

#pragma mark - ScoreBoardViewDelegate
- (void)clickBtnRefresh{
    [self.scoreViewBut removeFromSuperview];
    [self.buttonContro removeFromSuperview];
    
    self.buttonContro = [[UIControl alloc]initWithFrame:self.frame];
    [self.buttonContro addTarget:self action:@selector(hideButtonView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.buttonContro];
    
    Person *person0 = ( Person *)self.scoreArray[0];
    
//    self.scoreViewBut = [[ScoreBoardView alloc]initWithFrame:scorecell.frame cellRow:row board:board];
    [self.buttonContro addSubview:self.scoreViewBut];
    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
