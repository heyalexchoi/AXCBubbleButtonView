//
//  BBView.m
//  BubbleButtonView
//
//  Created by Benjamin Gordon on 1/8/13.
//  Copyright (c) 2013 Benjamin Gordon. All rights reserved.
//

#import "AXCButtonView.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const buttonPadding = 10;

@interface AXCButtonView ()
@property (strong, nonatomic) NSMutableArray * buttons;
@end
@implementation AXCButtonView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Bubble Button Methods

- (UIButton *)buttonForIndex:(NSInteger)index
{
    if (self.buttons.count > index) {
        return self.buttons[index];
    }
    return nil;
}

- (void) loadButtons
{
    NSMutableArray * buttons = [NSMutableArray new];
    NSInteger count = [self.dataSource numberOfButtonsInButtonView:self];
    
    for (int i = 0; i < count; i++) {
        UIButton * button = [self.dataSource buttonView:self buttonForIndex:i];
//        CGPoint
        if (self.buttons.count > 0) {
            
        }
//        [self addSubview:button];
    }
}

-(void)fillBubbleViewWithButtons:(NSArray *)strings bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor fontSize:(float)fsize {
    // Init array
    self.buttons = [@[] mutableCopy];
    
    // First check to see if there are already buttons there. If there aren't any
    // subviews to bubbleView, then add these buttons.
    
    if (self.subviews.count == 0) {
        
        // Create padding between sides of view and each button
        //  -- I recommend 10 for aesthetically pleasing results at a 14 fontSize
        
        // Iterate over every string in the array to create the Bubble Button
        for (int i = 0; i < strings.count; i++) {
            
        
            // Find the size of the button, turn it into a rect
            NSString *string = [strings objectAtIndex:i];
            CGSize stringSize = [string sizeWithFont:[UIFont systemFontOfSize:fsize] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            CGRect buttonRect = CGRectMake(buttonPadding, buttonPadding, stringSize.width + fsize, stringSize.height + fsize/2);
            
            
            // if new button will fit on screen, in row:
            //   - place it
            // else:
            //   - put on next row at beginning
            if (i > 0) {
                UIButton *previousButton = self.buttons[i-1];
                CGFloat rightEdge = previousButton.frame.origin.x + previousButton.frame.size.width + 2 * buttonPadding + stringSize.width;
                CGFloat bottomEdge = previousButton.frame.origin.y + previousButton.frame.size.height + 2 * buttonPadding + stringSize.height;
                
                
                if (rightEdge > self.frame.size.width) {
                    // new button would go over the right edge, put on new row
                    buttonRect = CGRectMake(buttonPadding, previousButton.frame.origin.y + previousButton.frame.size.height + buttonPadding, stringSize.width + fsize, stringSize.height + fsize/2);
                } else if (bottomEdge > self.frame.size.height) {
                    // new button would go over the bottom edge, don't place that button yo
                    return;
                }
                else {
                    buttonRect = CGRectMake(previousButton.frame.origin.x + buttonPadding + previousButton.frame.size.width, previousButton.frame.origin.y, stringSize.width + fsize, stringSize.height + fsize/2);
                }
            }
            
            
            // Create button and make magic with the UI
            // -- Set the alpha to 0, cause we're gonna' animate them at the end
            UIButton *bButton = [[UIButton alloc] initWithFrame:buttonRect];
            [bButton setShowsTouchWhenHighlighted:NO];
            [bButton setTitle:string forState:UIControlStateNormal];
            [bButton.titleLabel setFont:[UIFont systemFontOfSize:fsize]];
            [bButton setTitleColor:textColor forState:UIControlStateNormal];
            bButton.backgroundColor = bgColor;
            bButton.layer.cornerRadius = (3*fsize/4);
            bButton.alpha = 1;
//            bButton.alpha = 0;
            
            // Give it some data and a target
            bButton.tag = i;
            [bButton addTarget:self action:@selector(clickedBubbleButton:) forControlEvents:UIControlEventTouchUpInside];
            
            // And finally add a shadow
            bButton.layer.shadowColor = [[UIColor blackColor] CGColor];
            bButton.layer.shadowOffset = CGSizeMake(0.0f, 2.5f);
            bButton.layer.shadowRadius = 5.0f;
            bButton.layer.shadowOpacity = 0.35f;
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bButton.bounds cornerRadius:(3*fsize/4)];
            bButton.layer.shadowPath = [path CGPath];
            
            // Add to the view, and to the array
            [self addSubview:bButton];
            [self.buttons addObject:bButton];
        }
        
        // Sequentially animate the buttons appearing in view
        // -- This is the interval between each button animating, not overall span
        // -- I recommend 0.034 for an nice, smooth transition
        [self addBubbleButtonsWithInterval:0.034];
    }
    
    NSLog(@"%d", self.subviews.count);
}



-(void)addBubbleButtonsWithInterval:(float)ftime {
    // Make sure there are buttons to animate
    // Take the first button in the array, animate alpha to 1
    // Remove button from array
    // Recur. Lather, rinse, repeat until all are buttons are on screen
    
    if (self.buttons.count > 0) {
        UIButton *button = [self.buttons objectAtIndex:0];
        [UIView animateWithDuration:ftime animations:^{
            button.alpha = 1;
        } completion:^(BOOL fin){
            [self.buttons removeObjectAtIndex:0];
            [self addBubbleButtonsWithInterval:ftime];
        }];
    }
}



-(void)removeBubbleButtonsWithInterval:(float)ftime {
    // Make sure there are buttons on screen to animate
    // Take the last button on screen, animate alpha to 0
    // Remove button from superview
    // Recur. Lather, rinse, repeat until all buttons are off screen
    
    if (self.subviews.count > 0){
        UIButton *button = [self.subviews objectAtIndex:self.subviews.count - 1];
        [UIView animateWithDuration:ftime animations:^{
            button.alpha = 0;
        } completion:^(BOOL fin){
            if (self.subviews.count > 0) {
                [[self.subviews objectAtIndex:self.subviews.count - 1] removeFromSuperview];
                [self removeBubbleButtonsWithInterval:ftime];
            }
        }];
    }
}



-(void)clickedBubbleButton:(UIButton *)bubble {
    [delegate didClickBubbleButton:bubble];
}


@end
