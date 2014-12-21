//
//  BBView.m
//  BubbleButtonView
//
//  Created by Benjamin Gordon on 1/8/13.
//  Copyright (c) 2013 Benjamin Gordon. All rights reserved.
//

#import "BBView.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const buttonPadding = 10;
/*! Two rows of smartly sized buttons to display an array of button names.*/
@interface BBView ()
@property (nonatomic, strong) NSArray * buttons;
@end
@implementation BBView
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


-(void)fillBubbleViewWithButtons:(NSArray *)strings bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor fontSize:(float)fontSize {
    
    NSMutableArray * buttons = [NSMutableArray new];
    __block CGRect frame = CGRectZero;
    [strings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString * string = obj;
        CGSize stringSize = [string sizeWithFont:[UIFont systemFontOfSize:fontSize] forWidth:CGFLOAT_MAX lineBreakMode:NSLineBreakByWordWrapping];
        CGPoint bottomRight = CGPointMake(frame.origin.x + frame.size.width + 2 * buttonPadding + stringSize.width,
                                          frame.origin.y + frame.size.height + 2 * buttonPadding + stringSize.height);
        
        if (bottomRight.x > self.bounds.size.width || CGRectEqualToRect(frame, CGRectZero)) {
            
            if (bottomRight.y > self.bounds.size.height) {
                stop = YES;
                return;
            }
            
            frame = CGRectMake(buttonPadding,
                               frame.origin.y + frame.size.height + buttonPadding,
                               stringSize.width + buttonPadding,
                               stringSize.height + buttonPadding);
            
        } else {
            
            frame = CGRectMake(frame.origin.x + frame.size.width + buttonPadding,
                               frame.origin.y,
                               stringSize.width + buttonPadding,
                               stringSize.height + buttonPadding);
            
        }
        
        UIButton * button = [self buttonWithFrame:frame title:string fontSize:fontSize textColor:textColor backgroundColor:bgColor tag:idx];
        [self addSubview:button];
        [buttons addObject:button];
        
    }];
    
    self.buttons = buttons;
}

- (UIButton *) buttonWithFrame:(CGRect)buttonRect title:(NSString *)string fontSize:(CGFloat)fsize textColor:(UIColor *)textColor backgroundColor:(UIColor *) bgColor tag:(NSInteger)i
{
    UIButton *button = [[UIButton alloc] initWithFrame:buttonRect];
    [button setShowsTouchWhenHighlighted:NO];
    [button setTitle:string forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:fsize]];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.backgroundColor = bgColor;
    button.layer.cornerRadius = (3*fsize/4);
    button.alpha = 1;
    button.tag = i;
    [button addTarget:self action:@selector(bubbleButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.shadowColor = [[UIColor blackColor] CGColor];
    button.layer.shadowOffset = CGSizeMake(0.0f, 2.5f);
    button.layer.shadowRadius = 5.0f;
    button.layer.shadowOpacity = 0.35f;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:button.bounds cornerRadius:(3*fsize/4)];
    button.layer.shadowPath = [path CGPath];
    return button;
}

-(void)bubbleButtonDidPress:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(bubbleButtonDidPress:)]) {
        [self.delegate bubbleButtonDidPress:button];
    }
}


@end
