//
//  AgendaDetailTableViewCell.h
//  VDCalendar
//
//  Created by Vikas Dadheech on 10/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Agenda;

@interface AgendaDetailTableViewCell : UITableViewCell

-(void)setupCellDataWithAgendaDetails:(Agenda *)agenda;

@end
