//
//  MonthsCollectionViewCell.m
//  VDCalendar
//
//  Created by Vikas Dadheech on 08/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import "MonthsCollectionViewCell.h"
#import "DateDataManager.h"
#import "GenericFunctions.h"

@implementation MonthsCollectionViewCell{
    UILabel *dateLabel;
    UILabel *monthLabel;
    CGRect initialFrameOfDateLabel;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        // Setting up date label of cell
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [dateLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:dateLabel];
        initialFrameOfDateLabel = dateLabel.frame;
        
        
        // Setting up month label of cell
        monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2)];
        [monthLabel setTextAlignment:NSTextAlignmentCenter];
        [monthLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.contentView addSubview:monthLabel];
        [monthLabel setHidden:YES];
        
    }
    return self;
}

-(void)prepareForReuse{
    [dateLabel setText:@""];
}

-(void)updateCellDataForPosition:(NSInteger)position{
    NSDate *dateForSection = [[DateDataManager sharedInstance] getDateForPosition:position];
    NSString *dateString = [GenericFunctions getDateTitleWithMonthForDate:dateForSection];
    NSArray *dateComponents = [dateString componentsSeparatedByString:@" "];
    
    //Checking for first day of month to display month text as well in cell
    if([[dateComponents objectAtIndex:0] isEqualToString:@"1"]){
        [monthLabel setHidden:NO];
        [monthLabel setText:[dateComponents objectAtIndex:1]];
        CGRect tempFrameOfDateLabel = dateLabel.frame;
        tempFrameOfDateLabel.origin.y = self.frame.size.height/2;
        tempFrameOfDateLabel.size.height = self.frame.size.height/2;
        dateLabel.frame = tempFrameOfDateLabel;
    }else{
        [monthLabel setHidden:YES];
        dateLabel.frame = initialFrameOfDateLabel;
    }

    [dateLabel setText:[dateComponents objectAtIndex:0]];
}
@end
