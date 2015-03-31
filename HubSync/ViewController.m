//
//  ViewController.m
//  HubSync
//
//  Created by CommSync on 3/30/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import "ViewController.h"
#import "HSTaskListCell.h"

@interface EmptySegue : NSStoryboardSegue

@end

@implementation EmptySegue

- (void) perform {
    
}
@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the vieww
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newTaskDetailSelected:)
                                                 name:@"kSelectedRowNotification"
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if(_hotSwapViewController == nil && [segue.identifier isEqualToString:@"HotSwap"]){
        _hotSwapViewController = segue.destinationController;
    }
}

- (void)newTaskDetailSelected:(NSNotification*)notification {
    [_hotSwapViewController swapViewControllers];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

@end
