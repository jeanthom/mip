//
//  mipDriver.m
//  mip
//
//  Created by Jean THOMAS on 26/11/2020.
//  Copyright © 2020 Jean THOMAS. All rights reserved.
//

#import "mipDriver.h"

const CFIndex kMIPReportId = 1;
const UInt16 kMIPVendorId = 0x045e;
const UInt16 kMIPProductId = 0x082a;
const UInt16 kMIPUsage = 0x0212;

static void mipMatchingCallback(void *context,
                                IOReturn result,
                                void *sender,
                                IOHIDDeviceRef deviceRef) {
    if (result == kIOReturnSuccess && deviceRef) {
        [(__bridge mipDriver *const)context handleMatchingDevice:deviceRef sender:sender result:result];
    }
}

static void mipRemovalCallback(void *context,
                               IOReturn result,
                               void *sender,
                               IOHIDDeviceRef deviceRef) {
    if (result == kIOReturnSuccess && deviceRef) {
        [(__bridge mipDriver *const)context handleDeviceRemoval:deviceRef sender:sender result:result];
    }
}

@implementation mipDriver

- (id)init {
    if (self = [super init]) {
        deviceRefs = [[NSMutableArray alloc] init];
        managerRef = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
        
        IOHIDManagerRegisterDeviceMatchingCallback(managerRef,
                                                   &mipMatchingCallback,
                                                   (void*)self);
        IOHIDManagerRegisterDeviceRemovalCallback(managerRef,
                                                  &mipRemovalCallback,
                                                  (void*)self);
        
        NSDictionary *matchingDictionnary = @
        {
            @kIOHIDVendorIDKey: [NSNumber numberWithInt:kMIPVendorId],
            @kIOHIDProductIDKey: [NSNumber numberWithInt:kMIPProductId],
            @kIOHIDDeviceUsageKey: [NSNumber numberWithInt:kMIPUsage]
        };
        IOHIDManagerSetDeviceMatching(managerRef, (__bridge CFDictionaryRef)matchingDictionnary);
        
        IOHIDManagerScheduleWithRunLoop(managerRef, CFRunLoopGetMain(), kCFRunLoopDefaultMode);
        IOReturn err = IOHIDManagerOpen(managerRef, kIOHIDOptionsTypeNone);
        NSAssert(err == kIOReturnSuccess, @"mip driver initialization failed");
    }
    return self;
}

- (BOOL)setColor:(NSColor*)color {
    for (id deviceRef in deviceRefs) {
        uint8_t packet[73] = {
            0x24, 0xB2, 0x03
        };
        packet[3] = (unsigned char)([color redComponent]*255);
        packet[4] = (unsigned char)([color greenComponent]*255);
        packet[5] = (unsigned char)([color blueComponent]*255);
        IOHIDDeviceSetReport((IOHIDDeviceRef)deviceRef,
                             kIOHIDReportTypeFeature,
                             kMIPReportId,
                             (const uint8_t *)packet,
                             sizeof(packet));
    }
    return true;
}

- (void)handleMatchingDevice:(IOHIDDeviceRef)device sender:(void *)sender result:(IOReturn)result {
    [deviceRefs addObject:(__bridge id _Nonnull)device];
    [self.delegate deviceConnected];
}

- (void)handleDeviceRemoval:(IOHIDDeviceRef)device sender:(void *)sender result:(IOReturn)result {
    [deviceRefs removeObject:(__bridge id _Nonnull)device];
    if ([deviceRefs count] == 0) {
        [self.delegate deviceDisconnected];
    }
}

@end
