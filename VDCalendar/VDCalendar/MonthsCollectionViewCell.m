//
//  MonthsCollectionViewCell.m
//  VDCalendar
//
//  Created by Vikas Dadheech on 08/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import "MonthsCollectionViewCell.h"

@implementation MonthsCollectionViewCell{
    UILabel *dateLabel;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [dateLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:dateLabel];
        
    }
    return self;
}

-(void)prepareForReuse{
    [dateLabel setText:@""];
}

-(void)updateCellDataWithDateString:(NSString *)dateString{
    [dateLabel setText:dateString];
}
@end
