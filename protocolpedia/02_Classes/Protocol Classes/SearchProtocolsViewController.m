//
//  SearchProtocolsViewController.m
//  ProtocolPedia
//
//   7/8/10.


#import "SearchProtocolsViewController.h"
#import "SelectCategoriesViewController.h"
#import "SQLiteAccess.h"
#import "SearchResultsViewController.h"
#import "SearchTypeViewController.h"


@implementation SearchProtocolsViewController

@synthesize searchFor;
@synthesize searchForString;
@synthesize selectedProtocolCategories;
@synthesize selectedTopicsCategories;
@synthesize selectedVideosCategories;
@synthesize protocolSearchResults;
@synthesize topicsSearchResults;
@synthesize videosSearchResults;

@synthesize searchOption;
//@synthesize protocolCategoryCount;
//@synthesize topicsCategoryCount;
//@synthesize videoCategoryCount;



#pragma mark -
#pragma mark View lifecycle


-(void) loadAd {
}

- (void)revealSidebar {
	_revealBlock();
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRevealBlock:(RevealBlock)revealBlock{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _revealBlock = [revealBlock copy];
        
        float wDevice = 320;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            wDevice = 768;
        }
        else{
            wDevice = 320;
        }
        
        self.navigationController.navigationBarHidden = YES;
        viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wDevice, 50)];
        viewHeader.backgroundColor = [UIColor colorWithRed:46.0/255 green:133.0/255 blue:189.0/255 alpha:1.0];
        [self.view addSubview:viewHeader];
        
        UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, wDevice, 50)];
        lb1.textColor = [UIColor whiteColor];
        lb1.backgroundColor = [UIColor clearColor];
        lb1.font = [UIFont fontWithName:@"Arial" size:18];
        lb1.text = @"Search ProtocolPedia";
        lb1.textAlignment = UITextAlignmentCenter;
        [viewHeader addSubview:lb1];
        
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 46, 40)];
        [btnBack setImage:[UIImage imageNamed:@"icn_menu_main.png"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
        [viewHeader addSubview:btnBack];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *slideLeftImage = [UIImage imageNamed:@"btn_slide_left.png"];
    [self setLeftBarButton:slideLeftImage];
    
    
	self.dataSource = [NSArray arrayWithObjects:@"Protocols",@"Forum Topics",@"Videos",@"Search Type",@"Search",nil];
	self.searchOption = 0;
	self.searchFor.text = [applicationDelegate.settings objectForKey:@"LastSearch"];
	self.searchForString = self.searchFor.text;

}

//-(void)updateProtocolCategories:(NSMutableArray*)updatedCategories {
//	self.protocolCategories = updatedCategories;
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self getSelectedCategories];
	[self.tableView reloadData];
    
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	

	
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown);
}


-(BOOL) shouldAutorotate{
    return YES;
}

-(NSUInteger) supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
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

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
////	if (section == 1) {
////		return @" ";
////	}
//	return @" ";
//}

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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

		static NSString *CellIdentifier = @"Cell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];

	if (indexPath.section == 2) {
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            SelectCategoriesViewController *selectCategoriesViewController = [[SelectCategoriesViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
//            if (indexPath.row == 0) {
//                selectCategoriesViewController.categoryType = @"Protocol";
//            } else if (indexPath.row == 1) {
//                selectCategoriesViewController.categoryType = @"Topics";
//            } else if (indexPath.row == 2) {
//                selectCategoriesViewController.categoryType = @"Video";
//            }
//            selectCategoriesViewController.view.tag = 999;
//            selectCategoriesViewController.view.frame = CGRectMake(448, 0, 448, 1004);
//            [self.view addSubview:selectCategoriesViewController.view];
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                selectCategoriesViewController.view.frame = CGRectMake(0, 0, 448, 1004);
//            }];
//        }
//        else{
            SelectCategoriesViewController *selectCategoriesViewController = [[SelectCategoriesViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
            if (indexPath.row == 0) {
                selectCategoriesViewController.categoryType = @"Protocol";
            } else if (indexPath.row == 1) {
                selectCategoriesViewController.categoryType = @"Topics";
            } else if (indexPath.row == 2) {
                selectCategoriesViewController.categoryType = @"Video";
            }
            [[self navigationController] pushViewController:selectCategoriesViewController animated:YES];
        
//        }
			
	} else if (indexPath.section == 1) {
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            SearchTypeViewController *searchTypeViewController = [[SearchTypeViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
//            searchTypeViewController.navbarTitle = @"Search Type";
//            searchTypeViewController.title = nil;
//            searchTypeViewController.view.tag = 999;
//            searchTypeViewController.view.frame = CGRectMake(448, 0, 448, 1004);
//            [self.view addSubview:searchTypeViewController.view];
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                searchTypeViewController.view.frame = CGRectMake(0, 0, 448, 1004);
//            }];
//        }
//        else{
            SearchTypeViewController *searchTypeViewController = [[SearchTypeViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
            searchTypeViewController.navbarTitle = @"Search Type";
            searchTypeViewController.title = nil;
            [[self navigationController] pushViewController:searchTypeViewController animated:YES];
        
        //        }
		
	} else if (indexPath.section == 0) {
		[self getSearchResults];
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            SearchResultsViewController *searchResultsViewController = [[SearchResultsViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
//            searchResultsViewController.navbarTitle = @"Search Results";
//            searchResultsViewController.title = nil;
//            searchResultsViewController.protocolSearchResults = self.protocolSearchResults;
//            searchResultsViewController.topicsSearchResults = self.topicsSearchResults;
//            searchResultsViewController.videosSearchResults = self.videosSearchResults;
//            searchResultsViewController.view.tag = 999;
//            searchResultsViewController.view.frame = CGRectMake(448, 0, 448, 1004);
//            [self.view addSubview:searchResultsViewController.view];
//            [UIView animateWithDuration:0.3 animations:^{
//                searchResultsViewController.view.frame = CGRectMake(0, 0, 448, 1004);
//            }];
//        }
//        else{
            SearchResultsViewController *searchResultsViewController = [[SearchResultsViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
            searchResultsViewController.navbarTitle = @"Search Results";
            searchResultsViewController.title = nil;
            searchResultsViewController.protocolSearchResults = self.protocolSearchResults;
            searchResultsViewController.topicsSearchResults = self.topicsSearchResults;
            searchResultsViewController.videosSearchResults = self.videosSearchResults;
            [[self navigationController] pushViewController:searchResultsViewController animated:YES];
        
//        }
	}

}

-(void)closeSubView{
    if ([self.view viewWithTag:999]) {
        UIView *v = [self.view viewWithTag:999];
        [v removeFromSuperview];
        
        v = nil;
    }
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


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}





@end

