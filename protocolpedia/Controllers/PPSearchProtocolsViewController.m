//
//  PPSearchProtocolsViewController.m
//  ProtocolPedia
//
//  25/06/14.


#import "PPSearchProtocolsViewController.h"

#import "SQLiteAccess.h"


#import "PPSelectCategoriesViewController.h"
#import "PPSearchTypeViewController.h"
#import "PPSearchResultsViewController.h"

@interface PPSearchProtocolsViewController ()

@end

@implementation PPSearchProtocolsViewController

@synthesize tableView, dataSource;
@synthesize selectedVideosCategories, selectedTopicsCategories, selectedProtocolCategories;
@synthesize videosSearchResults, topicsSearchResults, protocolSearchResults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *slideLeftImage = [UIImage imageNamed:@"btn_slide_left.png"];
    [self setLeftBarButton:slideLeftImage];
    
    self.dataSource = [NSArray arrayWithObjects:@"Protocols",@"Forum Topics",@"Videos",@"Search Type",@"Search",nil];
	self.searchOption = 0;
	self.searchFor.text = [applicationDelegate.settings objectForKey:@"LastSearch"];
	self.searchForString = self.searchFor.text;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    applicationDelegate.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    
    [self getSelectedCategories];
	[self.tableView reloadData];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    
    self.tableView = nil;
}


-(void) getSelectedCategories {
	self.selectedVideosCategories = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:@"SELECT CategoryId, CategoryType, Name, Selected FROM Categories WHERE CategoryType = \"Video\" AND Selected = \"Yes\" ORDER BY Name"];
	self.selectedTopicsCategories = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:@"SELECT CategoryId, CategoryType, Name, Selected FROM Categories WHERE CategoryType = \"Topics\" AND ParentID = \"1\" AND Selected = \"Yes\" ORDER BY Name"];
	self.selectedProtocolCategories = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:@"SELECT CategoryId, CategoryType, Name, Selected FROM Categories WHERE CategoryType = \"Protocol\" AND CategoryId <> \"1\" AND Selected = \"Yes\" ORDER BY Name"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 2) {
		return 3;
	}
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 1) {
		return 30;
	}
	return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLabel.frame = CGRectMake(0, 0, 320, 20);
        tempLabel.text = @"Advanced Options";
        tempLabel.textAlignment = UITextAlignmentCenter;
        tempLabel.font = [UIFont systemFontOfSize:16];
        tempLabel.textColor = [UIColor blackColor];
        tempLabel.backgroundColor = [UIColor clearColor];
        return tempLabel;
    }
    return nil;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    if (indexPath.section == 2) {
        cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i Categories Selected",[self.selectedProtocolCategories count]];
        } else if (indexPath.row == 1) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i Categories Selected",[self.selectedTopicsCategories count]];
        } else if (indexPath.row == 2) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i Categories Selected",[self.selectedVideosCategories count]];
        }
        
        
        
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row + 3];
        cell.detailTextLabel.text = [applicationDelegate.settings objectForKey:@"SearchType"];
		
		
		
    } else if (indexPath.section == 0) {
        cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row + 4];
    }
    
    
    
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView_ deselectRowAtIndexPath:indexPath animated:NO];
    
	if (indexPath.section == 2) {
        PPSelectCategoriesViewController *selectCategoriesViewController = [[PPSelectCategoriesViewController alloc] initWithNibName:@"PPSelectCategoriesViewController" bundle:nil];
        if (indexPath.row == 0) {
            selectCategoriesViewController.categoryType = @"Protocol";
        } else if (indexPath.row == 1) {
            selectCategoriesViewController.categoryType = @"Topics";
        } else if (indexPath.row == 2) {
            selectCategoriesViewController.categoryType = @"Video";
        }
        [self.navigationController pushViewController:selectCategoriesViewController animated:YES];
        
	} else if (indexPath.section == 1) {
        
        PPSearchTypeViewController *searchTypeViewController = [[PPSearchTypeViewController alloc] initWithNibName:@"PPSearchTypeViewController" bundle:nil];
        [self.navigationController pushViewController:searchTypeViewController animated:YES];
        
		
	} else if (indexPath.section == 0) {
        
        [self.searchFor resignFirstResponder];
        self.searchForString = self.searchFor.text;
        [applicationDelegate.settings setObject:self.searchForString forKey:@"LastSearch"];
        
		[self getSearchResults];
        
        PPSearchResultsViewController *searchResultsViewController = [[PPSearchResultsViewController alloc] initWithNibName:@"PPSearchResultsViewController" bundle:nil];
        searchResultsViewController.protocolSearchResults = self.protocolSearchResults;
        searchResultsViewController.topicsSearchResults = self.topicsSearchResults;
        searchResultsViewController.videosSearchResults = self.videosSearchResults;
        [self.navigationController pushViewController:searchResultsViewController animated:YES];
        
	}
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
	self.searchForString = textField.text;
	[applicationDelegate.settings setObject:textField.text forKey:@"LastSearch"];
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	self.searchForString = textField.text;
	[applicationDelegate.settings setObject:textField.text forKey:@"LastSearch"];
	return YES;
}


-(void) getSearchResults {
	if ([self.searchForString length] > 0) {
		NSString *tempSearchType = [applicationDelegate.settings objectForKey:@"SearchType"];
		if ([tempSearchType isEqualToString:@"Any Words"]) {
			[self anyWords];
		} else if ([tempSearchType isEqualToString:@"All Words"]) {
			[self allWords];
		} else {
			[self exactPhrase];
		}
	} else {
		[GlobalMethods displayMessage:@"No search criteria specified"];
	}
    
}


-(void) anyWords {
	NSMutableArray *searchPhrases = [NSMutableArray array];
	NSMutableArray *searchWords = [NSMutableArray array];
    
	NSArray *searchPhrasesTemp = [self.searchForString componentsSeparatedByString:@"\""];
    int i = 1;
    for (id item in searchPhrasesTemp) {
        if (i % 2 == 1) {
            NSArray *searchWordsTemp = [item componentsSeparatedByString:@" "];
            for (id nextItem in searchWordsTemp) {
                if (![nextItem isEqualToString:@""]) {
                    [searchWords addObject:nextItem];
                }
            }
        } else {
            if (![item isEqualToString:@""]) {
                [searchPhrases addObject:item];
            }
        }
        i++;
    }
	
    // build sqls
	NSMutableString *selectProtocolsTitleCriteria = [NSMutableString string];
	NSMutableString *selectTopicsTitleCriteria = [NSMutableString string];
	NSMutableString *selectVideoTitleCriteria = [NSMutableString string];
    
	NSMutableString *selectProtocolsTextCriteria = [NSMutableString string];
	NSMutableString *selectTopicsTextCriteria = [NSMutableString string];
	NSMutableString *selectVideoTextCriteria = [NSMutableString string];
	
	NSMutableString *selectProtocolsCategoriesCriteria = [NSMutableString string];
	NSMutableString *selectTopicsCategoriesCriteria = [NSMutableString string];
	NSMutableString *selectVideoCategoriesCriteria = [NSMutableString string];
    
    
	
	//////  search protocols ////
	if ([self.selectedProtocolCategories count] > 0) {
		selectProtocolsCategoriesCriteria = [NSMutableString stringWithString:@"SELECT * FROM Protocols WHERE ProtocolId IN (SELECT ProtocolID FROM CategoryRelations WHERE CategoryId IN ("];
        
		for (id item in self.selectedProtocolCategories) {
			[selectProtocolsCategoriesCriteria appendFormat:@"\"%@\",",[item objectForKey:@"CategoryId"]];
		}
        
		selectProtocolsCategoriesCriteria = [NSMutableString stringWithString:[selectProtocolsCategoriesCriteria substringToIndex:([selectProtocolsCategoriesCriteria length]-1)]];
		[selectProtocolsCategoriesCriteria appendString:@"))"];
		
		//NSLog(@"selectProtocolsCategoriesCriteria %@",selectProtocolsCategoriesCriteria);
		
		[selectProtocolsTitleCriteria appendString:@" AND "];
		[selectProtocolsTextCriteria appendString:@" OR "];
		for (id item in searchPhrases) {
			[(NSMutableString*)selectProtocolsTitleCriteria appendFormat:@"Title LIKE \"%%%@%%\" OR ",item];
			[(NSMutableString*)selectProtocolsTextCriteria appendFormat:@"Text LIKE \"%%%@%%\" OR ",item];
            
		}
        
		for (id item in searchWords) {
            //	NSLog(@"item %@",item);
            
			[(NSMutableString*)selectProtocolsTitleCriteria appendFormat:@"Title LIKE \"%%%@%%\" OR ",item];
			[(NSMutableString*)selectProtocolsTextCriteria appendFormat:@"Text LIKE \"%%%@%%\" OR ",item];
		}
        
		selectProtocolsTitleCriteria = (NSMutableString*)[selectProtocolsTitleCriteria substringToIndex:([selectProtocolsTitleCriteria length]-4)];
		selectProtocolsTextCriteria = (NSMutableString*)[selectProtocolsTextCriteria substringToIndex:([selectProtocolsTextCriteria length]-4)];
	}
	NSString *selectProtocols = [NSString stringWithFormat:@"%@%@%@",selectProtocolsCategoriesCriteria,selectProtocolsTitleCriteria,selectProtocolsTextCriteria];
	self.protocolSearchResults = [SQLiteAccess selectManyRowsWithSQL:selectProtocols];
	//NSLog(@"selectProtocols %@",selectProtocols);
    
	/// search Topics   //////////////////
	if ([self.selectedTopicsCategories count] > 0) {
		selectTopicsCategoriesCriteria = [NSMutableString stringWithString:@"SELECT DiscussionId, ThreadId, Subject FROM Discussions WHERE CategoryId IN ("];
		
		for (id item in self.selectedTopicsCategories) {
			[selectTopicsCategoriesCriteria appendFormat:@"\"%@\",",[item objectForKey:@"CategoryId"]];
		}
		
		selectTopicsCategoriesCriteria = [NSMutableString stringWithString:[selectTopicsCategoriesCriteria substringToIndex:([selectTopicsCategoriesCriteria length]-1)]];
		[selectTopicsCategoriesCriteria appendString:@")"];
		
		//NSLog(@"selectTopicsCategoriesCriteria %@",selectTopicsCategoriesCriteria);
		
		[selectTopicsTitleCriteria appendString:@" AND "];
		[selectTopicsTextCriteria appendString:@" OR "];
		for (id item in searchPhrases) {
			[(NSMutableString*)selectTopicsTitleCriteria appendFormat:@"Subject LIKE \"%%%@%%\" OR ",item];
			[(NSMutableString*)selectTopicsTextCriteria appendFormat:@"MessageText LIKE \"%%%@%%\" OR ",item];
			
		}
		
		for (id item in searchWords) {
            //	NSLog(@"item %@",item);
			
			[(NSMutableString*)selectTopicsTitleCriteria appendFormat:@"Subject LIKE \"%%%@%%\" OR ",item];
			[(NSMutableString*)selectTopicsTextCriteria appendFormat:@"MessageText LIKE \"%%%@%%\" OR ",item];
		}
		
		selectTopicsTitleCriteria = (NSMutableString*)[selectTopicsTitleCriteria substringToIndex:([selectTopicsTitleCriteria length]-4)];
		selectTopicsTextCriteria = (NSMutableString*)[selectTopicsTextCriteria substringToIndex:([selectTopicsTextCriteria length]-4)];
	}
	NSString *selectTopics = [NSString stringWithFormat:@"%@%@%@",selectTopicsCategoriesCriteria,selectTopicsTitleCriteria,selectTopicsTextCriteria];
	self.topicsSearchResults = [SQLiteAccess selectManyRowsWithSQL:selectTopics];
	//NSLog(@"selectTopics %@",selectTopics);
    
	/// search Videos   //////////////////
	if ([self.selectedVideosCategories count] > 0) {
		selectVideoCategoriesCriteria = [NSMutableString stringWithString:@"SELECT VideoId, Title FROM Videos WHERE CategoryId IN ("];
		
		for (id item in self.selectedVideosCategories) {
			[selectVideoCategoriesCriteria appendFormat:@"\"%@\",",[item objectForKey:@"CategoryId"]];
		}
		
		selectVideoCategoriesCriteria = [NSMutableString stringWithString:[selectVideoCategoriesCriteria substringToIndex:([selectVideoCategoriesCriteria length]-1)]];
		[selectVideoCategoriesCriteria appendString:@")"];
		
        //	NSLog(@"selectVideoCategoriesCriteria %@",selectVideoCategoriesCriteria);
		
		[selectVideoTitleCriteria appendString:@" AND "];
		[selectVideoTextCriteria appendString:@" OR "];
		for (id item in searchPhrases) {
			[(NSMutableString*)selectVideoTitleCriteria appendFormat:@"Title LIKE \"%%%@%%\" OR ",item];
			[(NSMutableString*)selectVideoTextCriteria appendFormat:@"Description LIKE \"%%%@%%\" OR ",item];
			
		}
		
		for (id item in searchWords) {
            //		NSLog(@"item %@",item);
			
			[(NSMutableString*)selectVideoTitleCriteria appendFormat:@"Title LIKE \"%%%@%%\" OR ",item];
			[(NSMutableString*)selectVideoTextCriteria appendFormat:@"Description LIKE \"%%%@%%\" OR ",item];
		}
		
		selectVideoTitleCriteria = (NSMutableString*)[selectVideoTitleCriteria substringToIndex:([selectVideoTitleCriteria length]-4)];
		selectVideoTextCriteria = (NSMutableString*)[selectVideoTextCriteria substringToIndex:([selectVideoTextCriteria length]-4)];
	}
	NSString *selectVideo = [NSString stringWithFormat:@"%@%@%@",selectVideoCategoriesCriteria,selectVideoTitleCriteria,selectVideoTextCriteria];
	self.videosSearchResults = [SQLiteAccess selectManyRowsWithSQL:selectVideo];
	//	NSLog(@"selectVideo %@",selectVideo);
    
    
}


-(void) allWords {
	NSMutableArray *searchPhrases = [NSMutableArray array];
	NSMutableArray *searchWords = [NSMutableArray array];
	
	NSArray *searchPhrasesTemp = [self.searchForString componentsSeparatedByString:@"\""];
	int i = 1;
	for (id item in searchPhrasesTemp) {
		if (i % 2 == 1) {
			NSArray *searchWordsTemp = [item componentsSeparatedByString:@" "];
			for (id nextItem in searchWordsTemp) {
				if (![nextItem isEqualToString:@""]) {
					[searchWords addObject:nextItem];
				}
			}
		} else {
			if (![item isEqualToString:@""]) {
				[searchPhrases addObject:item];
			}
		}
		i++;
	}
	//NSLog(@"searchPhrases %@",searchPhrases);
	//NSLog(@"searchWords %@",searchWords);
	
	// build sqls
	NSMutableString *selectProtocolsTitleCriteria = [NSMutableString string];
	NSMutableString *selectTopicsTitleCriteria = [NSMutableString string];
	NSMutableString *selectVideoTitleCriteria = [NSMutableString string];
	
	NSMutableString *selectProtocolsTextCriteria = [NSMutableString string];
	NSMutableString *selectTopicsTextCriteria = [NSMutableString string];
	NSMutableString *selectVideoTextCriteria = [NSMutableString string];
	
	NSMutableString *selectProtocolsCategoriesCriteria = [NSMutableString string];
	NSMutableString *selectTopicsCategoriesCriteria = [NSMutableString string];
	NSMutableString *selectVideoCategoriesCriteria = [NSMutableString string];
	
	
	
	//////  search protocols ////
	if ([self.selectedProtocolCategories count] > 0) {
		selectProtocolsCategoriesCriteria = [NSMutableString stringWithString:@"SELECT * FROM Protocols WHERE ProtocolId IN (SELECT ProtocolID FROM CategoryRelations WHERE CategoryId IN ("];
		
		for (id item in self.selectedProtocolCategories) {
			[selectProtocolsCategoriesCriteria appendFormat:@"\"%@\",",[item objectForKey:@"CategoryId"]];
		}
		
		selectProtocolsCategoriesCriteria = [NSMutableString stringWithString:[selectProtocolsCategoriesCriteria substringToIndex:([selectProtocolsCategoriesCriteria length]-1)]];
		[selectProtocolsCategoriesCriteria appendString:@"))"];
		
        //	NSLog(@"selectProtocolsCategoriesCriteria %@",selectProtocolsCategoriesCriteria);
		
		[selectProtocolsTitleCriteria appendString:@" AND "];
		[selectProtocolsTextCriteria appendString:@" OR "];
		for (id item in searchPhrases) {
			[(NSMutableString*)selectProtocolsTitleCriteria appendFormat:@"Title LIKE \"%%%@%%\" AND ",item];
			[(NSMutableString*)selectProtocolsTextCriteria appendFormat:@"Text LIKE \"%%%@%%\" AND ",item];
			
		}
		
		for (id item in searchWords) {
            //	NSLog(@"item %@",item);
			
			[(NSMutableString*)selectProtocolsTitleCriteria appendFormat:@"Title LIKE \"%%%@%%\" AND ",item];
			[(NSMutableString*)selectProtocolsTextCriteria appendFormat:@"Text LIKE \"%%%@%%\" AND ",item];
		}
		
		selectProtocolsTitleCriteria = (NSMutableString*)[selectProtocolsTitleCriteria substringToIndex:([selectProtocolsTitleCriteria length]-4)];
		selectProtocolsTextCriteria = (NSMutableString*)[selectProtocolsTextCriteria substringToIndex:([selectProtocolsTextCriteria length]-4)];
	}
	NSString *selectProtocols = [NSString stringWithFormat:@"%@%@%@",selectProtocolsCategoriesCriteria,selectProtocolsTitleCriteria,selectProtocolsTextCriteria];
	self.protocolSearchResults = [SQLiteAccess selectManyRowsWithSQL:selectProtocols];
	//NSLog(@"selectProtocols %@",selectProtocols);
	
	/// search Topics   //////////////////
	if ([self.selectedTopicsCategories count] > 0) {
		selectTopicsCategoriesCriteria = [NSMutableString stringWithString:@"SELECT DiscussionId, ThreadId, Subject FROM Discussions WHERE CategoryId IN ("];
		
		for (id item in self.selectedTopicsCategories) {
			[selectTopicsCategoriesCriteria appendFormat:@"\"%@\",",[item objectForKey:@"CategoryId"]];
		}
		
		selectTopicsCategoriesCriteria = [NSMutableString stringWithString:[selectTopicsCategoriesCriteria substringToIndex:([selectTopicsCategoriesCriteria length]-1)]];
		[selectTopicsCategoriesCriteria appendString:@")"];
		
        //	NSLog(@"selectTopicsCategoriesCriteria %@",selectTopicsCategoriesCriteria);
		
		[selectTopicsTitleCriteria appendString:@" AND "];
		[selectTopicsTextCriteria appendString:@" OR "];
		for (id item in searchPhrases) {
			[(NSMutableString*)selectTopicsTitleCriteria appendFormat:@"Subject LIKE \"%%%@%%\" AND ",item];
			[(NSMutableString*)selectTopicsTextCriteria appendFormat:@"MessageText LIKE \"%%%@%%\" AND ",item];
			
		}
		
		for (id item in searchWords) {
            //		NSLog(@"item %@",item);
			
			[(NSMutableString*)selectTopicsTitleCriteria appendFormat:@"Subject LIKE \"%%%@%%\" AND ",item];
			[(NSMutableString*)selectTopicsTextCriteria appendFormat:@"MessageText LIKE \"%%%@%%\" AND ",item];
		}
		
		selectTopicsTitleCriteria = (NSMutableString*)[selectTopicsTitleCriteria substringToIndex:([selectTopicsTitleCriteria length]-4)];
		selectTopicsTextCriteria = (NSMutableString*)[selectTopicsTextCriteria substringToIndex:([selectTopicsTextCriteria length]-4)];
	}
	NSString *selectTopics = [NSString stringWithFormat:@"%@%@%@",selectTopicsCategoriesCriteria,selectTopicsTitleCriteria,selectTopicsTextCriteria];
	self.topicsSearchResults = [SQLiteAccess selectManyRowsWithSQL:selectTopics];
    //	NSLog(@"selectTopics %@",selectTopics);
	
	/// search Videos   //////////////////
	if ([self.selectedVideosCategories count] > 0) {
		selectVideoCategoriesCriteria = [NSMutableString stringWithString:@"SELECT VideoId, Title FROM Videos WHERE CategoryId IN ("];
		
		for (id item in self.selectedVideosCategories) {
			[selectVideoCategoriesCriteria appendFormat:@"\"%@\",",[item objectForKey:@"CategoryId"]];
		}
		
		selectVideoCategoriesCriteria = [NSMutableString stringWithString:[selectVideoCategoriesCriteria substringToIndex:([selectVideoCategoriesCriteria length]-1)]];
		[selectVideoCategoriesCriteria appendString:@")"];
		
        //	NSLog(@"selectVideoCategoriesCriteria %@",selectVideoCategoriesCriteria);
		
		[selectVideoTitleCriteria appendString:@" AND "];
		[selectVideoTextCriteria appendString:@" OR "];
		for (id item in searchPhrases) {
			[(NSMutableString*)selectVideoTitleCriteria appendFormat:@"Title LIKE \"%%%@%%\" AND ",item];
			[(NSMutableString*)selectVideoTextCriteria appendFormat:@"Description LIKE \"%%%@%%\" AND ",item];
			
		}
		
		for (id item in searchWords) {
            //		NSLog(@"item %@",item);
			
			[(NSMutableString*)selectVideoTitleCriteria appendFormat:@"Title LIKE \"%%%@%%\" AND ",item];
			[(NSMutableString*)selectVideoTextCriteria appendFormat:@"Description LIKE \"%%%@%%\" AND ",item];
		}
		
		selectVideoTitleCriteria = (NSMutableString*)[selectVideoTitleCriteria substringToIndex:([selectVideoTitleCriteria length]-4)];
		selectVideoTextCriteria = (NSMutableString*)[selectVideoTextCriteria substringToIndex:([selectVideoTextCriteria length]-4)];
	}
	NSString *selectVideo = [NSString stringWithFormat:@"%@%@%@",selectVideoCategoriesCriteria,selectVideoTitleCriteria,selectVideoTextCriteria];
	self.videosSearchResults = [SQLiteAccess selectManyRowsWithSQL:selectVideo];
	//NSLog(@"selectVideo %@",selectVideo);
}


-(void) exactPhrase {
    
	
    
	
	// build sqls
	NSMutableString *selectProtocolsTitleCriteria = [NSMutableString string];
	NSMutableString *selectTopicsTitleCriteria = [NSMutableString string];
	NSMutableString *selectVideoTitleCriteria = [NSMutableString string];
	
	NSMutableString *selectProtocolsTextCriteria = [NSMutableString string];
	NSMutableString *selectTopicsTextCriteria = [NSMutableString string];
	NSMutableString *selectVideoTextCriteria = [NSMutableString string];
	
	NSMutableString *selectProtocolsCategoriesCriteria = [NSMutableString string];
	NSMutableString *selectTopicsCategoriesCriteria = [NSMutableString string];
	NSMutableString *selectVideoCategoriesCriteria = [NSMutableString string];
	
	
	
	//////  search protocols ////
	if ([self.selectedProtocolCategories count] > 0) {
		selectProtocolsCategoriesCriteria = [NSMutableString stringWithString:@"SELECT * FROM Protocols WHERE ProtocolId IN (SELECT ProtocolID FROM CategoryRelations WHERE CategoryId IN ("];
		
		for (id item in self.selectedProtocolCategories) {
			[selectProtocolsCategoriesCriteria appendFormat:@"\"%@\",",[item objectForKey:@"CategoryId"]];
		}
		
		selectProtocolsCategoriesCriteria = [NSMutableString stringWithString:[selectProtocolsCategoriesCriteria substringToIndex:([selectProtocolsCategoriesCriteria length]-1)]];
		[selectProtocolsCategoriesCriteria appendString:@"))"];
        
        
		[(NSMutableString*)selectProtocolsTitleCriteria appendFormat:@" AND Title LIKE \"%%%@%%\"",self.searchForString];
		[(NSMutableString*)selectProtocolsTextCriteria appendFormat:@" OR Text LIKE \"%%%@%%\"",self.searchForString];
        
	}
	NSString *selectProtocols = [NSString stringWithFormat:@"%@%@%@",selectProtocolsCategoriesCriteria,selectProtocolsTitleCriteria,selectProtocolsTextCriteria];
	self.protocolSearchResults = [SQLiteAccess selectManyRowsWithSQL:selectProtocols];
	//NSLog(@"selectProtocols %@",selectProtocols);
	
	/// search Topics   //////////////////
	if ([self.selectedTopicsCategories count] > 0) {
		selectTopicsCategoriesCriteria = [NSMutableString stringWithString:@"SELECT DiscussionId, ThreadId, Subject FROM Discussions WHERE CategoryId IN ("];
		
		for (id item in self.selectedTopicsCategories) {
			[selectTopicsCategoriesCriteria appendFormat:@"\"%@\",",[item objectForKey:@"CategoryId"]];
		}
		
		selectTopicsCategoriesCriteria = [NSMutableString stringWithString:[selectTopicsCategoriesCriteria substringToIndex:([selectTopicsCategoriesCriteria length]-1)]];
		[selectTopicsCategoriesCriteria appendString:@")"];
		
		[(NSMutableString*)selectTopicsTitleCriteria appendFormat:@" AND Subject LIKE \"%%%@%%\"",self.searchForString];
		[(NSMutableString*)selectTopicsTextCriteria appendFormat:@" OR MessageText LIKE \"%%%@%%\"",self.searchForString];
		
	}
	NSString *selectTopics = [NSString stringWithFormat:@"%@%@%@",selectTopicsCategoriesCriteria,selectTopicsTitleCriteria,selectTopicsTextCriteria];
	self.topicsSearchResults = [SQLiteAccess selectManyRowsWithSQL:selectTopics];
	//NSLog(@"selectTopics %@",selectTopics);
	
	/// search Videos   //////////////////
	if ([self.selectedVideosCategories count] > 0) {
		selectVideoCategoriesCriteria = [NSMutableString stringWithString:@"SELECT VideoId, Title FROM Videos WHERE CategoryId IN ("];
		
		for (id item in self.selectedVideosCategories) {
			[selectVideoCategoriesCriteria appendFormat:@"\"%@\",",[item objectForKey:@"CategoryId"]];
		}
		
		selectVideoCategoriesCriteria = [NSMutableString stringWithString:[selectVideoCategoriesCriteria substringToIndex:([selectVideoCategoriesCriteria length]-1)]];
		[selectVideoCategoriesCriteria appendString:@")"];
        
		[(NSMutableString*)selectVideoTitleCriteria appendFormat:@" AND Title LIKE \"%%%@%%\"",self.searchForString];
		[(NSMutableString*)selectVideoTextCriteria appendFormat:@" OR Description LIKE \"%%%@%%\"",self.searchForString];
	}
    
    NSString *selectVideo = [NSString stringWithFormat:@"%@%@%@",selectVideoCategoriesCriteria,selectVideoTitleCriteria,selectVideoTextCriteria];
    self.videosSearchResults = [SQLiteAccess selectManyRowsWithSQL:selectVideo];
    NSLog(@"selectVideo %@",selectVideo);
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)onLeftBarButton:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}


@end
