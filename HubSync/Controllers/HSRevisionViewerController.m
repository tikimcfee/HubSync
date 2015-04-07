//
//  HSRevisionViewerController.m
//  HubSync
//
//  Created by Ivan Lugo on 4/7/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import "HSRevisionViewerController.h"

@interface HSRevisionViewerController ()

@property (strong, nonatomic) NSMutableDictionary* changes;
@property (strong, nonatomic) NSMutableArray* changesKeys;
@property (strong, nonatomic) NSMutableArray* changesHeights;

@end

@implementation HSRevisionViewerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
}

- (void) configureWithSourceTask:(CSTaskRealmModel*)sourceTask
                  sourceRevision:(CSTaskRevisionRealmModel*)sourceRevision {
    
    _sourceTask = sourceTask;
    _sourceRevision = sourceRevision;
    
    _changesHeights = [NSMutableArray new];
    _changes = [NSKeyedUnarchiver unarchiveObjectWithData:_sourceRevision.changesDictionary];
    _changesKeys = [NSMutableArray new];
    for (NSString* changeKey in _changes) {
        [_changesKeys addObject:changeKey];
    }
    
    [_revisionsTableView reloadData];
}

#pragma mark - Tableview DataSource / Delegate
- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {

    return _changesKeys.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    if(row < _changesHeights.count) {
        NSNumber* num = [_changesHeights objectAtIndex:row];
        return [num floatValue];
    }else {
        NSString* valueTo = [[_changes valueForKey:[_changesKeys objectAtIndex:row]] valueForKey:@"to"];
        NSString* valueFrom = [[_changes valueForKey:[_changesKeys objectAtIndex:row]] valueForKey:@"from"];
        
        NSNumber* f = [NSNumber numberWithFloat: [self calculateIdealHeightForSize:CGSizeMake(300, 100000)
                                                                            string:valueTo]];
        NSNumber* t = [NSNumber numberWithFloat: [self calculateIdealHeightForSize:CGSizeMake(300, 100000)
                                                                            string:valueFrom]];
                       
       [_changesHeights insertObject:[NSNumber numberWithFloat:MAX([f floatValue], [t floatValue])]
                             atIndex:row];
        
        return [[_changesHeights objectAtIndex:row] floatValue];
    }
    
    return -1;
}

- (CGFloat) calculateIdealHeightForSize:(NSSize) size string:(NSString*)string;
{
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:string];
    NSTextStorage * storage =
    [[NSTextStorage alloc] initWithAttributedString: attrStr];
    
    NSTextContainer * container =
    [[NSTextContainer alloc] initWithContainerSize: size];
    NSLayoutManager * manager = [[NSLayoutManager alloc] init];
    
    [manager addTextContainer: container];
    [storage addLayoutManager: manager];
    
    [manager glyphRangeForTextContainer: container];
    
    NSRect idealRect = [manager usedRectForTextContainer: container];
    
    // Include a fudge factor.
    return idealRect.size.height + 25;
}

- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if(tableColumn == _propertyColumn) {
        return [self configurePropertyViewForRow:row];
    } else if(tableColumn == _changedFromColumn) {
        return [self configureFromViewForRow:row];
    } else if (tableColumn == _changedToColumn) {
        return [self configureToViewForRow:row];
    } else if (tableColumn == _actionColumn) {
        
    }
    
    return nil;
}

-(NSView*) configureFromViewForRow:(NSInteger) row{
    NSTableCellView* fromText = [_revisionsTableView makeViewWithIdentifier:kChangedFromViewIdentifier owner:self];
    NSString* key = [_changesKeys objectAtIndex:row];
    NSString* value = [[_changes valueForKey:key] valueForKey:@"from"];
    fromText.textField.stringValue = value;
    
    return fromText;
}

-(NSView*) configureToViewForRow:(NSInteger) row{
    NSTableCellView* toText = [_revisionsTableView makeViewWithIdentifier:kChangedToViewIdentifier owner:self];
    NSString* key = [_changesKeys objectAtIndex:row];
    NSString* value = [[_changes valueForKey:key] valueForKey:@"to"];
    toText.textField.stringValue = value;
    
    return toText;
}

-(NSView*) configurePropertyViewForRow:(NSInteger) row{
    NSTableCellView* propertyName = [_revisionsTableView makeViewWithIdentifier:kPropertyNameViewIdentifier owner:self];
    NSString* key = [_changesKeys objectAtIndex:row];
    propertyName.textField.stringValue = key;
    
    return propertyName;
}

-(void) configureActionViewForRow:(NSInteger) row{
    
}




@end
