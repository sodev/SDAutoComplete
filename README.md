SDAutoComplete
==============

Auto Complete text field for iOS

SDAutoComplete is a sublass of UITexField designed to act like a html autocomplete field

##Usage
SDAutoComplete works in the place of an regular UITextField, simply set the searchData property containing the autocomplete results.

The data can be either an array of strings or an array of dictionaries, to use an array of dictionaries simply set the sortKey property

Set the delegate to access the selected object or determine if the field has been editted

##Example
SDAutoCompleteField *autocompleteField = [[SDAutoCompleteField alloc] init];

NSArray *countries = [NSArray arrayWithObjects:@"Australia", @"Bahrain", @"Cuba", @"Denmark", nil];

[autocompleteField setSearchData:countries];

[automcompleteField setDelegate:self];

(void)DidSelectObject:(id)object
{
  NSLog(@"You selected: %@", object); 
}
