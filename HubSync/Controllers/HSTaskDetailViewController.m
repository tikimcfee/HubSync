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

#pragma mark - Lifecycle
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
    
    [_taskPriorityBubble setWantsLayer:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Tableview Datasource && Delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return _transientTask.TRANSIENT_taskImages.count;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    
    NSImageView* newView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    [newView setImage:[_transientTask.TRANSIENT_taskImages objectAtIndex:row]];
                            
    return newView;
}

#pragma mark - Actions
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

#pragma mark - Notifications
- (void)newTaskDetailSelected:(NSNotification*)notification {
    if([notification.object isKindOfClass:[CSTaskRealmModel class]]) {
        _sourceTask = notification.object;
        _transientTask = [[CSTaskTransientObjectStore alloc] initWithRealmModel:_sourceTask];
        
        [_transientTask  getAllImagesForTaskWithCompletionBlock:^void(BOOL didFinish) {
            if(didFinish) {
                [self setImagesFromTask];
            }
        }];
        
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
        
        /* This is so bad I can't even word.
         */
        bool hasAudio = NO;
        @try {
            [NSKeyedUnarchiver unarchiveObjectWithData:_sourceTask.taskAudio];
        }
        @catch (NSException *exception) {
            NSLog(@"HAS AUDIO");
            hasAudio = YES;
        }
        
        if (hasAudio) {
            _taskAudioPlayButton.enabled = YES;
        } else {
            _taskAudioPlayButton.enabled = NO;
        }
        /* That was so bad I couldn't even word.
         * But seriously... we need a doc property that just says no, I don't have audio...
         */
    }
}

# pragma mark - Callbacks and UI State
- (void)setImagesFromTask {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_transientTask.TRANSIENT_taskImages.count > 0) {
            [self.taskImageTableView reloadData];
        }
    });
    
}

@end
