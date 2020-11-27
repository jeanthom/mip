//
//  mipConnectedBadge.m
//  mip
//
//  Created by Jean THOMAS on 27/11/2020.
//  Copyright © 2020 Jean THOMAS. All rights reserved.
//

#import "mipConnectedBadge.h"

@interface mipConnectedBadge () {
    BOOL enabled;
}

@end

@implementation mipConnectedBadge

+ (NSRect)centerSize:(NSSize)innerSize inRect:(NSRect)outerRect {
    outerRect.origin.x = outerRect.origin.x + (outerRect.size.width - innerSize.width)/2.0;
    outerRect.origin.y = outerRect.origin.y + (outerRect.size.height - innerSize.height)/2.0;
    outerRect.size = innerSize;
    return outerRect;
}

- (void)drawRect:(NSRect)dirtyRect {
    if (self->enabled) {
        NSGraphicsContext* gc = [NSGraphicsContext currentContext];
        [gc saveGraphicsState];
        
        // Draw badge rectangle
        [[NSColor lightGrayColor] setFill];
        NSBezierPath *rectanglePath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3.0 yRadius:3.0];
        [rectanglePath fill];
        
        // Draw "Connected" text
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentCenter;
        NSDictionary *textAttributes = @
        {
            NSFontAttributeName: [NSFont fontWithName:@"Helvetica" size:12],
            NSForegroundColorAttributeName: [NSColor whiteColor],
            NSParagraphStyleAttributeName: style
        };
        NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:@"Connected" attributes:textAttributes];
        NSSize attrSize = [currentText size];
        [currentText drawInRect:[mipConnectedBadge centerSize:attrSize inRect:dirtyRect]];
        
        [gc restoreGraphicsState];
    }
}

- (void)setEnabled:(BOOL)enabled {
    self->enabled = enabled;
    [self setNeedsDisplay:YES];
}

@end
