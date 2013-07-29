//
//  GIKViewController.m
//  HyperlinkingTextView
//
//  Created by Gordon Hughes on 7/26/13.
//  Copyright (c) 2013 Gordon Hughes. All rights reserved.
//

#import "GIKViewController.h"
#import "GIKTextView.h"

@interface GIKViewController () <GIKHitTestDelegate>

@property (weak, nonatomic) IBOutlet GIKTextView *textView;

@property (assign, nonatomic) CGRect linkRect;

@property (strong, nonatomic) NSMutableSet *linkRects;
@end

@implementation GIKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _linkRects = [[NSMutableSet alloc] init];
    self.textView.hitTestDelegate = self;
    self.textView.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // We can only calculate UITextPosition and UITextRange when the text view is on-screen. We won't get the correct rects if we call this in viewWillAppear:
    [self highlightText];
}


- (void)highlightText
{
    // Note that "sed do" wraps over two lines, but only "sed" is highlighted - that's because firstRectForRange can't span multiple lines.
    NSArray *links = @[@"ipsum dolor sit", @"sed do", @"magna aliqua"];

    for (NSString *link in links)
    {
        [self searchForSubstring:link inTextView:self.textView highlight:YES tag:([links indexOfObject:link] + 1)];
    }
}

- (void)searchForSubstring:(NSString *)substring inTextView:(UITextView *)textView highlight:(BOOL)highlight tag:(NSInteger)tag
{
    CGRect linkRect = [self rectForSubstring:substring inTextView:textView];
    if (highlight)
    {
        [self highlightRect:linkRect inView:textView tag:tag];
    }
    
    [self.linkRects addObject:[NSValue valueWithCGRect:linkRect]];
}

- (CGRect)rectForSubstring:(NSString *)substring inTextView:(UITextView *)textView
{
    NSRange range = [textView.text rangeOfString:substring];
    
    UITextPosition *start = [textView positionFromPosition:textView.beginningOfDocument offset:range.location];
    UITextPosition *end = [textView positionFromPosition:start offset:range.length];

    UITextRange *linkRange = [textView textRangeFromPosition:start toPosition:end];
    CGRect linkRect = [textView firstRectForRange:linkRange];
        
    return linkRect;
}

- (void)highlightRect:(CGRect)rect inView:(id)view tag:(NSInteger)tag
{
    UIView *highlight = [view viewWithTag:tag];
    [highlight removeFromSuperview];
    highlight = [[UIView alloc] initWithFrame:rect];
    [highlight setTag:tag];
    [highlight setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.3]];
    [view addSubview:highlight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - GIKHitTestDelegate

- (void)textView:(GIKTextView *)textView didReceiveTouchAtPoint:(CGPoint)point
{
    for (NSValue *rectValue in self.linkRects)
    {
        CGRect rect = [rectValue CGRectValue];
        
        if (CGRectContainsPoint(rect, point))
        {
            NSLog(@"link tapped!");
        }
    }
}

@end
