//
//  AgendasCollection.m
//  VDCalendar
//
//  Created by Vikas Dadheech on 10/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import "AgendasCollection.h"
#import "Agenda.h"

@implementation AgendasCollection

-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        self.date = [dictionary objectForKey:@"date"];
        NSMutableArray *agendasArray = [NSMutableArray new];
        
        //Iterating through array to parse all agendas
        for(NSDictionary *tempAgendaDictionary in [dictionary objectForKey:@"agendas"]){
            Agenda *agenda = [[Agenda alloc] initWithDictionary:tempAgendaDictionary];
            [agendasArray addObject:agenda];
        }
        self.agendas = [NSArray arrayWithArray:(NSArray *)agendasArray];
        
    }
    return self;
    
}

@end
