//
//  PNLineChart.h
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PNChartDelegate.h"

@interface PNLineChart : UIView

/**
 * This method will call and troke the line in animation
 */

- (void)strokeChart;

@property (nonatomic, retain) id<PNChartDelegate> delegate;

@property (nonatomic) NSArray *xLabels;

@property (nonatomic) NSArray *yLabels;

/**
 * Array of `LineChartData` objects, one for each line.
 */
@property (nonatomic) NSArray *chartData;

@property (nonatomic) NSMutableArray *pathPoints;

@property (nonatomic) CGFloat xLabelWidth;

@property (nonatomic) UIFont *xLabelFont;

@property (nonatomic) UIColor *xLabelColor;

@property (nonatomic) CGFloat yValueMax;

@property (nonatomic) CGFloat yValueMin;

@property (nonatomic) NSInteger yLabelNum;

@property (nonatomic) CGFloat yLabelHeight;

@property (nonatomic) UIFont *yLabelFont;

@property (nonatomic) UIColor *yLabelColor;

@property (nonatomic) CGFloat chartCavanHeight;

@property (nonatomic) CGFloat chartCavanWidth;

@property (nonatomic) CGFloat chartMargin;

@property (nonatomic) BOOL showLabel;

/**
 *  show CoordinateAxis ornot, Default is not
 */
@property (nonatomic, getter = isShowCoordinateAxis) BOOL showCoordinateAxis;
@property (nonatomic) UIColor *axisColor;
@property (nonatomic) CGFloat axisWidth;

@property (nonatomic, strong) NSString *xUnit;
@property (nonatomic, strong) NSString *yUnit;

/**
 *  String formatter for float values in y labels. If not set, defaults to @"%1.f"
 */
@property (nonatomic, strong) NSString *yLabelFormat;

- (void)setXLabels:(NSArray *)xLabels withWidth:(CGFloat)width;

@end
