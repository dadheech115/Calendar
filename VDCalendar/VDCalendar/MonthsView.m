//
//  MonthsView.m
//  VDCalendar
//
//  Created by Vikas Dadheech on 06/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import "MonthsView.h"
#import "DateDataManager.h"
#import "GenericFunctions.h"
#import "MonthsCollectionViewCell.h"

#define kCollectionCellReuseIdentifier @"DateCell"

@interface MonthsView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@end

@implementation MonthsView{
    UICollectionView *monthsCollectionView;
    UIView *labelsView;
    BOOL isLoadingFirstTime;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupWeeksLabelsView];
        [self setupMonthsCollectionView];
        isLoadingFirstTime = YES;
    }
    return self;
}

-(void)setupWeeksLabelsView{
    NSArray *weeksLabelArray = [[NSArray alloc] initWithObjects:@"S",@"M",@"T",@"W",@"T",@"F",@"S", nil];
     labelsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kMonthsCollectionViewCellHeight)];
    CGFloat originX=0;
    for(NSString *labelString in weeksLabelArray){
        CGRect frameOfLabel = CGRectMake(originX,0, kMonthsCollectionViewCellWidth, kMonthsCollectionViewCellHeight);
        originX = originX+kMonthsCollectionViewCellWidth;
        UILabel *weekLabel = [[UILabel alloc] initWithFrame:frameOfLabel];
        [weekLabel setText:labelString];
        [weekLabel setTextAlignment:NSTextAlignmentCenter];
        [labelsView addSubview:weekLabel];
    }
    [labelsView setBackgroundColor:[UIColor grayColor]];
    [self addSubview:labelsView];
}

-(void)setupMonthsCollectionView{
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];

    monthsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kMonthsCollectionViewCellHeight, self.frame.size.width, 5*kMonthsCollectionViewCellHeight) collectionViewLayout:collectionViewLayout];
    [monthsCollectionView setBackgroundColor:[UIColor grayColor]];
    monthsCollectionView.dataSource = self;
    monthsCollectionView.delegate = self;
    UICollectionViewFlowLayout *layout =(UICollectionViewFlowLayout *)monthsCollectionView.collectionViewLayout;
    [layout setItemSize:CGSizeMake(kMonthsCollectionViewCellWidth, kMonthsCollectionViewCellHeight)];
    [layout setMinimumInteritemSpacing:0];
    [layout setMinimumLineSpacing:0];
    [monthsCollectionView registerClass:[MonthsCollectionViewCell class] forCellWithReuseIdentifier:kCollectionCellReuseIdentifier];
    [monthsCollectionView setShowsVerticalScrollIndicator:NO];

    [self addSubview:monthsCollectionView];
    
}

-(void)reloadCollection{
//    return;
    [monthsCollectionView reloadData];
    [self layoutSubviews];
    [monthsCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[[DateDataManager sharedInstance] getPositionOfDate:[NSDate date]] inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    isLoadingFirstTime = NO;
}

#pragma mark - Collection View Delegates and Data Source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[DateDataManager sharedInstance] getNumberOfDays];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    MonthsCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellReuseIdentifier forIndexPath:indexPath];
    
    NSDate *dateForSection = [[DateDataManager sharedInstance] getDateForPosition:indexPath.row];
    [collectionCell updateCellDataWithDateString:[GenericFunctions getDateTitle:dateForSection]];
    return collectionCell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.row==0 && !isLoadingFirstTime){
//        [self loadPreviousDates];
//    }else if(indexPath.row==[[DateDataManager sharedInstance] getNumberOfDays]-1){
//        
//        [self loadNextDates];
//    }
}

#pragma mark - scroll view delegates

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSArray *visibleCells = [monthsCollectionView visibleCells];
//    UICollectionViewCell *tempCell = [visibleCells objectAtIndex:0];
//    if([monthsCollectionView indexPathForCell:tempCell].row==0){
//        [self loadPreviousDates];
//    }
//    tempCell = [visibleCells lastObject];
//    if([monthsCollectionView indexPathForCell:tempCell].row == [[DateDataManager sharedInstance] getNumberOfDays]-1){
//        [self loadNextDates];
//    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y<kMonthsCollectionViewCellHeight && !isLoadingFirstTime){
        [self loadPreviousDates];
    }else if(scrollView.contentOffset.y+scrollView.frame.size.height>=4*kMonthsCollectionViewCellHeight){
        [self loadNextDates];
        isLoadingFirstTime = NO;
    }
//    NSArray *temp = [(UITableView *)scrollView indexPathsForVisibleRows];
//    NSDate *dateForSection = [[DateDataManager sharedInstance] getDateForPosition:[(NSIndexPath *)[temp objectAtIndex:0] section]];
//    NSString *monthString = [GenericFunctions getMonthStringForDate:dateForSection];
//    [monthButton setTitle:monthString forState:UIControlStateNormal];
    
}


#pragma mark - load more rows

-(void)loadPreviousDates{
    
    
    
    [[DateDataManager sharedInstance] updateStartDateTo:[[[DateDataManager sharedInstance] getStartDate] dateByAddingTimeInterval:-kOneMonthTime]];
    CGFloat offsetY = monthsCollectionView.contentSize.height - monthsCollectionView.contentOffset.y;
    [monthsCollectionView reloadData];
    [monthsCollectionView layoutIfNeeded]; // Force layout so things are updated before resetting the contentOffset.
    monthsCollectionView.contentOffset = CGPointMake(0, monthsCollectionView.contentSize.height - offsetY);
    
    //    [self.agendasTableView reloadData];
}

-(void)loadNextDates{
    [[DateDataManager sharedInstance] updateEndDateTo:[[[DateDataManager sharedInstance] getEndDate] dateByAddingTimeInterval:kOneMonthTime]];
//    CGPoint offset = self.agendasTableView.contentOffset;
    //    offset.y = kAgendaTableViewHeaderHeight*30;
    [monthsCollectionView reloadData];
    [monthsCollectionView layoutIfNeeded]; // Force layout so things are updated before resetting the contentOffset.
//    [self.agendasTableView setContentOffset:offset];
    
    //    [self.agendasTableView reloadData];
}

@end
