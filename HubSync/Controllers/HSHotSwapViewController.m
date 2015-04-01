//
//  HSHotSwapViewController.m
//  HubSync
//
//  Created by Ivan Lugo on 3/31/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import "HSHotSwapViewController.h"
#import "HSTaskDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

#define SegueIdentifierFirst @"embedFirst"
#define SegueIdentifierSecond @"embedSecond"

@interface HSHotSwapViewController ()

@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property (strong, nonatomic) HSTaskDetailViewController *firstViewController;
@property (strong, nonatomic) HSTaskDetailViewController *secondViewController;

@property (strong, nonatomic) NSViewController *currentViewController;

@property (assign, nonatomic) BOOL transitionInProgress;

@end

@implementation HSHotSwapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    
    [self.view setWantsLayer:YES];
//    self.view.layer.backgroundColor = [NSColor redColor].CGColor;
    self.transitionInProgress = NO;
    self.currentSegueIdentifier = SegueIdentifierFirst;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Instead of creating new VCs on each seque we want to hang on to existing
    // instances if we have it. Remove the second condition of the following
    // two if statements to get new VC instances instead.
    if ([segue.identifier isEqualToString:SegueIdentifierFirst]) {
        self.firstViewController = segue.destinationController;
        [self.firstViewController.view setWantsLayer:YES];
    }
    
    if ([segue.identifier isEqualToString:SegueIdentifierSecond]) {
        self.secondViewController = segue.destinationController;
        [self.secondViewController.view setWantsLayer:YES];
    }
    
    // If we're going to the first view controller.
    if ([segue.identifier isEqualToString:SegueIdentifierFirst]) {
        // If this is not the first time we're loading this.
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.firstViewController];
        }
        else {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            [self addChildViewController:segue.destinationController];
            NSView* destView = ((NSViewController *)segue.destinationController).view;
            [self.view addSubview:destView];
        }
    }
    // By definition the second view controller will always be swapped with the
    // first one.
    else if ([segue.identifier isEqualToString:SegueIdentifierSecond]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.secondViewController];
    }
}

- (void)swapFromViewController:(NSViewController *)fromViewController toViewController:(NSViewController *)toViewController
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    _currentViewController = toViewController;
    [self addChildViewController:toViewController];
    
    [self transitionFromViewController:fromViewController toViewController:toViewController options:NSViewControllerTransitionNone completionHandler:^{
        [fromViewController removeFromParentViewController];
        self.transitionInProgress = NO;
    }];
}

- (void)swapToViewController:(NSViewController*) viewController {
    if(viewController == _currentViewController) {
        return;
    }
    
    [self swapFromViewController:_currentViewController toViewController:viewController];
}

- (void)swapViewControllers
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.transitionInProgress) {
        return;
    }
    
    self.transitionInProgress = YES;
    self.currentSegueIdentifier = ([self.currentSegueIdentifier isEqualToString:SegueIdentifierFirst]) ? SegueIdentifierSecond : SegueIdentifierFirst;
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierFirst]) && self.firstViewController) {
        [self swapFromViewController:self.secondViewController toViewController:self.firstViewController];
        return;
    }
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierSecond]) && self.secondViewController) {
        [self swapFromViewController:self.firstViewController toViewController:self.secondViewController];
        return;
    }
    
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

@end
