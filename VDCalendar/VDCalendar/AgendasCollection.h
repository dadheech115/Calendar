//
//  AgendasCollection.h
//  VDCalendar
//
//  Created by Vikas Dadheech on 10/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Agenda;

@interface AgendasCollection : NSObject
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSArray<Agenda *> *agendas;


-(id)initWithDictionary:(NSDictionary *)dictionary;
@end
