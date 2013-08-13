//
//  GIKViewController.m
//  HyperlinkingTextView
//
//  Created by Gordon Hughes on 7/26/13.
//  Copyright (c) 2013 Gordon Hughes. All rights reserved.
//

#import "GIKViewController.h"
#import "GIKTextView.h"
#import "GIKTextLink.h"

@interface GIKViewController () <GIKHitTestDelegate>

@property (weak, nonatomic) IBOutlet GIKTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) NSMutableArray *textLinks;
@property (strong, nonatomic) UITextPosition *startPosition;

@property (assign, nonatomic) NSInteger tappedLinkTag;
@property (strong, nonatomic) GIKTextLink *tappedTextLink;

@property (strong, nonatomic) UIMenuItem *cpyURLMenuItem;
@property (strong, nonatomic) UIMenuItem *openURLMenuItem;

@end

@implementation GIKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textView.hitTestDelegate = self;
    self.textView.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit er elit lamet. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    
    self.textLinks = [[NSMutableArray alloc] init];
    
    self.cpyURLMenuItem = [[UIMenuItem alloc] initWithTitle:@"Copy Link" action:@selector(copyLink:)];
    self.openURLMenuItem = [[UIMenuItem alloc] initWithTitle:@"Open in Safari" action:@selector(openURL:)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.startPosition = self.textView.beginningOfDocument;
    
    // We can only calculate UITextPosition and UITextRange when the text view is on-screen. We won't get the correct rects if we call this in viewWillAppear:
    [self highlightLinks];
}

- (BOOL)canBecomeFirstResponder
{
    return YES; // required so that UIMenuController can displayed.
}

- (void)highlightLinks
{
    // When running, note that "sed do eiusmod" spans multiple lines and is only partially highlighted. This is because of a limitation in UITextInput's firstRectForRange:
    NSArray *links = @[@"ipsum dolor sit", @"you won't find me", @"sed do eiusmod", @"magna aliqua", @"ipsum dolor sit", @"conscient to factor tum"];

    NSUInteger index = 1;
    for (NSString *link in links)
    {
        CGRect rect = [self rectForSubstring:link startingFromPosition:self.startPosition inTextView:self.textView];
        
        if (!CGRectIsNull(rect))
        {
            GIKTextLink *textLink = [[GIKTextLink alloc] init];
            textLink.rectValue = [NSValue valueWithCGRect:rect];
            textLink.text = link;
            textLink.tag = index;
            textLink.url = [NSURL URLWithString:@"http://www.apple.com"];
            
            [self.textLinks addObject:textLink];
            [self highlightRect:rect inView:self.textView tag:index];
            
            index += 1;
        }
    }
}

- (CGRect)rectForSubstring:(NSString *)substring startingFromPosition:(UITextPosition *)startPosition inTextView:(UITextView *)textView
{
    // Each time a substring is found within the text, the ending position of the current search becomes the starting position for the next search. This allows us to find the same string in multiple places.
    
    NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:startPosition];
    NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:textView.endOfDocument];
    NSRange searchRange = NSMakeRange(startOffset, endOffset - startOffset);
    
    NSRange range = [textView.text rangeOfString:substring options:0 range:searchRange];
    
    if (range.location == NSNotFound)
    {
        return CGRectNull;
    }
    
    UITextPosition *start = [textView positionFromPosition:textView.beginningOfDocument offset:range.location];
    UITextPosition *end = [textView positionFromPosition:start offset:range.length];

    UITextRange *linkRange = [textView textRangeFromPosition:start toPosition:end];
    
    // firstRectForRange: can't span multiple lines, so certain links won't be fully highlighted/tappable.
    CGRect linkRect = [textView firstRectForRange:linkRange];

    self.startPosition = end;
    
    return linkRect;
}

- (void)highlightRect:(CGRect)rect inView:(id)view tag:(NSInteger)tag
{
    UIView *highlight = [view viewWithTag:tag];
    [highlight removeFromSuperview];
    highlight = [[UIView alloc] initWithFrame:rect];
    [highlight setTag:tag];
    [highlight setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.8 alpha:0.3]];
    [view addSubview:highlight];
}

- (void)animateViewWithTag:(NSUInteger)tag
{
    UIView *highlight = [self.textView viewWithTag:tag];
    UIColor *currentColor = highlight.backgroundColor;
    UIColor *color = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:0.8];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [highlight setBackgroundColor:color];
    } completion:^(BOOL finished) {
        if (finished)
        {
           [UIView animateWithDuration:0.2 animations:^{
               [highlight setBackgroundColor:currentColor];
           }];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)copyLink:(id)sender
{
    self.label.text = [NSString stringWithFormat:@"Copying URL: %@", [self.tappedTextLink.url absoluteString]];
}

- (void)openURL:(id)sender
{
    [[UIApplication sharedApplication] openURL:self.tappedTextLink.url];
}

- (BOOL)gestureWasLocatedWithinTextLinkAtPoint:(CGPoint)point
{
    for (GIKTextLink *textLink in self.textLinks)
    {
        CGRect rect = [textLink.rectValue CGRectValue];
        if (CGRectContainsPoint(rect, point))
        {
            self.tappedTextLink = textLink;
            return YES;
        }
    }
    
    self.label.text = @"Tap a link";
    self.tappedTextLink = nil;
    return NO;
}


#pragma mark - GIKHitTestDelegate

- (void)gestureWillBeginInTextView:(GIKTextView *)textView
{
    [[UIMenuController sharedMenuController] setMenuItems:nil];
}

- (void)textView:(GIKTextView *)textView didReceiveTapGestureAtPoint:(CGPoint)point numberOfTaps:(NSUInteger)taps
{
    if ([self gestureWasLocatedWithinTextLinkAtPoint:point])
    {
        [self animateViewWithTag:self.tappedTextLink.tag];
        self.label.text = [NSString stringWithFormat:@"%@ \"%@\"", taps > 1 ? @"Double tapped" : @"Tapped", self.tappedTextLink.text];
    }
}

- (void)textView:(GIKTextView *)textView didReceiveLongPressGestureAtPoint:(CGPoint)point
{
    if ([self gestureWasLocatedWithinTextLinkAtPoint:point])
    {
        [self animateViewWithTag:self.tappedTextLink.tag];
        self.label.text = [NSString stringWithFormat:@"Long press \"%@\"", self.tappedTextLink.text];

        [[UIMenuController sharedMenuController] setMenuItems:@[self.cpyURLMenuItem, self.openURLMenuItem]];
        [[UIMenuController sharedMenuController] setTargetRect:[self.tappedTextLink.rectValue CGRectValue] inView:self.textView];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    }
}

@end
