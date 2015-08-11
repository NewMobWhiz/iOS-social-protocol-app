//
//  SelectCategoriesViewController.m
//  ProtocolPedia
//
//   7/9/10.


#import "SelectCategoriesViewController.h"
#import "SQLiteAccess.h"
#import <QuartzCore/QuartzCore.h>

@implementation SelectCategoriesViewController


//@synthesize protocolCategories;
@synthesize setClear;
@synthesize categoryType;
//@synthesize categoryTable;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.setClear = YES;
	
	self.navbarTitle = [NSString stringWithFormat:@"%@",self.categoryType];
	self.navigationItem.title = nil;
	
	// set rightBarItem button for this view
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Set/Clear All" style:UIBarButtonItemStyleBordered target:self action:@selector(setAll)];
	self.navigationItem.rightBarButtonItem = rightBarItem;
	
    if ([self.categoryType isEqualToString:@"Video"]) {
		self.menuItems = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT CategoryId, CategoryType, Name, Selected FROM Categories WHERE CategoryType = \"%@\" ORDER BY Name" ,self.categoryType]];
	} else if ([self.categoryType isEqualToString:@"Topics"]) {
		self.menuItems = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT CategoryId, CategoryType, Name, Selected FROM Categories WHERE CategoryType = \"%@\" AND ParentID = \"1\" ORDER BY Name",self.categoryType]];
	} else if ([self.categoryType isEqualToString:@"Protocol"]) {
		self.menuItems = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT CategoryId, CategoryType, Name, Selected FROM Categories WHERE CategoryType = \"%@\" AND CategoryId <> \"1\" ORDER BY Name",self.categoryType]];	
	}
//	NSLog(@"self.menuItems %@",self.menuItems);

	

    self.navigationController.navigationBarHidden = YES;
    
    float wDevice = 320;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        wDevice = 768;
    }
    else{
        wDevice = 320;
    }
    
    viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wDevice, 50)];
    viewHeader.backgroundColor = [UIColor colorWithRed:46.0/255 green:133.0/255 blue:189.0/255 alpha:1.0];
    [self.view addSubview:viewHeader];
    
    UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, wDevice, 50)];
    lb1.textColor = [UIColor whiteColor];
    lb1.backgroundColor = [UIColor clearColor];
    lb1.font = [UIFont fontWithName:@"Arial" size:18];
    lb1.text = navbarTitle;
    lb1.textAlignment = UITextAlignmentCenter;
    [viewHeader addSubview:lb1];
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 46, 40)];
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        [btnBack setImage:[UIImage imageNamed:@"imv_back.png"] forState:UIControlStateNormal];
//    }
//    else{
        [btnBack setImage:[UIImage imageNamed:@"icn_menu_main.png"] forState:UIControlStateNormal];
//    }
    [btnBack addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnBack];
    
    UIButton *btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(wDevice - 100, 10, 90, 30)];
    [btnSelect setTitle:@"Set/Clear All" forState:UIControlStateNormal];
    btnSelect.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
    [btnSelect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSelect addTarget:self action:@selector(setAll) forControlEvents:UIControlEventTouchUpInside];
    btnSelect.layer.borderWidth = 1;
    btnSelect.layer.borderColor = [UIColor whiteColor].CGColor;
    btnSelect.layer.cornerRadius = 4;
    [viewHeader addSubview:btnSelect];
    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        viewHeader.frame = CGRectMake(0, 0, 448, 50);
//        lb1.frame = CGRectMake(0, 0, 448, 50);
//        btnSelect.frame = CGRectMake(448 - 100, 10, 90, 30);
//    }
}

-(void)revealSidebar{
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        [UIView animateWithDuration:0.3 animations:^{
//            self.view.frame = CGRectMake(448, 0, 448, 1004);
//        } completion:^(BOOL finished) {
//            [self.view removeFromSuperview];
//            [self release];
//        }];
//        return;
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    UIColor *myColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"Red"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"Green"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"Blue"] floatValue]/255.0) alpha:1.0];
    UIColor *myTintColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"TintRed"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"TintGreen"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"TintBlue"] floatValue]/255.0) alpha:1.0];
    viewHeader.backgroundColor = myTintColor;
    self.view.backgroundColor = myColor;
    self.tableViewOutlet.backgroundColor = myColor;
}

-(void)setAll {
	if (self.setClear == YES) {
		self.setClear = NO;
		[SQLiteAccess updateWithSQL:[NSString stringWithFormat:@"UPDATE Categories SET Selected = \"Yes\" WHERE CategoryType = \"%@\"",self.categoryType]];
	} else {
		self.setClear = YES;
		[SQLiteAccess updateWithSQL:[NSString stringWithFormat:@"UPDATE Categories SET Selected = \"No\" WHERE CategoryType = \"%@\"",self.categoryType]];
	}
	if ([self.categoryType isEqualToString:@"Video"]) {
		self.menuItems = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT CategoryId, CategoryType, Name, Selected FROM Categories WHERE CategoryType = \"%@\" ORDER BY Name" ,self.categoryType]];
	} else if ([self.categoryType isEqualToString:@"Topics"]) {
		self.menuItems = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT CategoryId, CategoryType, Name, Selected FROM Categories WHERE CategoryType = \"%@\" AND ParentID = \"1\" ORDER BY Name",self.categoryType]];
	} else if ([self.categoryType isEqualToString:@"Protocol"]) {
		self.menuItems = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT CategoryId, CategoryType, Name, Selected FROM Categories WHERE CategoryType = \"%@\" AND CategoryId <> \"1\" ORDER BY Name",self.categoryType]];	
	}
	[self.tableViewOutlet reloadData];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//	
//	NSString *categoriesfilepath = [GlobalMethods dataFilePathofDocuments:@"ProtocolCategories.plist"];
//	BOOL ok = [self.menuItems writeToFile:categoriesfilepath atomically:YES];
//	if (ok != YES) {NSLog(@"protocolCategories did not save!");}
//}

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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.menuItems count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Name"];
	cell.accessoryType = UITableViewCellAccessoryNone;
	//NSLog(@"[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@\"Selected\"]  %@",[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Selected"]);

	if ([[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Selected"] isEqualToString:@"Yes"]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
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
	if ([[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Selected"] isEqualToString:@"Yes"]) {
		NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.menuItems];
		NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:[self.menuItems objectAtIndex:indexPath.row]];
		[tempDict setValue:@"No" forKey:@"Selected"];
		[tempArray replaceObjectAtIndex:indexPath.row withObject:tempDict];
		self.menuItems = tempArray;
		[SQLiteAccess updateWithSQL:[NSString stringWithFormat:@"UPDATE Categories SET Selected = \"No\" WHERE CategoryId = \"%@\"",[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"CategoryId"]]];
	} else {
		NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.menuItems];
		NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:[self.menuItems objectAtIndex:indexPath.row]];
		[tempDict setValue:@"Yes" forKey:@"Selected"];
		[tempArray replaceObjectAtIndex:indexPath.row withObject:tempDict];
		self.menuItems = tempArray;
		[SQLiteAccess updateWithSQL:[NSString stringWithFormat:@"UPDATE Categories SET Selected = \"Yes\" WHERE CategoryId = \"%@\"",[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"CategoryId"]]];
	}
	[tableView reloadData];
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

