//
//  HSTaskListCell.m
//  HubSync
//
//  Created by CommSync on 3/30/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import "HSTaskListCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation HSTaskListCell

- (void) configureWithSourceTask:(CSTaskRealmModel*)sourceTask {
    _sourceTask = sourceTask;
    
    _taskName.stringValue = @"Simple Task Name";
    
    [_priorityColorView setWantsLayer:YES];
    _priorityColorView.layer.backgroundColor = [NSColor redColor].CGColor;
}

@end
