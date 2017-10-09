//
//  VDCalendarTests.m
//  VDCalendarTests
//
//  Created by Vikas Dadheech on 05/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CalendarViewController.h"
#import "MonthsView.h"
#import "GenericFunctions.h"
#import "DateDataManager.h"

#define kTestIndexForSynchronisationOfAgendaView 275
#define kTestIndexForSynchronisationOfMonthView 167
#define kTestIndexForSynchronisationOfMonthsAndAgendaView 29

@interface VDCalendarTests : XCTestCase


@end

@implementation VDCalendarTests{
    XCUIApplication *application;
    
    CalendarViewController *calendarViewController;
}

- (void)setUp {
    [super setUp];
    calendarViewController = [[CalendarViewController alloc] init];
    [calendarViewController viewDidLoad];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


/*
 Test Case to check whether current position is being set properly in Date Data Manager after a scroll
 
 If after the scroll, the date string for current position is equal to date string of header of top most visible section then it is working properly.
 */
- (void)testSynchronisationOfAgendaView{
    
    UITableView *agendaTableView = [calendarViewController getAgendaTableView];
    
    //Scrolling the table
    [agendaTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kTestIndexForSynchronisationOfAgendaView] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    //Getting Date string for current position
    NSString *dateString = [GenericFunctions getAgendaSectionTitleForDate:[[DateDataManager sharedInstance] getDateForPosition:[[DateDataManager sharedInstance] getCurrentPosition]]];
    
    
    UITableViewCell *topVisibleCell = [[agendaTableView visibleCells] objectAtIndex:0];
    NSIndexPath *indexPathForVisibleCell = [agendaTableView indexPathForCell:topVisibleCell];
    UITableViewHeaderFooterView *headerView = [agendaTableView headerViewForSection:indexPathForVisibleCell.section];
    NSString *headerString = [headerView.textLabel text]; // Getting title of top most visbile header view
    
    XCTAssert([headerString isEqualToString:dateString]);
    
    
}


/*
 Test Case to check whether current position is being set properly in Date Data Manager after a scroll of collection view
 
 If after the scroll, the date string for current position is equal to date string of first visible cell then it is working properly.
 */


- (void)testSynchronisationOfMonthsView{
    
    MonthsView *monthsView = [calendarViewController getMonthsView];
    UICollectionView *monthsCollectionView = [monthsView getCollectionView];
    
    //Scrolling the table
    [monthsCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:kTestIndexForSynchronisationOfMonthView inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    
    //Getting Date string for current position
    NSString *dateString = [GenericFunctions getMonthStringForDate:[[DateDataManager sharedInstance] getDateForPosition:[[DateDataManager sharedInstance] getCurrentPosition]]];
    
    
    
    NSIndexPath *indexPathForVisibleCell = [monthsCollectionView indexPathForItemAtPoint:CGPointMake(10, monthsCollectionView.contentOffset.y+10)];
    
    NSString *headerString = [GenericFunctions getMonthStringForDate:[[DateDataManager sharedInstance] getDateForPosition:indexPathForVisibleCell.row]]; // Getting title of top most visbile header view
    
    XCTAssert([headerString isEqualToString:dateString]);
    
    
}

/*
 Test Case to check whether selecting a cell in months collection, scrolls the agenda table view to the accurate date
 
 If after the scroll, the date string of top cell in table view is equal to date string of index of cell selected in collection view then it is working properly.
 */


- (void)testSynchronisationOfMonthsWithAgendaView{
    
    MonthsView *monthsView = [calendarViewController getMonthsView];
    UICollectionView *monthsCollectionView = [monthsView getCollectionView];
    
    //Scrolling the table
    [monthsCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:kTestIndexForSynchronisationOfMonthsAndAgendaView inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    
    [monthsCollectionView.delegate collectionView:monthsCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:kTestIndexForSynchronisationOfMonthsAndAgendaView inSection:0]];
    
    
   NSString *monthsDateString = [GenericFunctions getDateTitleWithMonthForDate:[[DateDataManager sharedInstance] getDateForPosition:kTestIndexForSynchronisationOfMonthsAndAgendaView]];
    //Getting Date string for current position
    UITableView *agendaTableView = [calendarViewController getAgendaTableView];
    UITableViewCell *topVisibleCell = [[agendaTableView visibleCells] objectAtIndex:0];
    NSIndexPath *indexPathForVisibleCell = [agendaTableView indexPathForCell:topVisibleCell];
    
    NSString *agendaDateString = [GenericFunctions getDateTitleWithMonthForDate:[[DateDataManager sharedInstance] getDateForPosition:indexPathForVisibleCell.section]];
    
    XCTAssert([monthsDateString isEqualToString:agendaDateString]);
    
    
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
