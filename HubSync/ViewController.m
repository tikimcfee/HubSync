//
//  ViewController.m
//  HubSync
//
//  Created by CommSync on 3/30/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import "ViewController.h"
#import "HSTaskListCell.h"
#import "HSConstantsHeader.h"
#import "HSTaskCreationViewController.h"

@interface EmptySegue : NSStoryboardSegue

@end

@implementation EmptySegue

- (void) perform {
    
}
@end

@interface ViewController ()

@property (strong) NSStoryboard* sb;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the vieww
    _sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (IBAction)creationButtonClicked:(id)sender {
//    [[NSNotificationCenter defaultCenter] postNotificationName:kHSTaskCreationButtonClickedNotification object:nil];
    
    //    _taskDetailController = [[HSTaskDetailViewController alloc]
    //                             initWithNibName:@"HSTaskDetailViewController"
    //                             bundle:[NSBundle mainBundle]];
    
    
    //    [_mainContainerView addSubview: _taskDetailController.view];
    //    [_taskDetailController.view setNeedsLayout:YES];
    
//    HSTaskCreationViewController* newTaskController = [[HSTaskCreationViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    
    HSTaskCreationViewController* ntc = [_sb instantiateControllerWithIdentifier:@"HSTaskCreationViewController"];
    
    [self presentViewControllerAsModalWindow:ntc];
}


@end
