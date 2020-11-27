//
//  mipColorPickerColorControl.h
//  mip
//
//  Created by Jean THOMAS on 26/11/2020.
//  Copyright © 2020 Jean THOMAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol mipColorPickerColorControlDelegate <NSObject>
- (void)updateColor:(NSColor*)color;
- (void)saveColor:(NSColor*)color;
@end

IB_DESIGNABLE
@interface mipColorPickerColorControl : NSControl {
    @private
    NSPoint colorPoint;
}

- (NSColor*)color;
@end
