//
//  HSTaskDetailViewController.h
//  HubSync
//
//  Created by CommSync on 3/30/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Cocoa/Cocoa.h>
#import "CSTaskRealmModel.h"
#import "CSTaskTransientObjectStore.h"

@interface HSTaskDetailViewController : NSViewController <AVAudioPlayerDelegate, NSTableViewDataSource, NSTableViewDelegate, NSTextViewDelegate>

@property (strong) IBOutlet NSTextField *taskNameLabel;
@property (strong) IBOutlet NSTextView *taskDescriptionTextView;
@property (strong) IBOutlet NSButton *taskAudioPlayButton;
@property (strong) IBOutlet NSView *taskPriorityBubble;

@property (strong) IBOutlet NSTableView *taskImageTableView;
@property (strong) IBOutlet NSTableView *taskRevisionsTableView;


@property (strong) CSTaskTransientObjectStore* transientTask;

@end
