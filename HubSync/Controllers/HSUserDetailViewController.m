//
//  HSUserDetailViewController.m
//  HubSync
//
//  Created by CommSync on 4/1/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import "HSUserDetailViewController.h"
#import "HSConstantsHeader.h"

@interface HSUserDetailViewController ()

@end

@implementation HSUserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newUserDetailSelected:)
                                                 name:kHSSelectedUserDetailNotification
                                               object:nil];
}

- (void)newUserDetailSelected:(NSNotification*)notification {
    _userDiplayNameLabel.stringValue = notification.object;
}

- (void)viewDidAppear {
    if(_userDisplayName) {
        _userDiplayNameLabel.stringValue = _userDisplayName;
        _userDisplayName = nil;
    }
}

@end
