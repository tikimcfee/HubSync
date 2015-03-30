//
//  HSTaskListViewController.m
//  HubSync
//
//  Created by CommSync on 3/30/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import "HSTaskListViewController.h"
#import "HSTaskListCell.h"

@interface HSTaskListViewController ()

@end

@implementation HSTaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

#pragma mark - Delegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 64.0f;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    
}

#pragma mark - Data Source
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 5;
}

- (id)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    HSTaskListCell* cell = [tableView makeViewWithIdentifier:@"TaskCell" owner:self];
    
    [cell configureWithSourceTask:nil];
    
    
    return cell;
}

@end
