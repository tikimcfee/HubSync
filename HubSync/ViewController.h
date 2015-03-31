//
//  ViewController.h
//  HubSync
//
//  Created by CommSync on 3/30/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HSTaskDetailViewController.h"
#import "HSHotSwapViewController.h"

@interface ViewController : NSViewController

@property (strong) IBOutlet NSTabView *mainTabView;
@property (strong) IBOutlet NSView *mainContainerView;

@property (strong) IBOutlet NSView *tasksView;
@property (strong) IBOutlet NSScrollView *taskList;

@property (strong) IBOutlet NSView *usersView;

@property (strong, nonatomic) HSTaskDetailViewController* taskDetailViewController;

@property (strong, nonatomic) HSHotSwapViewController* hotSwapViewController;



@end

