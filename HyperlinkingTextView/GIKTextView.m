//
//  GIKTextView.m
//  HyperlinkingTextView
//
//  Created by Gordon Hughes on 7/29/13.
//  Copyright (c) 2013 Gordon Hughes. All rights reserved.
//

#import "GIKTextView.h"

@implementation GIKTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    [self.hitTestDelegate textView:self didReceiveTouchAtPoint:touchPoint];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
