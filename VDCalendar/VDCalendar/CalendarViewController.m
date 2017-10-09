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
    
    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday
                                                       fromDate:[NSDate date]];
    
    weekday--;
    weekday = weekday+7;
    [self.agendasTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:weekday] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.view addSubview:self.agendasTableView];
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kAgendaTableViewHeaderHeight)];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
    
    NSDate *dateForSection = [[DateDataManager sharedInstance] getDateForPosition:section];
    [dateLabel setText:[GenericFunctions getAgendaSectionTitleForDate:dateForSection]];
    [headerView addSubview:dateLabel];
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
    if(!monthsView){
        monthsView = [[MonthsView alloc] initWithFrame:CGRectMake(0,64, [UIScreen mainScreen].bounds.size.width, 6*kMonthsCollectionViewCellHeight)];
        monthsView.delegate = self;
        isMonthViewVisible = NO;
    }
    if(isMonthViewVisible){
        [self hideMonthsView];
    }else{
        [self showMonthsView];
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
