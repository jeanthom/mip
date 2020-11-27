//
//  AppDelegate.m
//  mip
//
//  Created by Jean THOMAS on 26/11/2020.
//  Copyright © 2020 Jean THOMAS. All rights reserved.
//

#import "AppDelegate.h"
#import "mipColorPicker.h"
#import "mipColorPickerColorControl.h"
#import "mipConnectedBadge.h"

@interface AppDelegate ()
@property (weak) IBOutlet mipMouseShadow *mouseShadow;
@property (weak) IBOutlet mipConnectedBadge *connectedBadge;
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    driver = [[mipDriver alloc] init];
    [driver setDelegate:self];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}

- (IBAction)clickChangeLEDColor:(NSButton*)sender {
    // Create mipColorPicker popover
    mipColorPicker *viewController = [[mipColorPicker alloc] init];
    NSPopover *entryPopover = [[NSPopover alloc] init];
    [entryPopover setContentSize:NSMakeSize(200.0, 200.0)];
    [entryPopover setBehavior:NSPopoverBehaviorTransient];
    [entryPopover setAnimates:YES];
    [entryPopover setContentViewController:viewController];
    NSRect entryRect = [sender convertRect:sender.bounds toView:[[NSApp mainWindow] contentView]];
    [entryPopover showRelativeToRect:entryRect ofView:[[NSApp mainWindow] contentView] preferredEdge:NSMinYEdge];
}

- (IBAction)changeColor:(mipColorPickerColorControl*)colorControl {
    color = [colorControl color];
    [self.mouseShadow setShadowColor:color];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateDriver) object:nil];
    [self performSelector:@selector(updateDriver) withObject:nil afterDelay:0.01];
}

- (void)updateDriver {
    [driver setColor:color];
}

- (void)deviceConnected {
    [self.connectedBadge setEnabled:true];
}

- (void)deviceDisconnected {
    [self.connectedBadge setEnabled:false];
}

@end
