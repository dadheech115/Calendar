//
//  AgendaTableView.m
//  VDCalendar
//
//  Created by Vikas Dadheech on 10/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import "AgendaTableView.h"
#import "AgendasManager.h"
#import "AgendaDetailTableViewCell.h"
#import "GenericFunctions.h"
#import "DateDataManager.h"

#define kAgendaTableViewHeaderHeight 30.0
#define kAgendaTableViewCellHeight 120.0

@interface AgendaTableView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AgendaTableView{
    AgendasManager *agendaManager;
    NSDictionary *agendasCollectionDictionary;
    BOOL isFirstTimeLoading;
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
        [self setup];
    }
    return self;
}

-(void)setup{
    
    //Setting up static data from JSON
    agendaManager = [[AgendasManager alloc] init];
    agendasCollectionDictionary = [agendaManager getAgendaCollectionDictionary];
    
    //setting up table view
    self.delegate = self;
    self.dataSource = self;
    isFirstTimeLoading = YES;
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setShowsVerticalScrollIndicator:NO];
    
    //Registering header view and cell's class for reusability
    [self registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"AgendasHeader"];
    [self registerClass:[AgendaDetailTableViewCell class] forCellReuseIdentifier:@"AgendaDetailTableViewCell"];
    
    //Scrolling the table to today's date at the launch
//    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday
//                                                       fromDate:[NSDate date]];
//    
//    weekday--;
//    weekday = weekday+7;
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[[DateDataManager sharedInstance] getPositionOfTodayDate]] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - Agenda Table View delegates and data sources

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[DateDataManager sharedInstance] getNumberOfDays];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *dateString = [[DateDataManager sharedInstance] getDateInDDMMYYYFormat:section];
    NSArray *agendasArray = [agendasCollectionDictionary objectForKey:dateString];
    if(agendasArray.count)
        return agendasArray.count;
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kAgendaTableViewHeaderHeight;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *dateString = [[DateDataManager sharedInstance] getDateInDDMMYYYFormat:indexPath.section];
    NSArray *agendasArray = [agendasCollectionDictionary objectForKey:dateString];
    if(agendasArray.count)
        return kAgendaTableViewCellHeight;
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kAgendaTableViewCellHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *HeaderIdentifier = @"AgendasHeader";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    
    if(!headerView) {
        headerView =[[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"AgendasHeader"];
    }
//    NSDate *dateForSection = [[DateDataManager sharedInstance] getDateForPosition:section];
    [headerView.textLabel setText:[[DateDataManager sharedInstance] getAgendaTitleForPosition:section]];
    [headerView.contentView setBackgroundColor:kThemeColor];
    return headerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *dateString = [[DateDataManager sharedInstance] getDateInDDMMYYYFormat:indexPath.section];
    NSArray *agendasArray = [agendasCollectionDictionary objectForKey:dateString];
    if(agendasArray.count){
        AgendaDetailTableViewCell *agendaDetailTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"AgendaDetailTableViewCell"];
        [agendaDetailTableViewCell setupCellDataWithAgendaDetails:[agendasArray objectAtIndex:indexPath.row]];
        return agendaDetailTableViewCell;
    }
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"NoEventsCell"];
    if(!tableCell){
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoEventsCell"];
    }
    [tableCell.textLabel setText:@"No events"];
    return tableCell;
}

#pragma mark - scroll view delegates

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //Hiding months view if user starts scrolling
    if(self.agendaTableViewDelegate && [self.agendaTableViewDelegate respondsToSelector:@selector(hideMonthsView)]){
        [self.agendaTableViewDelegate hideMonthsView];
    }
    
}

-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //Checking scroll view's content offset to load next or previous set of dates accordingly
    if(!isFirstTimeLoading){
    if(scrollView.contentOffset.y<120){
        [self loadPreviousDates];
    }else if(scrollView.contentOffset.y+scrollView.frame.size.height>=scrollView.contentSize.height-210){
        [self loadNextDates];
    }
    }
    else{
        isFirstTimeLoading = NO;
    }
    //Changing the title of month button to display the month of top most cell
    NSArray *temp = [(UITableView *)scrollView indexPathsForVisibleRows];
    NSIndexPath *topIndexPath = [temp objectAtIndex:0];
    
    if(self.agendaTableViewDelegate && [self.agendaTableViewDelegate respondsToSelector:@selector(changeMonthTitleWithPosition:)]){
        [self.agendaTableViewDelegate changeMonthTitleWithPosition:topIndexPath.section];
    };
    
}


#pragma mark - load more rows

-(void)loadPreviousDates{
    [[DateDataManager sharedInstance] updateStartDateTo:[[[DateDataManager sharedInstance] getStartDate] dateByAddingTimeInterval:-kOneDayTime*35]];
    CGPoint offset = self.contentOffset;
    offset.y = kAgendaTableViewHeaderHeight*30;
    [self reloadData];
    [self layoutIfNeeded]; // Force layout so things are updated before resetting the contentOffset.
    [self setContentOffset:offset];
    
    //    [self.agendasTableView reloadData];
}

-(void)loadNextDates{
    [[DateDataManager sharedInstance] updateEndDateTo:[[[DateDataManager sharedInstance] getEndDate] dateByAddingTimeInterval:kOneDayTime*35]];
    CGPoint offset = self.contentOffset;
    [self reloadData];
    [self layoutIfNeeded]; // Force layout so things are updated before resetting the contentOffset.
    [self setContentOffset:offset];
    
    //    [self.agendasTableView reloadData];
}


@end
