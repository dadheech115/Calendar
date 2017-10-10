//
//  AgendaTableView.h
//  VDCalendar
//
//  Created by Vikas Dadheech on 10/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AgendaTableViewDelegate <NSObject>

@optional
-(void)changeMonthTitleWithPosition:(NSInteger)position;
-(void)hideMonthsView;

@end


@interface AgendaTableView : UITableView

@property (nonatomic, weak) id <AgendaTableViewDelegate> agendaTableViewDelegate;

-(void)loadPreviousDates;
-(void)loadNextDates;

@end
