//
//  HSTaskCreationViewController.h
//  HubSync
//
//  Created by Ivan Lugo on 4/6/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HSTaskCreationViewController : NSViewController

@property (weak) IBOutlet NSSegmentedControl *prioritySelectionControl;

@property (unsafe_unretained) IBOutlet NSTextView *taskDescriptionTextView;

@property (weak) IBOutlet NSTextField *taskTitleTextField;
@property (weak) IBOutlet NSButton *createButton;


@end
