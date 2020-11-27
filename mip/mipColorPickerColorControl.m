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
    CGFloat hue = (point.x-bounds.origin.x)/(bounds.size.width*1.15);
    CGFloat saturation;
    CGFloat brightness;
    if ((point.y-bounds.origin.y)/bounds.size.height > 0.5) {
        saturation = 1.0-((point.y-bounds.origin.y)/bounds.size.height - 0.5)*2.0;
        brightness = 1.0;
    } else {
        saturation = 1.0;
        brightness = (point.y-bounds.origin.y)/bounds.size.height*2.0;
    }
    
    return [NSColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0f];
}

- (void)setColor:(NSColor*)color {
    colorPoint = [mipColorPickerColorControl pointWithNSColor:color bounds:[self paletteBounds]];
    [self setNeedsDisplay:YES];
}

+ (NSPoint)boundPoint:(NSPoint)point WithinRect:(NSRect)rect {
    if (point.x < rect.origin.x) {
        point.x = rect.origin.x;
    }
    if (point.x >= rect.origin.x+rect.size.height) {
        point.x = rect.origin.x+rect.size.height;
    }
    if (point.y < rect.origin.y) {
        point.y = rect.origin.y;
    }
    if (point.y >= rect.origin.y+rect.size.width) {
        point.y = rect.origin.y+rect.size.width;
    }
    return point;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder: decoder]) {
        NSRect bounds = [self paletteBounds];
        colorPoint.x = bounds.origin.x + bounds.size.width/2;
        colorPoint.y = bounds.origin.y + bounds.size.height/2;
    }
    return self;
}

- (void)drawRect:(NSRect)viewRect {
    NSRect dirtyRect = [self paletteBounds];
    NSGraphicsContext* gc = [NSGraphicsContext currentContext];
    [gc saveGraphicsState];
    
    // Draw 2D color gradient
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    for (CGFloat i = 0.0f; i <= 1.0f; i += 0.1f) {
        [colors addObject:[NSColor colorWithHue:i saturation:1.0f brightness:1.0f alpha:1.0f]];
    }
    NSGradient *colorGradient = [[NSGradient alloc] initWithColors:colors];
    NSGradient *blackGradient = [[NSGradient alloc] initWithColors:@[
        [NSColor blackColor],
        [NSColor colorWithHue:0.0f saturation:0.0f brightness:0.0f alpha:0.0f]
    ]];
    NSGradient *whiteGradient = [[NSGradient alloc] initWithColors:@[
        [NSColor colorWithHue:0.0f saturation:0.0f brightness:1.0f alpha:0.0f],
        [NSColor colorWithHue:0.0f saturation:0.0f brightness:1.0f alpha:1.0f]
    ]];
    [colorGradient drawInRect:dirtyRect angle:0.0f];
    NSRect grayscaleGradientRect = dirtyRect;
    grayscaleGradientRect.size.height /= 2;
    [blackGradient drawInRect:grayscaleGradientRect angle:90.0f];
    grayscaleGradientRect.origin.y += grayscaleGradientRect.size.height;
    [whiteGradient drawInRect:grayscaleGradientRect angle:90.0f];
    
    [[NSColor lightGrayColor] setStroke];
    NSBezierPath *borderPath = [NSBezierPath bezierPathWithRect:dirtyRect];
    [borderPath setLineWidth:0.5];
    [borderPath stroke];
    
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
    curPoint = [mipColorPickerColorControl boundPoint:curPoint WithinRect:[self paletteBounds]];
    colorPoint = curPoint;
    [self setNeedsDisplay:YES];
    [NSApp sendAction:self.action to:self.target from:self];
}

- (NSColor*)color {
    return [mipColorPickerColorControl colorWithPoint:colorPoint bounds: [self paletteBounds]];
}

- (NSRect)paletteBounds {
    return NSInsetRect([self bounds], 10, 10);
}

@end
