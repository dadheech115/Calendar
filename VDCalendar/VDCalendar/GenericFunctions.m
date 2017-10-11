//
//  GenericFunctions.m
//  VDCalendar
//
//  Created by Vikas Dadheech on 05/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import "GenericFunctions.h"

@implementation GenericFunctions

+ (NSString *) getAgendaSectionTitleForDate: (NSDate *) date {
    if(date) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        
        
        [formatter setDateFormat:@"EEEE, d MMM"];
        
            return [formatter stringFromDate:date];
    }
    return nil;
}

+ (NSString *) getMonthStringForDate: (NSDate *) date {
    if(date) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        
        
        [formatter setDateFormat:@"MMM, YYYY"];
        
        return [formatter stringFromDate:date];
    }
    return nil;
}
+ (NSString *) getDateTitle: (NSDate *) date {
    if(date) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        
        
        [formatter setDateFormat:@"d"];
        
        return [formatter stringFromDate:date];
    }
    return nil;
}

+ (NSString *) getDateTitleWithMonthForDate: (NSDate *) date {
    if(date) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        
        
        [formatter setDateFormat:@"d MMM"];
        
        return [formatter stringFromDate:date];
    }
    return nil;
}

+ (NSString *) getDateStringInDDMMYYYYForDate: (NSDate *) date {
    if(date) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        
        
        [formatter setDateFormat:@"dd/MM/yyyy"];
        
        return [formatter stringFromDate:date];
    }
    return nil;
}


@end
