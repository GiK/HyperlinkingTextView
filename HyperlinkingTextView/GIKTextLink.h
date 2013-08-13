//
//  GIKTextLink.h
//  HyperlinkingTextView
//
//  Created by Gordon Hughes on 7/29/13.
//  Copyright (c) 2013 Gordon Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIKTextLink : NSObject

@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSURL *url;
@property (strong, nonatomic) NSValue *rectValue;
@property (assign, nonatomic) NSUInteger tag;

@end
