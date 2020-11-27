//
//  AppDelegate.h
//  mip
//
//  Created by Jean THOMAS on 26/11/2020.
//  Copyright © 2020 Jean THOMAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "mipMouseShadow.h"
#import "mipDriver.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, mipDriverDelegate> {
    mipDriver *driver;
    NSColor *color;
}

@end

