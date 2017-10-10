//
//  ViewController.m
//  VDCalendar
//
//  Created by Vikas Dadheech on 05/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import "CalendarViewController.h"
#import "DateDataManager.h"
#import "GenericFunctions.h"
#import "MonthsView.h"
#import "AgendaTableView.h"

@interface CalendarViewController ()<UIScrollViewDelegate,MonthsViewDelegate,AgendaTableViewDelegate>

@property (nonatomic, strong) AgendaTableView *agendasTableView;

@end

@implementation CalendarViewController{
    UIButton *monthButton;
    UIButton *todayButton;
    MonthsView *monthsView;
    BOOL isMonthViewVisible;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAgendasTableView];
    [self setupNavigationBar];
    [self setupMonthsView];
    
}


-(void)setupAgendasTableView{
    self.agendasTableView  = [[AgendaTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.agendasTableView.agendaTableViewDelegate = self;
    [self.view addSubview:self.agendasTableView];
}

-(AgendaTableView *)getAgendaTableView{
    return _agendasTableView;
}

-(void)setupNavigationBar{
    [self setupMonthsButton];
    [self setupTodayButton];
    [self.navigationController.navigationBar setBarTintColor:kThemeColor];
    
}

-(void)setupMonthsButton{
    monthButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 0, 100, 40)];
    NSDate *dateForSection = [[DateDataManager sharedInstance] getDateForPosition:0];
    NSString *monthString = [GenericFunctions getMonthStringForDate:dateForSection];
    
    [monthButton setTitle:monthString forState:UIControlStateNormal];
    [monthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    monthButton.imageEdgeInsets = UIEdgeInsetsMake(0., monthButton.frame.size.width - 20, 0., 0.);
    monthButton.titleEdgeInsets = UIEdgeInsetsMake(0., -20., 0., 20.);
    [monthButton setImage:[UIImage imageNamed:@"DownArrow"] forState:UIControlStateNormal];
    [monthButton addTarget:self action:@selector(monthButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:monthButton]];
}

-(void)setupTodayButton{
    todayButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 0, 40, 40)];
    [todayButton setBackgroundImage:[UIImage imageNamed:@"Calendar"] forState:UIControlStateNormal];
    [todayButton setTitle:[GenericFunctions getDateTitle:[NSDate date]] forState:UIControlStateNormal];
    [todayButton setContentEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    [todayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [todayButton addTarget:self action:@selector(todayButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:todayButton]];
}

-(void)setupMonthsView{
    monthsView = [[MonthsView alloc] initWithFrame:CGRectMake(0,64, [UIScreen mainScreen].bounds.size.width, 6*kMonthsCollectionViewCellHeight)];
    monthsView.delegate = self;
    isMonthViewVisible = NO;
}


-(MonthsView *)getMonthsView{
    return monthsView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - month button action

-(void)monthButtonTapped{
    if(isMonthViewVisible){
        [self hideMonthsView];
    }else{
        [self showMonthsView];
    }
   
}

-(void)todayButtonTapped{
    
    [_agendasTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[[DateDataManager sharedInstance] getPositionOfTodayDate]] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    if(isMonthViewVisible){
        UICollectionView *monthsCollecitonView = [monthsView getCollectionView];
        [monthsCollecitonView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[[DateDataManager sharedInstance] getPositionOfTodayDate] inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}

-(void)showMonthsView{
    [monthsView setFrame:CGRectZero];
    [self.view addSubview:monthsView];
    [UIView animateWithDuration:.3 animations:^{
        [monthsView setFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 6*kMonthsCollectionViewCellHeight)];
        CGRect tableFrame = _agendasTableView.frame;
        tableFrame.origin.y = tableFrame.origin.y+6*kMonthsCollectionViewCellHeight;
        [_agendasTableView setFrame:tableFrame];
        [monthsView setAlpha:1.0];
        [monthsView reloadCollection];
        monthButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        
    }];
    isMonthViewVisible = YES;
}
-(void)hideMonthsView{
    if(!isMonthViewVisible)
        return;
    [UIView animateWithDuration:.3 animations:^{
        [monthsView setFrame:CGRectZero];
        CGRect tableFrame = _agendasTableView.frame;
        tableFrame.origin.y = tableFrame.origin.y-6*kMonthsCollectionViewCellHeight;
        [_agendasTableView setFrame:tableFrame];
        [monthsView setAlpha:0.0];
        [monthsView removeFromSuperview];
        monthButton.imageView.transform = CGAffineTransformMakeRotation(M_PI - 3.14159);
    }];
    isMonthViewVisible = NO;
}

#pragma mark - Months View and Agenda Table View Delegate

-(void)changeMonthTitleWithPosition:(NSInteger)position{
    [[DateDataManager sharedInstance] setCurrentPosition:position];
    NSDate *dateForSection = [[DateDataManager sharedInstance] getDateForPosition:position];
    NSString *monthString = [GenericFunctions getMonthStringForDate:dateForSection];
    [monthButton setTitle:monthString forState:UIControlStateNormal];

}

#pragma mark - Months View Delegate

-(void)didSelectItemAtPosition:(NSInteger)position{
    [self.agendasTableView reloadData];
    [self.agendasTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:position] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


@end
