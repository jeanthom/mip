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

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    /*[self.window.contentView setWantsLayer:YES];
    self.window.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
    self.window.titlebarAppearsTransparent = true;
    [self.window invalidateShadow];*/
    driver = [[mipDriver alloc] init];
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

- (IBAction)clickSetLaunchAtStartup:(NSButton *)sender {
    NSLog(@"TODO");
}

- (IBAction)changeColor:(mipColorPickerColorControl*)colorControl {
    //NSLog(@"aaa");
    NSColor *color = [colorControl color];
    [_mouseShadow setShadowColor:color];
    [driver setColor:color];
}

@end
