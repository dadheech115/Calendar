//
//  DateDataManager.m
//  VDCalendar
//
//  Created by Vikas Dadheech on 05/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import "DateDataManager.h"



@interface DateDataManager()

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) NSInteger currentPosition;



@end

@implementation DateDataManager

+ (DateDataManager*)sharedInstance {
    static DateDataManager *_sharedInstance;
    if(!_sharedInstance) {
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            _sharedInstance = [[super alloc] init];
            
            //Setting up Innitial start date and end date for the calendar
            
            NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday
                                                               fromDate:[NSDate date]];
            
//            weekday--;
//            weekday = weekday+7;
            _sharedInstance.startDate = [[NSDate date] dateByAddingTimeInterval:-kOneDayTime*(weekday+6)];
            _sharedInstance.endDate = [[NSDate date] dateByAddingTimeInterval:kOneDayTime*(28-weekday)];
            
        });
    }
    
    return _sharedInstance;
}


-(void)updateStartDateTo:(NSDate *)date{
    _currentPosition = [self.startDate timeIntervalSinceDate:date]/kOneDayTime+_currentPosition;
    self.startDate = date;
    
}

-(void)updateEndDateTo:(NSDate *)date{
    self.endDate = date;
}

-(NSDate *)getStartDate{
    return self.startDate;
}

-(NSDate *)getEndDate{
    return self.endDate;
}

-(NSInteger)getNumberOfDays{
    return [self.endDate timeIntervalSinceDate:self.startDate]/kOneDayTime;
}

- (NSDate *)getDateForPosition: (NSUInteger) position{
    NSDate *date = [_startDate dateByAddingTimeInterval:position * kOneDayTime];
//    if([date compare:_endDate] ==  NSOrderedDescending)
//        return nil;
    return date;
}

- (NSUInteger)getPositionOfDate:(NSDate *)date {
    return [date timeIntervalSinceDate:_startDate] / kOneDayTime;
}

-(void)setCurrentPosition:(NSInteger)currentPosition{
    _currentPosition = currentPosition;
}
-(NSInteger)getCurrentPosition{
    return _currentPosition;
}

@end