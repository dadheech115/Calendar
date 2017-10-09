//
//  DateDataManager.h
//  VDCalendar
//
//  Created by Vikas Dadheech on 05/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateDataManager : NSObject

+ (DateDataManager*)sharedInstance;

-(void)updateStartDateTo:(NSDate *)date;
-(void)updateEndDateTo:(NSDate *)date;

-(NSDate *)getStartDate;
-(NSDate *)getEndDate;

-(NSInteger)getNumberOfDays;


- (NSDate *)getDateForPosition: (NSUInteger) position;

- (NSUInteger)getPositionOfDate:(NSDate *)date;

@end
