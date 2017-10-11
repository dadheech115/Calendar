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

-(UICollectionView *)getCollectionView{
    return monthsCollectionView;
}

-(void)setupWeeksLabelsView{
    //Setting up different weekday's label at top of view
    
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
    [labelsView setBackgroundColor:kThemeColor];
    [self addSubview:labelsView];
}

-(void)setupMonthsCollectionView{
    //Setting up continuous scrollable month view
    
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];

    monthsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kMonthsCollectionViewCellHeight, self.frame.size.width, 5*kMonthsCollectionViewCellHeight) collectionViewLayout:collectionViewLayout];
    [monthsCollectionView setBackgroundColor:kThemeColor];
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
    [monthsCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[[DateDataManager sharedInstance] getCurrentPosition] inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    isLoadingFirstTime = NO;
}

#pragma mark - Collection View Delegates and Data Source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[DateDataManager sharedInstance] getNumberOfDays];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    MonthsCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellReuseIdentifier forIndexPath:indexPath];
    
    [collectionCell updateCellDataForPosition:indexPath.row];
    
    return collectionCell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemAtPosition:)]){
        [self.delegate didSelectItemAtPosition:indexPath.row];
    }
}
#pragma mark - scroll view delegates

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //Checking scroll view's content offset to load next or previous set of dates accordingly
    
    if(scrollView.contentOffset.y<kMonthsCollectionViewCellHeight && !isLoadingFirstTime){
        [self loadPreviousDates];
    }else if(scrollView.contentOffset.y+scrollView.frame.size.height>=4*kMonthsCollectionViewCellHeight){
        [self loadNextDates];
        isLoadingFirstTime = NO;
    }
    
    //Changing the title of month button to display the month of top most cell
    NSIndexPath *topIndexpath =[(UICollectionView *)scrollView indexPathForItemAtPoint:CGPointMake(10, scrollView.contentOffset.y+10)] ;
        if(self.delegate && [self.delegate respondsToSelector:@selector(changeMonthTitleWithPosition:)]){
            [self.delegate changeMonthTitleWithPosition:topIndexpath.row];
        }
}

-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return NO;
}


#pragma mark - load more rows

-(void)loadPreviousDates{
    // Loading previous 28 dates
    [[DateDataManager sharedInstance] updateStartDateTo:[[[DateDataManager sharedInstance] getStartDate] dateByAddingTimeInterval:-kOneDayTime*28]];
    CGFloat offsetY = monthsCollectionView.contentSize.height - monthsCollectionView.contentOffset.y;
    [monthsCollectionView reloadData];
    [monthsCollectionView layoutIfNeeded];
    monthsCollectionView.contentOffset = CGPointMake(0, monthsCollectionView.contentSize.height - offsetY);
    
}

-(void)loadNextDates{
    //Loading next 28 dates
    [[DateDataManager sharedInstance] updateEndDateTo:[[[DateDataManager sharedInstance] getEndDate] dateByAddingTimeInterval:kOneDayTime*28]];
    [monthsCollectionView reloadData];
    [monthsCollectionView layoutIfNeeded];
}

@end
