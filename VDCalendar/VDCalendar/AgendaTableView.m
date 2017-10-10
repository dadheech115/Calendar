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
    agendaManager = [[AgendasManager alloc] init];
    agendasCollectionDictionary = [agendaManager getAgendaCollectionDictionary];
    self.delegate = self;
    self.dataSource = self;
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setShowsVerticalScrollIndicator:NO];
    [self registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"AgendasHeader"];
    [self registerClass:[AgendaDetailTableViewCell class] forCellReuseIdentifier:@"AgendaDetailTableViewCell"];
    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday
                                                       fromDate:[NSDate date]];
    
    weekday--;
    weekday = weekday+7;
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:weekday] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - Agenda Table View delegates and data sources

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[DateDataManager sharedInstance] getNumberOfDays];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *dateString = [GenericFunctions getDateStringInDDMMYYYYForDate:[[DateDataManager sharedInstance] getDateForPosition:section]];
    NSArray *agendasArray = [agendasCollectionDictionary objectForKey:dateString];
    if(agendasArray.count)
        return agendasArray.count;
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kAgendaTableViewHeaderHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *dateString = [GenericFunctions getDateStringInDDMMYYYYForDate:[[DateDataManager sharedInstance] getDateForPosition:indexPath.section]];
    NSArray *agendasArray = [agendasCollectionDictionary objectForKey:dateString];
    if(agendasArray.count)
        return kAgendaTableViewCellHeight;
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *HeaderIdentifier = @"AgendasHeader";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    
    if(!headerView) {
        headerView =[[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"AgendasHeader"];
    }
    NSDate *dateForSection = [[DateDataManager sharedInstance] getDateForPosition:section];
    [headerView.textLabel setText:[GenericFunctions getAgendaSectionTitleForDate:dateForSection]];
    [headerView.contentView setBackgroundColor:kThemeColor];
    return headerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *dateString = [GenericFunctions getDateStringInDDMMYYYYForDate:[[DateDataManager sharedInstance] getDateForPosition:indexPath.section]];
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
    if(self.agendaTableViewDelegate && [self.agendaTableViewDelegate respondsToSelector:@selector(hideMonthsView)]){
        [self.agendaTableViewDelegate hideMonthsView];
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y<120){
        [self loadPreviousDates];
    }else if(scrollView.contentOffset.y+scrollView.frame.size.height>=scrollView.contentSize.height-210){
        [self loadNextDates];
    }
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
