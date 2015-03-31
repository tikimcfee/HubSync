//
//  ViewController.m
//  HubSync
//
//  Created by CommSync on 3/30/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import "ViewController.h"
#import "HSTaskListCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
//    _taskDetailController = [[HSTaskDetailViewController alloc]
//                             initWithNibName:@"HSTaskDetailViewController"
//                             bundle:[NSBundle mainBundle]];
    
    
//    [_mainContainerView addSubview: _taskDetailController.view];
//    [_taskDetailController.view setNeedsLayout:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newTaskDetailSelected:)
                                                 name:@"kSelectedRowNotification"
                                               object:nil];
    
    
    
    NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
//    HSTaskDetailViewController *taskDetailVC = [sb instantiateControllerWithIdentifier:@"HSTaskDetailViewController"];
    self.taskDetailViewController = [sb instantiateControllerWithIdentifier:@"HSTaskDetailViewController"];
    [self.mainContainerView addSubview:self.taskDetailViewController.view];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)newTaskDetailSelected:(NSNotification*)notification {
    
    if ([notification.object isKindOfClass:[HSTaskListCell class]]) {
        HSTaskListCell *cell = notification.object;
        __weak ViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.taskDetailViewController.taskNameLabel.stringValue = cell.sourceTask.taskTitle;
            weakSelf.taskDetailViewController.taskDescriptionTextField.stringValue = cell.sourceTask.taskDescription;
        });
    }
//    else if ([notification.object isKindOfClass:[HSUserListCell class]]) {
//        
//    }
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

@end
