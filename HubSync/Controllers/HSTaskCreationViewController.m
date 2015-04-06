//
//  HSTaskCreationViewController.m
//  HubSync
//
//  Created by Ivan Lugo on 4/6/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import "HSTaskCreationViewController.h"
#import "CSTaskTransientObjectStore.h"
#import "CSSessionDataAnalyzer.h"

@interface HSTaskCreationViewController ()

@property (weak, nonatomic) RLMRealm* realm;
@property (strong) CSTaskTransientObjectStore* pendingTask;

@end

@implementation HSTaskCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [_createButton setWantsLayer:YES];
    _createButton.layer.backgroundColor = [NSColor yellowColor].CGColor;

    // LOW / MED / HIGH
//    // 100 / 200 / 300
//    [[_prioritySelectionControl viewWithTag:100] setWantsLayer:YES];
//    ((NSView*)[_prioritySelectionControl viewWithTag:100]).layer.backgroundColor = [NSColor greenColor].CGColor;
//    
//    [[_prioritySelectionControl viewWithTag:200] setWantsLayer:YES];
//    ((NSView*)[_prioritySelectionControl viewWithTag:200]).layer.backgroundColor = [NSColor yellowColor].CGColor;
//    
//    [[_prioritySelectionControl viewWithTag:300] setWantsLayer:YES];
//    ((NSView*)[_prioritySelectionControl viewWithTag:300]).layer.backgroundColor = [NSColor redColor].CGColor;
    
    NSString* U = [NSString stringWithFormat:@"%c%c%c%c%c",
                   arc4random_uniform(25)+65,
                   arc4random_uniform(25)+65,
                   arc4random_uniform(25)+65,
                   arc4random_uniform(25)+65,
                   arc4random_uniform(25)+65];
    NSString* D = [NSString stringWithFormat:@"%c%c%c%c%c",
                   arc4random_uniform(25)+97,
                   arc4random_uniform(25)+97,
                   arc4random_uniform(25)+97,
                   arc4random_uniform(25)+97,
                   arc4random_uniform(25)+97];
    
    _realm = [RLMRealm defaultRealm];
    
    self.pendingTask = [[CSTaskTransientObjectStore alloc] init];
    _pendingTask.UUID = U;
    _pendingTask.deviceID = D;
    _pendingTask.concatenatedID = [NSString stringWithFormat:@"%@%@", U, D];
}

- (IBAction)createButtonClicked:(id)sender {
    
    _pendingTask.taskTitle = _taskTitleTextField.stringValue;
    _pendingTask.taskDescription = _taskDescriptionTextView.string;
    switch (_prioritySelectionControl.selectedSegment) {
        case 0:
            _pendingTask.taskPriority = CSTaskPriorityLow;
            break;
        case 1:
            _pendingTask.taskPriority = CSTaskPriorityMedium;
            break;
        case 2:
            _pendingTask.taskPriority = CSTaskPriorityHigh;
            break;
        default:
            _pendingTask.taskPriority = CSTaskPriorityMedium;
            break;
    }
    
    CSTaskRealmModel* newTask = [[CSTaskRealmModel alloc] init];
    [self.pendingTask setAndPersistPropertiesOfNewTaskObject:newTask inRealm:_realm];
    
    [[CSSessionDataAnalyzer sharedInstance:nil] sendMessageToAllPeersForNewTask:self.pendingTask];
    
    [self dismissController:self];
}

@end
