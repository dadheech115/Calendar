//
//  ViewController.h
//  VDCalendar
//
//  Created by Vikas Dadheech on 05/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MonthsView;

@interface CalendarViewController : UIViewController

-(UITableView *)getAgendaTableView;

-(MonthsView *)getMonthsView;

@end

