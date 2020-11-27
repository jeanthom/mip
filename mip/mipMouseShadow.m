//
//  mipMouseShadow.m
//  mip
//
//  Created by Jean THOMAS on 26/11/2020.
//  Copyright © 2020 Jean THOMAS. All rights reserved.
//

#import "mipMouseShadow.h"

@implementation mipMouseShadow

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        shadowColor = [NSColor redColor];
    }
    return self;
}

- (void)setShadowColor: (NSColor*)color {
    shadowColor = color;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSGraphicsContext* gc = [NSGraphicsContext currentContext];
    [gc saveGraphicsState];
    
    // Set LED shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowBlurRadius:25.0];
    [shadow setShadowColor:shadowColor];
    [shadow set];
    
    // Draw transparent banana shape
    [[NSColor blackColor] setFill];
    CGFloat viewWidth = [self bounds].size.width;
    NSBezierPath *bananaPath = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(0.1*viewWidth, 40, 0.8*viewWidth, 150)];
    [bananaPath fill];
    
    [gc restoreGraphicsState];
}

@end
