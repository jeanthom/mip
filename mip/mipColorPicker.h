//
//  mipColorPicker.h
//  mip
//
//  Created by Jean THOMAS on 26/11/2020.
//  Copyright © 2020 Jean THOMAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol mipColorPickerDelegate <NSObject>
- (void)updateColor:(NSColor*)color;
- (void)saveColor:(NSColor*)color;
@end

@interface mipColorPicker : NSViewController

@property (nonatomic, strong) id delegate;
@end
