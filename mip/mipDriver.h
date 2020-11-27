//
//  mipDriver.h
//  mip
//
//  Created by Jean THOMAS on 26/11/2020.
//  Copyright © 2020 Jean THOMAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <IOKit/hid/IOHIDManager.h>
#include <IOKit/usb/USBSpec.h>
#include <IOKit/usb/IOUSBLib.h>
#include <IOKit/IOKitLib.h>
#include <IOKit/IOMessage.h>
#include <IOKit/IOCFPlugIn.h>

@protocol mipDriverDelegate
- (void)deviceConnected;
- (void)deviceDisconnected;
@end

@interface mipDriver : NSObject {
    IOHIDManagerRef managerRef;
    NSMutableArray *deviceRefs;
}

@property (weak) id <mipDriverDelegate> delegate;

- (id)init;
- (BOOL)setColor:(NSColor*)color;

- (void)handleMatchingDevice:(IOHIDDeviceRef)device sender:(void *)sender result:(IOReturn)result;
- (void)handleDeviceRemoval:(IOHIDDeviceRef)device sender:(void *)sender result:(IOReturn)result;

@end
