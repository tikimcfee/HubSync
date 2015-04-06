//
//  AppDelegate.m
//  HubSync
//
//  Created by CommSync on 3/30/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    _userDisplayName = NSUserName();
    _globalSessionManager = [[CSSessionManager alloc] initWithID:_userDisplayName];
}

- (IBAction)clearDatabase:(id)sender {
    [_globalSessionManager nukeRealm];
}

- (IBAction)clearSessions:(id)sender {
    [_globalSessionManager nukeSession];
}

- (IBAction)clearPeerHistory:(id)sender {
    [_globalSessionManager nukeHistory];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
