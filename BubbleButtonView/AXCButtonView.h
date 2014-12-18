//
//  BBView.h
//  BubbleButtonView
//
//  Created by Benjamin Gordon on 1/8/13.
//  Copyright (c) 2013 Benjamin Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AXCButtonView;
@protocol AXCButtonViewDataSource
@required
- (NSInteger)numberOfButtonsInButtonView:(AXCButtonView *)buttonView;
- (UIButton *)buttonView:(AXCButtonView *)buttonView buttonForIndex:(NSInteger) index;
@end

@protocol AXCButtonViewDelegate
@optional
- (void)buttonView:(AXCButtonView *)buttonView didPressButtonAtIndex:(NSInteger) index;
@end


@interface AXCButtonView : UIView
@property (nonatomic, weak) id <AXCButtonViewDataSource> dataSource;
@property (nonatomic, weak) id <AXCButtonViewDelegate> delegate;
- (UIButton *) buttonForIndex:(NSInteger) index;
- (void) loadButtons;


-(void)fillBubbleViewWithButtons:(NSArray *)strings bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor fontSize:(float)fsize;
-(void)addBubbleButtonsWithInterval:(float)ftime;
-(void)removeBubbleButtonsWithInterval:(float)ftime;
-(void)clickedBubbleButton:(UIButton *)bubble;

@end

