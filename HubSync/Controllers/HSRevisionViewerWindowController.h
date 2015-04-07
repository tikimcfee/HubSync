//
//  HSRevisionViewerWindowController.h
//  HubSync
//
//  Created by Ivan Lugo on 4/7/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HSRevisionViewerPanel.h"

@interface HSRevisionViewerWindowController : NSWindowController

@property (weak) IBOutlet HSRevisionViewerPanel *revisionViewerPanel;

@end
