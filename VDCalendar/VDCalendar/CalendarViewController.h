//
//  ViewController.h
//  VDCalendar
//
//  Created by Vikas Dadheech on 05/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MonthsView;
@class AgendaTableView;

@interface CalendarViewController : UIViewController

-(AgendaTableView *)getAgendaTableView;

-(MonthsView *)getMonthsView;

@end

