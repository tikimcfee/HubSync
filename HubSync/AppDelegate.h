//
//  AppDelegate.h
//  HubSync
//
//  Created by CommSync on 3/30/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CSSessionManager.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

# pragma mark - Application-wide sessions manager
@property (strong, nonatomic) CSSessionManager* globalSessionManager;
@property (strong, nonatomic) NSString* userDisplayName;

@end

