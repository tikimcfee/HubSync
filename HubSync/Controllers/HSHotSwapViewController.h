//
//  HSHotSwapViewController.h
//  HubSync
//
//  Created by Ivan Lugo on 3/31/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HSHotSwapViewController : NSViewController <NSTabViewDelegate>

//- (void)swapViewControllers;
- (void)swapToViewController:(NSViewController*) viewController;

@end
