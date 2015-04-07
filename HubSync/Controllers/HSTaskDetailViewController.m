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
#import "HSRevisionViewerPanel.h"
#import "HSRevisionViewerController.h"

@interface HSTaskDetailViewController ()

@property (strong, nonatomic) CSTaskRealmModel* sourceTask;
@property (strong, nonatomic) AVAudioPlayer* audioPlayer;

@property (strong, nonatomic) CSTaskRevisionRealmModel* currentRevisions;
@property (strong, nonatomic) NSMutableDictionary* unsavedChanges;

@property (strong, nonatomic) HSRevisionViewerController* revisionViewController;
@property (strong, nonatomic) HSRevisionViewerPanel* revisionPanel;
@property (strong, nonatomic) NSWindowController* revisionWindow;

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
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(beginCreatingNewTask:)
//                                                 name:kHSTaskCreationButtonClickedNotification
//                                               object:nil];
    
    [_taskPriorityBubble setWantsLayer:YES];
    _currentRevisions = [CSTaskRevisionRealmModel new];
    _unsavedChanges = [NSMutableDictionary new];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Textview delegate
- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString {
    [_unsavedChanges setObject:textView.string forKey:[NSNumber numberWithInt:CSTaskProperty_taskDescription]];
    return YES;
}

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRanges:(NSArray *)affectedRanges replacementStrings:(NSArray *)replacementStrings {
    [_unsavedChanges setObject:textView.string forKey:[NSNumber numberWithInt:CSTaskProperty_taskDescription]];
    return YES;
}

#pragma mark - Tableview Datasource && Delegate
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    if (_taskRevisionsTableView.selectedRow == -1) {
        return;
    }
    
    if(aNotification.object == _taskRevisionsTableView) {
        if(_revisionWindow == nil) {
            NSWindowController* window = [[NSStoryboard storyboardWithName:@"Main" bundle:nil]
                                                 instantiateControllerWithIdentifier:@"RevisionsWindow"];
            _revisionWindow = window;
            _revisionWindow.window.delegate = self;
            _revisionViewController = _revisionWindow.contentViewController;
            
            [window showWindow:self];
        }
        
        [_revisionViewController configureWithSourceTask:_sourceTask
                                          sourceRevision:[_sourceTask.revisions
                                                          objectAtIndex:_taskRevisionsTableView.selectedRow]];
    }
}

- (void)windowWillClose:(NSNotification *)notification {
    if(notification.object == _revisionWindow.window) {
        _revisionWindow = nil;
        _revisionViewController = nil;
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    if(aTableView == _taskImageTableView) {
        return _transientTask.TRANSIENT_taskImages.count;
    } else if (aTableView == _taskRevisionsTableView) {
        return _sourceTask.revisions.count;
    }
    
    return 0;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    if(tableView == _taskImageTableView) {
        return [self viewForImageTableView:row];
    }
    else if(tableView == _taskRevisionsTableView) {
        return [self viewForRevisionTableView:row];
    }
    
    return nil;
}

- (NSView*)viewForImageTableView:(NSInteger)row {
    NSImageView* newView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    [newView setImage:[_transientTask.TRANSIENT_taskImages objectAtIndex:row]];
    
    return newView;
}

- (NSTableCellView*)viewForRevisionTableView:(NSInteger)row {
    NSTableCellView* newCell = [_taskRevisionsTableView makeViewWithIdentifier:@"RevisionTableViewCell"
                                                                         owner:self];
    CSTaskRevisionRealmModel* rev = [_sourceTask.revisions objectAtIndex:row];
    newCell.textField.stringValue = rev.revisionID;
    
    return newCell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    if(tableView == _taskRevisionsTableView) {
        return 17;
    } else if (tableView == _taskImageTableView) {
        return self.taskImageTableView.frame.size.width;
    }

    return -1;
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
        
        [self setupViews];
    }
}

# pragma mark - Callbacks and UI State
- (void)setupViews {
    _transientTask = [[CSTaskTransientObjectStore alloc] initWithRealmModel:_sourceTask];
    
    [_transientTask  getAllImagesForTaskWithCompletionBlock:^void(BOOL didFinish) {
        if(didFinish) {
            [self reloadTableViews];
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
    
    
    /* This isn't SO bad...
     */
    bool hasAudio = NO;
    if(_sourceTask.taskAudio.length > 512) {
        hasAudio = YES;
    }
    
    if (hasAudio) {
        _taskAudioPlayButton.enabled = YES;
    } else {
        _taskAudioPlayButton.enabled = NO;
    }
}

- (IBAction)saveEdits:(id)sender {
    
    NSArray* allChanges = [_unsavedChanges allKeys];
    for(NSNumber* property in allChanges) {
        [_currentRevisions forTask:_sourceTask
                    reviseProperty:[property integerValue]
                                to:[_unsavedChanges objectForKey:property]];
    }
    [_currentRevisions save:_sourceTask];
    [_sourceTask addRevision:_currentRevisions];
    
    _unsavedChanges = [NSMutableDictionary new];
    _currentRevisions = [CSTaskRevisionRealmModel new];
    
    [self reloadTableViews];
}


- (void)reloadTableViews {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.taskImageTableView reloadData];
        [self.taskRevisionsTableView reloadData];
    });
    
}

@end
