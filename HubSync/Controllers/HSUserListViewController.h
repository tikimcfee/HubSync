//
//  HSUserListViewController.h
//  HubSync
//
//  Created by Student on 4/1/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HSUserListViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>
@property (strong) IBOutlet NSTableView *userList;


@end
