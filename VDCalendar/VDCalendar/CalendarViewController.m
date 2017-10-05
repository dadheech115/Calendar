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

#define kAgendaTableViewHeaderHeight 30.0

@interface CalendarViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *agendasTableView;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAgendasTableView];
    
}


-(void)setupAgendasTableView{
    self.agendasTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.agendasTableView.delegate = self;
    self.agendasTableView.dataSource = self;
    [self.agendasTableView setShowsVerticalScrollIndicator:NO];
    [self.agendasTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:5] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.view addSubview:self.agendasTableView];
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
    return 0;
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
    return headerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableCell = [UITableViewCell new];
    return tableCell;
}

#pragma mark - scroll view delegates

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y<0){
        [self loadPreviousDates];
    }
        
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y<120){
        [self loadPreviousDates];
    }else if(scrollView.contentOffset.y+scrollView.frame.size.height>=scrollView.contentSize.height-210){
        [self loadNextDates];
    }
}


#pragma mark - load more rows

-(void)loadPreviousDates{
    [[DateDataManager sharedInstance] updateStartDateTo:[[[DateDataManager sharedInstance] getStartDate] dateByAddingTimeInterval:-kOneMonthTime]];
    CGPoint offset = self.agendasTableView.contentOffset;
    offset.y = kAgendaTableViewHeaderHeight*30;
    [self.agendasTableView reloadData];
    [self.agendasTableView layoutIfNeeded]; // Force layout so things are updated before resetting the contentOffset.
    [self.agendasTableView setContentOffset:offset];
    
//    [self.agendasTableView reloadData];
}

-(void)loadNextDates{
    [[DateDataManager sharedInstance] updateEndDateTo:[[[DateDataManager sharedInstance] getEndDate] dateByAddingTimeInterval:kOneMonthTime]];
    CGPoint offset = self.agendasTableView.contentOffset;
//    offset.y = kAgendaTableViewHeaderHeight*30;
    [self.agendasTableView reloadData];
    [self.agendasTableView layoutIfNeeded]; // Force layout so things are updated before resetting the contentOffset.
    [self.agendasTableView setContentOffset:offset];
    
    //    [self.agendasTableView reloadData];
}

@end
