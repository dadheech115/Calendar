//
//  Agenda.h
//  VDCalendar
//
//  Created by Vikas Dadheech on 10/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Agenda : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *venue;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *url;

-(id)initWithDictionary:(NSDictionary *)dicionary;

@end
