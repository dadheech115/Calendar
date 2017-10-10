//
//  GenericFunctions.h
//  VDCalendar
//
//  Created by Vikas Dadheech on 05/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GenericFunctions : NSObject

+ (NSString *) getAgendaSectionTitleForDate: (NSDate *) date;

+ (NSString *) getMonthStringForDate: (NSDate *) date;

+ (NSString *) getDateTitle: (NSDate *) date;

+ (NSString *) getDateTitleWithMonthForDate: (NSDate *) date;

+ (NSString *) getDateStringInDDMMYYYYForDate: (NSDate *) date;

@end
