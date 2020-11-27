//
//  mipDriver.m
//  mip
//
//  Created by Jean THOMAS on 26/11/2020.
//  Copyright © 2020 Jean THOMAS. All rights reserved.
//

#import "mipDriver.h"

const CFIndex kMIPReportId = 1;
const SInt32 kMIPVendorId = 0x045e;
const SInt32 kMIPProductId = 0x082a;

static void mipMatchingCallback(void *context,
                                IOReturn result,
                                void *sender,
                                IOHIDDeviceRef deviceRef) {
    mipDriver *const driver = (__bridge mipDriver *const)context;
    [driver handleMatchingDevice:deviceRef sender:sender result:result];
}

static void mipRemovalCallback(void *context,
                               IOReturn result,
                               void *sender,
                               IOHIDDeviceRef deviceRef) {
    mipDriver *const driver = (__bridge mipDriver *const)context;
    [driver handleDeviceRemoval:deviceRef sender:sender result:result];
}

@implementation mipDriver

- (id)init {
    if (self = [super init]) {
        mouseDeviceRef = NULL;
        managerRef = IOHIDManagerCreate(NULL, 0);
        
        NSDictionary *matchingDictionnary = @
        {
            @kIOHIDVendorIDKey: [NSNumber numberWithInt:kMIPVendorId],
            @kIOHIDProductIDKey: [NSNumber numberWithInt:kMIPProductId]
        };
        IOHIDManagerSetDeviceMatching(managerRef, (CFDictionaryRef)matchingDictionnary);
        
        IOHIDManagerRegisterDeviceMatchingCallback(managerRef,
                                                   &mipMatchingCallback,
                                                   (void*)self);
        IOHIDManagerRegisterDeviceRemovalCallback(managerRef,
                                                  &mipRemovalCallback,
                                                  (void*)self);
        
        IOHIDManagerScheduleWithRunLoop(managerRef, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
        IOReturn err = IOHIDManagerOpen(managerRef, kIOHIDOptionsTypeNone);
        NSAssert(err == kIOReturnSuccess, @"mip driver initialization failed");
    }
    return self;
}

- (BOOL)setColor:(NSColor*)color {
    if (mouseDeviceRef) {
        uint8_t packet[73] = {
            0x24, 0xB2, 0x03
        };
        packet[3] = (unsigned char)([color redComponent]*255);
        packet[4] = (unsigned char)([color greenComponent]*255);
        packet[5] = (unsigned char)([color blueComponent]*255);
        IOHIDDeviceSetReport(mouseDeviceRef,
                             kIOHIDReportTypeFeature,
                             kMIPReportId,
                             (const uint8_t *)packet,
                             sizeof(packet));
    }
    return false;
}

- (NSColor*)color {
    return [NSColor redColor];
}

- (void)handleMatchingDevice:(IOHIDDeviceRef)device sender:(void *)sender result:(IOReturn)result {
    mouseDeviceRef = device;
    [self.delegate deviceConnected];
}

- (void)handleDeviceRemoval:(IOHIDDeviceRef)device sender:(void *)sender result:(IOReturn)result {
    mouseDeviceRef = NULL;
    [self.delegate deviceDisconnected];
}

@end
