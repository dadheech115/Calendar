//
//  ViewController.m
//  VDCalendar
//
//  Created by Vikas Dadheech on 05/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import "CalendarViewController.h"
#import "DateDataManager.h"
#import "GenericFunctions.h"
#import "MonthsView.h"


#define kAgendaTableViewHeaderHeight 30.0

@interface CalendarViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate,MonthsViewDelegate>

@property (nonatomic, strong) UITableView *agendasTableView;

@end

@implementation CalendarViewController{
    UIButton *monthButton;
    UIButton *todayButton;
    MonthsView *monthsView;
    BOOL isMonthViewVisible;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAgendasTableView];
    [self setupNavigationBar];
    
}


-(void)setupAgendasTableView{
    self.agendasTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.agendasTableView.delegate = self;
    self.agendasTableView.dataSource = self;
    [self.agendasTableView setBackgroundColor:[UIColor whiteColor]];
    [self.agendasTableView setShowsVerticalScrollIndicator:NO];
    [self.agendasTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"AgendasHeader"];
    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday
                                                       fromDate:[NSDate date]];
    
    weekday--;
    weekday = weekday+7;
    [self.agendasTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:weekday] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.view addSubview:self.agendasTableView];
}

-(UITableView *)getAgendaTableView{
    return _agendasTableView;
}

-(MonthsView *)getMonthsView{
    [self monthButtonTapped];
    return monthsView;
}

-(void)setupNavigationBar{
    monthButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 0, 100, 40)];
    NSDate *dateForSection = [[DateDataManager sharedInstance] getDateForPosition:0];
    NSString *monthString = [GenericFunctions getMonthStringForDate:dateForSection];
    
    [monthButton setTitle:monthString forState:UIControlStateNormal];
    [monthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    monthButton.imageEdgeInsets = UIEdgeInsetsMake(0., monthButton.frame.size.width - 20, 0., 0.);
    monthButton.titleEdgeInsets = UIEdgeInsetsMake(0., -20., 0., 20.);
//    [monthButton setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
//    [monthButton.imageView setFrame:CGRectMake(80, 0, 20, 20)];
    [monthButton setImage:[UIImage imageNamed:@"DownArrow"] forState:UIControlStateNormal];
    [monthButton addTarget:self action:@selector(monthButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:monthButton]];
    
    todayButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 0, 40, 40)];
    [todayButton setBackgroundImage:[UIImage imageNamed:@"Calendar"] forState:UIControlStateNormal];
    [todayButton setTitle:[GenericFunctions getDateTitle:[NSDate date]] forState:UIControlStateNormal];
    [todayButton setContentEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    [todayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [todayButton addTarget:self action:@selector(todayButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:todayButton]];
    
    if(!monthsView){
        monthsView = [[MonthsView alloc] initWithFrame:CGRectMake(0,64, [UIScreen mainScreen].bounds.size.width, 6*kMonthsCollectionViewCellHeight)];
        monthsView.delegate = self;
        isMonthViewVisible = NO;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Agenda Table View delegates and data sources

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[DateDataManager sharedInstance] getNumberOfDays];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kAgendaTableViewHeaderHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *HeaderIdentifier = @"AgendasHeader";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    
    if(!headerView) {
        headerView =[[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"AgendasHeader"];
    }else{
//        for(UIView *subview in headerView.subviews)
//            [subview removeFromSuperview];
    }

    
//    headerView.t
    
//    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
    
    NSDate *dateForSection = [[DateDataManager sharedInstance] getDateForPosition:section];
    [headerView.textLabel setText:[GenericFunctions getAgendaSectionTitleForDate:dateForSection]];
//    [headerView addSubview:dateLabel];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    return headerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"AgendasCell"];
    if(!tableCell){
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AgendasCell"];
    }
    [tableCell.textLabel setText:@"No events"];
    return tableCell;
}

#pragma mark - scroll view delegates

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(isMonthViewVisible)
        [self hideMonthsView];
        
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y<120){
        [self loadPreviousDates];
    }else if(scrollView.contentOffset.y+scrollView.frame.size.height>=scrollView.contentSize.height-210){
        [self loadNextDates];
    }
    NSArray *temp = [(UITableView *)scrollView indexPathsForVisibleRows];
    NSIndexPath *topIndexPath = [temp objectAtIndex:0];
    
    [self changeMonthTitleWithPosition:topIndexPath.section];
    
}


#pragma mark - load more rows

-(void)loadPreviousDates{
    [[DateDataManager sharedInstance] updateStartDateTo:[[[DateDataManager sharedInstance] getStartDate] dateByAddingTimeInterval:-kOneDayTime*35]];
    CGPoint offset = self.agendasTableView.contentOffset;
    offset.y = kAgendaTableViewHeaderHeight*30;
    [self.agendasTableView reloadData];
    [self.agendasTableView layoutIfNeeded]; // Force layout so things are updated before resetting the contentOffset.
    [self.agendasTableView setContentOffset:offset];
    
//    [self.agendasTableView reloadData];
}

-(void)loadNextDates{
    [[DateDataManager sharedInstance] updateEndDateTo:[[[DateDataManager sharedInstance] getEndDate] dateByAddingTimeInterval:kOneDayTime*35]];
    CGPoint offset = self.agendasTableView.contentOffset;
//    offset.y = kAgendaTableViewHeaderHeight*30;
    [self.agendasTableView reloadData];
    [self.agendasTableView layoutIfNeeded]; // Force layout so things are updated before resetting the contentOffset.
    [self.agendasTableView setContentOffset:offset];
    
    //    [self.agendasTableView reloadData];
}

#pragma mark - month button action

-(void)monthButtonTapped{
    if(isMonthViewVisible){
        [self hideMonthsView];
    }else{
        [self showMonthsView];
    }
   
}

-(void)todayButtonTapped{
    
    [_agendasTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[[DateDataManager sharedInstance] getPositionOfTodayDate]] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    if(isMonthViewVisible){
        UICollectionView *monthsCollecitonView = [monthsView getCollectionView];
        [monthsCollecitonView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[[DateDataManager sharedInstance] getPositionOfTodayDate] inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}

-(void)showMonthsView{
    [monthsView setFrame:CGRectZero];
    [self.view addSubview:monthsView];
    [UIView animateWithDuration:.3 animations:^{
        [monthsView setFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 6*kMonthsCollectionViewCellHeight)];
        CGRect tableFrame = _agendasTableView.frame;
        tableFrame.origin.y = tableFrame.origin.y+6*kMonthsCollectionViewCellHeight;
        [_agendasTableView setFrame:tableFrame];
        [monthsView setAlpha:1.0];
        [monthsView reloadCollection];
        monthButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    isMonthViewVisible = YES;
}
-(void)hideMonthsView{
    [UIView animateWithDuration:.3 animations:^{
        [monthsView setFrame:CGRectZero];
        CGRect tableFrame = _agendasTableView.frame;
        tableFrame.origin.y = tableFrame.origin.y-6*kMonthsCollectionViewCellHeight;
        [_agendasTableView setFrame:tableFrame];
        [monthsView setAlpha:0.0];
        [monthsView removeFromSuperview];
        monthButton.imageView.transform = CGAffineTransformMakeRotation(M_PI - 3.14159);
    }];
    isMonthViewVisible = NO;
}

#pragma mark - Months View Delegate

-(void)changeMonthTitleWithPosition:(NSInteger)position{
    [[DateDataManager sharedInstance] setCurrentPosition:position];
    NSDate *dateForSection = [[DateDataManager sharedInstance] getDateForPosition:position];
    NSString *monthString = [GenericFunctions getMonthStringForDate:dateForSection];
    [monthButton setTitle:monthString forState:UIControlStateNormal];

}

-(void)didSelectItemAtPosition:(NSInteger)position{
    [self.agendasTableView reloadData];
    [self.agendasTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:position] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

@end
