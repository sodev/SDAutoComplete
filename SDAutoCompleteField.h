//
//  SDAutoCompleteField.h
//  addItem
//
//  Created by Sean O'Connor on 15/04/14.
//  Copyright (c) 2014 SODev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "UIView+position.h"

// Create a class of the SDAutoCompleteField for use in the delegate methods
@class SDAutoCompleteField;

// Declare the SDAutoCompleteField delegate protocol
@protocol SDAutoCompleteFieldDelegate <NSObject>

// Declare the delegate method
- (void)DidSelectObject:(id)object;
- (void)didEditField;

@end

@interface SDAutoCompleteField : UITextField <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    // --VIEW--
    UITableView *autocompleteTable;
    
    // --MODEL--
    NSArray *autocompleteResults;
}

@property (nonatomic, strong) NSArray *searchData;
@property (nonatomic, strong) NSString *sortKey;

#pragma mark - Custom classes
- (void)customizeTextField;
- (void)textChanged;

// --DELEGATES--
@property (nonatomic, weak) id <SDAutoCompleteFieldDelegate> customDelegate;

@end
