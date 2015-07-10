//
//  StatisticsViewController.m
//  biegus-iOS
//
//  Created by Krystian Paszek on 04.06.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import <SWRevealViewController.h>
#import "StatisticsViewController.h"
#import "BGSStats.h"
#import "Constants.h"
#import "JBBarChartView.h"
#import "JBChartHeaderView.h"
#import "JBBarChartFooterView.h"
#import "JBColorConstants.h"
#import "SelectSportViewController.h"

//Numerics
CGFloat const kJBBarChartViewControllerChartHeight = 250.0f;
CGFloat const kJBBarChartViewControllerChartPadding = 10.0f;
CGFloat const kJBBarChartViewControllerChartHeaderHeight = 80.0f;
CGFloat const kJBBarChartViewControllerChartHeaderPadding = 20.0f;
CGFloat const kJBBarChartViewControllerChartFooterHeight = 25.0f;
CGFloat const kJBBarChartViewControllerChartFooterPadding = 5.0f;
CGFloat const kJBBarChartViewControllerBarPadding = 1.0f;
NSInteger const kJBBarChartViewControllerNumBars = 12;
NSInteger const kJBBarChartViewControllerMaxBarHeight = 10;
NSInteger const kJBBarChartViewControllerMinBarHeight = 5;

@interface StatisticsViewController() <JBBarChartViewDelegate, JBBarChartViewDataSource, SelectSportProtocol, UIActionSheetDelegate>

@property NSInteger year;
@property NSString* sportType;
@property BGSMetricsType metricsType;

@property NSArray *chartData;

- (IBAction)test1:(id)sender;
- (IBAction)test2:(id)sender;
- (IBAction)test3:(id)sender;
- (IBAction)selectMetricsTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIButton *selectSportButton;
@property (weak, nonatomic) IBOutlet UIButton *selectMetricsButton;
@property (weak, nonatomic) IBOutlet UIButton *selectYearButton;
@property (weak, nonatomic) IBOutlet JBBarChartView *barChartView;
@property JBChartHeaderView *headerView;
@property UIActionSheet *actionSheet;
@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
//        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    //setting year
    NSDate *now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy";
    self.year = [[df stringFromDate:now] integerValue];
    
    //setting sport
    self.sportType = kCategoryRunnning;
    
    //setting metrics type
    self.metricsType = BGSMetricsTypeDistance;
    
    //set all buttons
    [self.selectYearButton setTitle:[NSString stringWithFormat:@"%lu", self.year] forState:UIControlStateNormal];
    [self.selectSportButton setTitle:[Constants fullNameForConst:self.sportType] forState:UIControlStateNormal];
    [self.selectMetricsButton setTitle:[Constants fullNameForMetrics:self.metricsType] forState:UIControlStateNormal];
    
    self.barChartView.delegate = self;
    self.barChartView.dataSource = self;
    self.barChartView.inverted = NO;
    self.barChartView.tintColor = [UIColor blueColor];
    //    [self.barChartView setState:JBChartViewStateCollapsed];
    self.barChartView.headerPadding = kJBBarChartViewControllerChartHeaderPadding;
    
    JBChartHeaderView *headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake(kJBBarChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBBarChartViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (kJBBarChartViewControllerChartPadding * 2), kJBBarChartViewControllerChartHeaderHeight)];
    headerView.titleLabel.text = @"Annual stats";
    headerView.subtitleLabel.text = @"Loading...";
    headerView.separatorColor = kJBColorBarChartHeaderSeparatorColor;
    self.barChartView.headerView = headerView;
    _headerView = headerView;
    
    JBBarChartFooterView *footerView = [[JBBarChartFooterView alloc] initWithFrame:CGRectMake(kJBBarChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBBarChartViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (kJBBarChartViewControllerChartPadding * 2), kJBBarChartViewControllerChartFooterHeight)];
    footerView.padding = kJBBarChartViewControllerChartFooterPadding;
    footerView.leftLabel.text = [NSString stringWithFormat:@"sty"];
    footerView.leftLabel.textColor = [UIColor whiteColor];
    footerView.rightLabel.text = [NSString stringWithFormat:@"gru"];;
    footerView.rightLabel.textColor = [UIColor whiteColor];
    self.barChartView.footerView = footerView;
    
    [self.barChartView setMinimumValue:0];
    
    _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Distance", @"Duration", @"Calories", nil];
    
    [self loadData];
}

- (void) loadData {
    [BGSStats getStatsForYear:self.year sport:self.sportType metrics:self.metricsType withCompletionBlock:^(NSArray *objects) {
        //        NSLog(@"%@", objects);
        
        self.chartData = objects;
        _headerView.titleLabel.text = [Constants fullNameForConst:self.sportType];
        _headerView.subtitleLabel.text = [Constants fullNameForMetrics:self.metricsType];
        [self.barChartView reloadData];
    }];
}

- (IBAction)test1:(id)sender {
    [BGSStats getStatsForYear:2015 sport:kCategoryRunnning metrics:BGSMetricsTypeDistance withCompletionBlock:^(NSArray *objects) {
        NSLog(@"hehe");
    }];
}

- (IBAction)test2:(id)sender {
    [BGSStats getStatsForYear:2015 sport:kCategoryRunnning metrics:BGSMetricsTypeDuration withCompletionBlock:^(NSArray *objects) {
        NSLog(@"hehe");
    }];
}

- (IBAction)test3:(id)sender {
    [BGSStats getStatsForYear:2015 sport:kCategoryRunnning metrics:BGSMetricsTypeCalories withCompletionBlock:^(NSArray *objects) {
        NSLog(@"hehe");
    }];
}

- (IBAction)selectMetricsTapped:(id)sender {
    [_actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            self.metricsType = BGSMetricsTypeDistance;
            break;
            
        case 1:
            self.metricsType = BGSMetricsTypeDuration;
            break;
            
        case 2:
            self.metricsType = BGSMetricsTypeCalories;
            break;
            
        default:
            return;
//            break;
    }
    
    [self.selectMetricsButton setTitle:[Constants fullNameForMetrics:self.metricsType] forState:UIControlStateNormal];
    [self loadData];
}

- (BOOL)shouldExtendSelectionViewIntoHeaderPaddingForChartView:(JBChartView *)chartView
{
    return YES;
}

- (BOOL)shouldExtendSelectionViewIntoFooterPaddingForChartView:(JBChartView *)chartView
{
    return NO;
}

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView {
    return _chartData.count;
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index {
    return [_chartData[index] floatValue];
}

- (UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index {
    UIColor *color = nil;
    switch (self.metricsType) {
        case BGSMetricsTypeDistance:
            color = [UIColor blueColor];
            break;
            
        case BGSMetricsTypeDuration:
            color = [UIColor greenColor];
            break;
            
        case BGSMetricsTypeCalories:
            color = [UIColor orangeColor];
            break;
            
        default:
            break;
    }
    
    
    return color;
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index touchPoint:(CGPoint)touchPoint {
    [self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
    [self.tooltipView setText:[NSString stringWithFormat:@"%@", _chartData[index]]];
}

- (void)didDeselectBarChartView:(JBBarChartView *)barChartView
{
    [self setTooltipVisible:NO animated:YES];
}

- (IBAction)toggleBarsState:(id)sender {
    [self.barChartView setState:self.barChartView.state == JBChartViewStateExpanded ? JBChartViewStateCollapsed : JBChartViewStateExpanded animated:YES];
}

- (JBChartView *)chartView {
    return self.barChartView;
}

- (void)didSelectSportWithName:(NSString *)sportName {
    self.sportType = sportName;
    [self.selectSportButton setTitle:[Constants fullNameForConst:self.sportType] forState:UIControlStateNormal];
    [self loadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"selectSportFromStatisticsSegue"]) {
        SelectSportViewController *destinationVC = (SelectSportViewController*)segue.destinationViewController;
        destinationVC.delegate = self;
    }
}


@end
