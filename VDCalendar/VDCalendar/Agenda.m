//
//  Agenda.m
//  VDCalendar
//
//  Created by Vikas Dadheech on 10/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import "Agenda.h"

@implementation Agenda

-(id)initWithDictionary:(NSDictionary *)dicionary{
    self = [super init];
    if(self){
        self.title = [dicionary objectForKey:@"title"];
        self.type = [dicionary objectForKey:@"type"];
        self.venue = [dicionary objectForKey:@"venue"];
        self.location = [dicionary objectForKey:@"location"];
        self.time = [dicionary objectForKey:@"time"];
        self.desc = [dicionary objectForKey:@"desc"];
        self.url = [dicionary objectForKey:@"url"];
    }
    return self;
}

@end
