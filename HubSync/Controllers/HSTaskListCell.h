//
//  HSTaskListCell.h
//  HubSync
//
//  Created by CommSync on 3/30/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CSTaskRealmModel.h"

@interface HSTaskListCell : NSTableCellView

@property (strong) CSTaskRealmModel* sourceTask;
@property (strong) IBOutlet NSTextField *taskName;
@property (strong) IBOutlet NSView *priorityColorView;

- (void) configureWithSourceTask:(CSTaskRealmModel*)sourceTask;

@end
