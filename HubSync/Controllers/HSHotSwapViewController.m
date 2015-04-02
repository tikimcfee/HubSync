//
//  HSHotSwapViewController.m
//  HubSync
//
//  Created by Ivan Lugo on 3/31/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import "HSHotSwapViewController.h"
#import "HSTaskDetailViewController.h"
#import "HSUserDetailViewController.h"
#import "HSConstantsHeader.h"
#import <QuartzCore/QuartzCore.h>

#define SegueIdentifierFirst @"TaskDetailViewController"
#define SegueIdentifierSecond @"UserDetailViewController"

@interface HSHotSwapViewController ()

@property (strong, nonatomic) NSString *currentSegueIdentifier;

@property (strong, nonatomic) HSTaskDetailViewController *taskDetailViewController;
@property (strong, nonatomic) HSUserDetailViewController *userDetailViewController;

@property (strong, nonatomic) NSViewController *currentViewController;

@property (assign, nonatomic) BOOL transitionInProgress;

@end

@implementation HSHotSwapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newTaskDetailSelected:)
                                                 name:kHSSelectedTaskDetailRowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newUserDetailSelected:)
                                                 name:kHSSelectedUserDetailNotification
                                               object:nil];
    
    [self.view setWantsLayer:YES];
    self.transitionInProgress = NO;
    self.currentSegueIdentifier = SegueIdentifierFirst;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)newTaskDetailSelected:(NSNotification*)notification {
    if(_taskDetailViewController == nil) {
        [self performSegueWithIdentifier:SegueIdentifierFirst sender:notification.object];
    } else {
        [self swapFromViewController:_currentViewController toViewController:_taskDetailViewController];
    }
}

- (void)newUserDetailSelected:(NSNotification*)notification {
    if(_userDetailViewController == nil) {
        [self performSegueWithIdentifier:SegueIdentifierSecond sender:notification.object];
    } else {
        [self swapFromViewController:_currentViewController toViewController:_userDetailViewController];
    }
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    
    // Instead of creating new VCs on each seque we want to hang on to existing
    // instances if we have it. Remove the second condition of the following
    // two if statements to get new VC instances instead.
    if ([segue.identifier isEqualToString:SegueIdentifierFirst]) {
        self.taskDetailViewController = segue.destinationController;
        [self.taskDetailViewController.view setWantsLayer:YES];
    }
    
    if ([segue.identifier isEqualToString:SegueIdentifierSecond]) {
        self.userDetailViewController = segue.destinationController;
        [self.userDetailViewController.view setWantsLayer:YES];
        self.userDetailViewController.userDisplayName = sender;
    }
    
    // If we're going to the first view controller.
    if ([segue.identifier isEqualToString:SegueIdentifierFirst]) {
        // If this is not the first time we're loading this.
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.taskDetailViewController];
        }
        else {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            [self addChildViewController:segue.destinationController];
            NSView* destView = ((NSViewController *)segue.destinationController).view;
            [self.view addSubview:destView];
            
            _currentViewController = segue.destinationController;
        }
    }
    // By definition the second view controller will always be swapped with the
    // first one.
    else if ([segue.identifier isEqualToString:SegueIdentifierSecond]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.userDetailViewController];
    }
}

- (void)swapFromViewController:(NSViewController *)fromViewController toViewController:(NSViewController *)toViewController
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    if(toViewController == _currentViewController) {
        return;
    }
    
    _currentViewController = toViewController;
    [self addChildViewController:toViewController];
    
    [self transitionFromViewController:fromViewController toViewController:toViewController options:NSViewControllerTransitionNone completionHandler:^{
        [fromViewController removeFromParentViewController];
        self.transitionInProgress = NO;
        [self.view setNeedsDisplay:YES];
    }];
}

- (void)swapToViewController:(NSViewController*) viewController {
    if(viewController == _currentViewController) {
        return;
    }
    
    [self swapFromViewController:_currentViewController toViewController:viewController];
}

//- (void)swapViewControllers
//{
////    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    if (self.transitionInProgress) {
//        return;
//    }
//    
//    self.transitionInProgress = YES;
//    self.currentSegueIdentifier = ([self.currentSegueIdentifier isEqualToString:SegueIdentifierFirst]) ? SegueIdentifierSecond : SegueIdentifierFirst;
//    
//    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierFirst]) && self.firstViewController) {
//        [self swapFromViewController:self.secondViewController toViewController:self.firstViewController];
//        return;
//    }
//    
//    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierSecond]) && self.secondViewController) {
//        [self swapFromViewController:self.firstViewController toViewController:self.secondViewController];
//        return;
//    }
//    
//    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
//}

@end
