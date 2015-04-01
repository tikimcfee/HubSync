//
//  HSTaskDetailViewController.m
//  HubSync
//
//  Created by CommSync on 3/30/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import "HSTaskDetailViewController.h"
#import "CSTaskRealmModel.h"
#import "HSConstantsHeader.h"

@interface HSTaskDetailViewController ()

@property (weak, nonatomic) CSTaskRealmModel* sourceTask;
@property (strong, nonatomic) AVAudioPlayer* audioPlayer;

@end

@implementation HSTaskDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newTaskDetailSelected:)
                                                 name:kHSSelectedTaskDetailRowNotification
                                               object:nil];
    
//    NSTextContainer* textContainer = [[NSTextContainer alloc] initWithContainerSize:_taskDescriptionTextView.bounds.size];
//    [textContainer setTextView:_taskDescriptionTextView];
    
    [_taskPriorityBubble setWantsLayer:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.audioPlayer = nil;
}

- (IBAction)playAudio:(id)sender {
    if (self.sourceTask.taskAudio == nil) {
        return;
    }
    
    NSData* audioData = self.sourceTask.taskAudio;
    NSError* error;
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
}

- (void)newTaskDetailSelected:(NSNotification*)notification {
    if([notification.object isKindOfClass:[CSTaskRealmModel class]]) {
        _sourceTask = notification.object;
        
        _taskNameLabel.stringValue = _sourceTask.taskTitle;
        [_taskDescriptionTextView setString:_sourceTask.taskDescription];
        
        CGColorRef priority;
        switch (_sourceTask.taskPriority) {
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
        _taskPriorityBubble.layer.cornerRadius = _taskPriorityBubble.bounds.size.width / 2;
        _taskPriorityBubble.layer.backgroundColor = priority;
        
        id someObject = [NSUnarchiver unarchiveObjectWithData:_sourceTask.taskAudio];
        if([someObject isKindOfClass:[[NSNull null] class]]) {
            NSLog(@"NULL AUDIO");
        }
        if (_sourceTask.taskAudio == nil) {
            _taskAudioPlayButton.enabled = NO;
        } else {
            _taskAudioPlayButton.enabled = YES;
        }
    }
}

@end
