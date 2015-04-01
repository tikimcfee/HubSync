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
    
    _taskName.stringValue = sourceTask.taskTitle;
    
    [_priorityColorView setWantsLayer:YES];
    
    CGColorRef priority;
    switch (sourceTask.taskPriority) {
        case CSTaskPriorityHigh:
            priority = [NSColor redColor].CGColor;
            break;
        case CSTaskPriorityMedium:
            priority = [NSColor yellowColor].CGColor;
            break;
        case CSTaskPriorityLow:
            priority = [NSColor greenColor].CGColor;
            break;
        default:
            priority = [NSColor blueColor].CGColor;
            break;
    }
    
    _priorityColorView.layer.backgroundColor = priority;
}

@end
