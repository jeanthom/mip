//
//  mipMouseShadow.h
//  mip
//
//  Created by Jean THOMAS on 26/11/2020.
//  Copyright © 2020 Jean THOMAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface mipMouseShadow : NSView {
    @private
    NSColor *shadowColor;
}

- (void)setShadowColor: (NSColor*)color;

@end
