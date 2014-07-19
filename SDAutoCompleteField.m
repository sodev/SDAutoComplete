//
//  SDAutoCompleteField.m
//  addItem
//
//  Created by Sean O'Connor on 15/04/14.
//  Copyright (c) 2014 SODev. All rights reserved.
//

#import "SDAutoCompleteField.h"

static NSInteger const kFieldHeight = 42;
static NSInteger const kNumberOfRows = 6;

@implementation SDAutoCompleteField
@synthesize searchData;
@synthesize sortKey;

#pragma mark - View Drawing Methods

// Override the init method
- (id)init
{
    self = [super init];
    if (self) {
        [self customizeTextField];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customizeTextField];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self customizeTextField];
}

- (void)setFrameX:(CGFloat)frameX
{
    [super setFrameX:frameX];
    [self customizeTextField];
}

- (void)setFrameY:(CGFloat)frameY
{
    [super setFrameY:frameY];
    [self customizeTextField];
}

- (void)setFrameWidth:(CGFloat)frameWidth
{
    [super setFrameWidth:frameWidth];
    [self customizeTextField];
}

- (void)setFrameHeight:(CGFloat)frameHeight
{
    [super setFrameHeight:frameHeight];
    [self customizeTextField];
}

#pragma mark - Custom Methods

// Create a class to customize the TextField
- (void)customizeTextField
{
    // ADD TEXT CHANGED SELECTOR TO TEXTFIELD
    [self addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
    
    // REMOVE CLIPPING
    [self setClipsToBounds:NO];
    
    // REMOVE AUTOCORRECTION
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    autocompleteResults = searchData;
    
    // CREATE THE AUTO COMPLETE TABLE
    autocompleteTable = [[UITableView alloc] init];
    [autocompleteTable setFrameY:[self frameHeight]];
    [autocompleteTable setFrameWidth:[self frameWidth]];
    [autocompleteTable setDataSource:self];
    [autocompleteTable setDelegate:self];
    [[autocompleteTable layer] setBorderWidth:2];
    [[autocompleteTable layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self addSubview:autocompleteTable];
}

// Create a class to call when the textfield changes
- (void)textChanged
{
    // CALL THE DID EDIT FIELD PROTOCOL
    [[self customDelegate] didEditField];
    
    // SHOW THE TABLE
    [autocompleteTable setHidden:NO];
    
    // SEARCH THE TEXT
    [self SearchText:[self text]];
}

// Create a class for searching the text string in the search Array
- (void)SearchText:(NSString *)text
{
    // DECLARE A TEMPORARY SORT KEY
    NSString *tempSortKey = sortKey;
    
    // CHECK IF A SORTKEY HAS BEEN SET
    BOOL sortKeyNotSet = [sortKey length] == 0;
    if (sortKeyNotSet) {
        tempSortKey = @"SELF";
    }
    
    // ITEM NAMES FIELD
    // We need to wrap the text in Quotation marks so that single quotes don't end the predicate
    // Remembering that the for string with formate " needs to be added as \"
    NSString *predicateString = [NSString stringWithFormat:@"%@ contains[cd] \"%@\"", tempSortKey, text];
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:predicateString];
    autocompleteResults = [searchData filteredArrayUsingPredicate:searchPredicate];
    [autocompleteTable setFrameHeight:MIN([autocompleteResults count], kNumberOfRows) * kFieldHeight];
    [autocompleteTable reloadData];
    
}

#pragma mark - UITableView Datasource and Delegate protocols

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [autocompleteResults count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kFieldHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // CREATE AN INSTANCE OF UITABLEVIEW WITH THE DEFAULT APPEARANCE
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    id object = [autocompleteResults objectAtIndex:[indexPath row]];
    
    // CHECK IF A SORTKEY HAS BEEN SET
    BOOL sortKeyNotSet = [sortKey length] == 0;
    if (sortKeyNotSet) {
        [[cell textLabel] setText:[object capitalizedString]];
    } else {
        [[cell textLabel] setText:[[object objectForKey:sortKey] capitalizedString]];
    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self customDelegate] DidSelectObject:[autocompleteResults objectAtIndex:[indexPath row]]];
    [tableView setHidden:YES];
}

#pragma mark - Override Hittest for table view
// Override the hit test to capture the tableview row select
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // Check that the hittest isn't on an object that is outside of the screen, hidden or transparent
    if (![self clipsToBounds] && ![self isHidden] && [self alpha] > 0) {
        
        // Loop through all the subviews
        for (UIView *subview in self.subviews.reverseObjectEnumerator) {
            // Create the point in each of the subviews with the hit point
            CGPoint subPoint = [subview convertPoint:point fromView:self];
            
            // Check if there is an event that can be performed
            UIView *result = [subview hitTest:subPoint withEvent:event];
            if (result != nil) {
                //  Return event
                return result;
                break;
            }
        }
    }
    
    // use this to pass the 'touch' onward in case no subviews trigger the touch
    return [super hitTest:point withEvent:event];
}

@end
