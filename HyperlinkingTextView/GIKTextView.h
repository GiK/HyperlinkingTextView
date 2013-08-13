//
//  GIKTextView.h
//  HyperlinkingTextView
//
//  Created by Gordon Hughes on 7/29/13.
//  Copyright (c) 2013 Gordon Hughes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GIKHitTestDelegate;


@interface GIKTextView : UITextView

@property (weak, nonatomic) id<GIKHitTestDelegate> hitTestDelegate;

@end


@protocol GIKHitTestDelegate <NSObject>
@optional

- (void)textView:(GIKTextView *)textView didReceiveTapGestureAtPoint:(CGPoint)point;
- (void)textView:(GIKTextView *)textView didReceiveLongPressGestureAtPoint:(CGPoint)point;

@end