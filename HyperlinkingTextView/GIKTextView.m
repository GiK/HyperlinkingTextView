//
//  GIKTextView.m
//  HyperlinkingTextView
//
//  Created by Gordon Hughes on 7/29/13.
//  Copyright (c) 2013 Gordon Hughes. All rights reserved.
//

#import "GIKTextView.h"

@interface GIKTextView () <UIGestureRecognizerDelegate>

@end


@implementation GIKTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupGestures];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setupGestures];
}

- (void)setupGestures
{
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    [doubleTap setNumberOfTapsRequired:2];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    
    [self addGestureRecognizer:singleTap];
    [self addGestureRecognizer:doubleTap];
    [self addGestureRecognizer:longPress];
}

- (void)handleTapGesture:(UIGestureRecognizer *)recognizer
{
    [self.hitTestDelegate textView:self didReceiveTapGestureAtPoint:[recognizer locationInView:self] numberOfTaps:1];
}

- (void)handleDoubleTapGesture:(UIGestureRecognizer *)recognizer
{
    [self.hitTestDelegate textView:self didReceiveTapGestureAtPoint:[recognizer locationInView:self] numberOfTaps:2];
}


- (void)handleLongPressGesture:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self.hitTestDelegate textView:self didReceiveLongPressGestureAtPoint:[recognizer locationInView:self]];
    }
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [self.hitTestDelegate gestureWillBeginInTextView:self];
    return YES;
}

@end
