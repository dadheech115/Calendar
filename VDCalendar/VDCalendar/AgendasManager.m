//
//  AgendasManager.m
//  VDCalendar
//
//  Created by Vikas Dadheech on 10/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import "AgendasManager.h"
#import "AgendasCollection.h"

@implementation AgendasManager{
    NSMutableArray *agendaCollectionArray;
    NSMutableDictionary *agendasCollectionDictionary;
}

-(id)init{
    self = [super init];
    if(self){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Agenda" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        agendaCollectionArray = [NSMutableArray new];
        agendasCollectionDictionary = [NSMutableDictionary new];
        for(NSDictionary *jsonDictionary in jsonData) {
            // Parse JSON to events
            AgendasCollection *agendaCollection = [[AgendasCollection alloc] initWithDictionary:jsonDictionary];
            [agendaCollectionArray addObject:agendaCollection];
            [agendasCollectionDictionary setObject:agendaCollection.agendas forKey:agendaCollection.date];
            
        }
    }
    return self;
}

-(NSArray *)getAgendaCollectionArray{
    return [NSArray arrayWithArray:agendaCollectionArray];
}

-(NSDictionary *)getAgendaCollectionDictionary{
    return [NSDictionary dictionaryWithDictionary:agendasCollectionDictionary];
}

@end
