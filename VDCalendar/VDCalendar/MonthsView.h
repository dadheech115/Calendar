//
//  MonthsView.h
//  VDCalendar
//
//  Created by Vikas Dadheech on 06/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MonthsViewDelegate <NSObject>

@optional
-(void)changeMonthTitleWithPosition:(NSInteger)position;
-(void)didSelectItemAtPosition:(NSInteger)position;

@end

@interface MonthsView : UIView

@property (nonatomic, weak) id <MonthsViewDelegate> delegate;

-(void)setCurrentPositionOfCalendar:(NSInteger)currentPosition;
-(void)reloadCollection;

@end
