//
//  mipColorPickerColorControl.m
//  mip
//
//  Created by Jean THOMAS on 26/11/2020.
//  Copyright © 2020 Jean THOMAS. All rights reserved.
//

#import "mipColorPickerColorControl.h"

@implementation mipColorPickerColorControl

+ (NSPoint)pointWithNSColor:(NSColor*)color bounds:(NSRect)bounds {
    return NSMakePoint(0, 0);
}

+ (NSColor*)colorWithPoint:(NSPoint)point bounds:(NSRect)bounds {
    CGFloat hue = (point.x-bounds.origin.x)/bounds.size.width;
    CGFloat saturation = 1.0f;
    CGFloat brightness = (point.y-bounds.origin.y)/bounds.size.height;
    
    return [NSColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0f];
}

- (void)setColor:(NSColor*)color {
    colorPoint = [mipColorPickerColorControl pointWithNSColor:color bounds:[self bounds]];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder: decoder]) {
        colorPoint = NSMakePoint(0, 0);
    }
    return self;
}

- (void)drawRect:(NSRect)viewRect {
    NSRect dirtyRect = NSInsetRect(viewRect, 10, 10);
    NSGraphicsContext* gc = [NSGraphicsContext currentContext];
    [gc saveGraphicsState];
    
    // Draw 2D color gradient
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    for (CGFloat i = 0.0f; i <= 1.0f; i += 0.1f) {
        [colors addObject:[NSColor colorWithHue:i saturation:1.0f brightness:1.0f alpha:1.0f]];
    }
    NSMutableArray *saturation = [[NSMutableArray alloc] init];
    [saturation addObject:[NSColor blackColor]];
    [saturation addObject:[NSColor colorWithHue:0.0f saturation:0.0f brightness:1.0f alpha:0.0f]];
    [saturation addObject:[NSColor whiteColor]];
    NSGradient *colorGradient = [[NSGradient alloc] initWithColors:colors];
    NSGradient *grayscaleGradient = [[NSGradient alloc] initWithColors:saturation];
    [colorGradient drawInRect:dirtyRect angle:0.0f];
    [grayscaleGradient drawInRect:dirtyRect angle:90.0f];
    
    // Enable shadow for the selection circle
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowBlurRadius:2.5f];
    [shadow setShadowColor:[NSColor colorWithCalibratedWhite:0.0 alpha:0.5]];
    [shadow set];
    
    // Draw selected color circle
    const CGFloat kCircleRadius = 9.0f;
    const CGFloat kCircleThickness = 2.5f;
    [[NSColor whiteColor] setStroke];
    NSRect rect = NSMakeRect(0, 0, 2*kCircleRadius, 2*kCircleRadius);
    rect.origin = colorPoint;
    rect = NSOffsetRect(rect, -kCircleRadius, -kCircleRadius);
    NSBezierPath* circlePath = [NSBezierPath bezierPath];
    [circlePath appendBezierPathWithOvalInRect: rect];
    [circlePath setLineWidth:kCircleThickness];
    [circlePath stroke];
    
    [gc restoreGraphicsState];
}

- (void)mouseDown:(NSEvent *)event {
    [self mouseDragged:event];
}

- (void)mouseDragged:(NSEvent *)event {
    NSPoint curPoint = [self convertPoint:[event locationInWindow] fromView:nil];
    NSRect bounds = [self bounds];
    if (NSPointInRect(curPoint, NSInsetRect(bounds, 10, 10))) {
        colorPoint = curPoint;
        [self setNeedsDisplay:YES];
        [NSApp sendAction:self.action to:self.target from:self];
    }
}

- (NSColor*)color {
    return [mipColorPickerColorControl colorWithPoint:colorPoint bounds: [self bounds]];
}
@end
