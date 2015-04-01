//
//  HSTaskDetailViewController.h
//  HubSync
//
//  Created by CommSync on 3/30/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Cocoa/Cocoa.h>

@interface HSTaskDetailViewController : NSViewController <AVAudioPlayerDelegate>

@property (strong) IBOutlet NSTextField *taskNameLabel;
@property (strong) IBOutlet NSTextView *taskDescriptionTextView;

@property (strong) IBOutlet NSButton *taskAudioPlayButton;

@property (strong) IBOutlet NSView *taskPriorityBubble;


@end
