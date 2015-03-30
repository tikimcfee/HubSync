//
//  HSTaskListViewController.h
//  HubSync
//
//  Created by CommSync on 3/30/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HSTaskListViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>
@property (strong) IBOutlet NSTableView *taskList;


@end
