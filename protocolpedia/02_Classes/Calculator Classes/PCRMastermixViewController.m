//
//  PCRMastermixViewController.m
//  ProtocolPedia
//
//   9/3/10.


#import "PCRMastermixViewController.h"
#import "PCRMastermixCell.h"
#import "VolumeCell.h"
#import "SQLiteAccess.h"
#import "InfoViewController.h"


@implementation PCRMastermixViewController

@synthesize myValues;



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	//UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"infoIcon24.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(loadInfo:)]; 
//	self.navigationItem.rightBarButtonItem = infoButton;
//	[infoButton release];
	
	self.menuItems = [NSMutableArray arrayWithObjects:@"No. of Reactions",[NSString stringWithFormat:@"Reaction Volume (%cl)",181],
			@"PCR Buffer (X)",
			@"Separate Mg Solution",
			@"dNTPs(mM)",
			[NSString stringWithFormat:@"FWD primer (%cM)",181], 
			[NSString stringWithFormat:@"REV primer (%cM)",181],
			[NSString stringWithFormat:@"Polymerase (U/%cl)",181],
			[NSString stringWithFormat:@"Template (%cl)",181],
			[NSString stringWithFormat:@"dWater (%cl)",181],
			nil];

	NSString *path = [GlobalMethods dataFilePathofDocuments:@"PCRMastermixValues.plist"];

	NSMutableArray *myValuesTemp = [[NSMutableArray alloc] initWithContentsOfFile:path];
	self.myValues = myValuesTemp;
	
	[self calculateValues];
    
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
    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        viewHeader.frame = CGRectMake(0, 0, 448, 50);
//        lb1.frame = CGRectMake(0, 0, 448, 50);
//    }

}

-(void)viewWillAppear:(BOOL)animated{
    UIColor *myColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"Red"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"Green"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"Blue"] floatValue]/255.0) alpha:1.0];
    UIColor *myTintColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"TintRed"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"TintGreen"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"TintBlue"] floatValue]/255.0) alpha:1.0];
    self.navigationController.navigationBar.tintColor = myTintColor;
    self.view.backgroundColor = myColor;
    viewHeader.backgroundColor = myTintColor;
    self.tableViewOutlet.backgroundColor = myColor;
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

-(void) loadInfo:(id)sender {
	InfoViewController *infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
	infoViewController.navbarTitle = @"PCR Mastermix Info";
	infoViewController.title = 	nil;
	infoViewController.thisString = @"This is a test!";
	[[self navigationController] pushViewController:infoViewController animated:YES];

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
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
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
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 ) {
		return 2;
	} else if (section == 1) {
		return 8; 
	}
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		return 44;
	} else if (indexPath.section == 1) {
		return 46;
	}
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	tempLabel.frame = CGRectMake(40, 0, 280, 25);;
	
//	CGRect contentRect = self.contentView.bounds;
//	
//	CGFloat boundsX = contentRect.origin.x;
//	CGRect frame;
	

//	self.name.frame = frame;
	
	tempLabel.text = [NSString stringWithFormat:@"         stock                  final             mastermix(%cl)",181];
	tempLabel.textAlignment = UITextAlignmentLeft;
	tempLabel.font = [UIFont systemFontOfSize:14];
	tempLabel.textColor = [UIColor whiteColor];
	tempLabel.backgroundColor = [UIColor clearColor];
	if (section == 1) {
		return tempLabel;
	}
	return nil;



}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.section == 0) {
		static NSString *CellIdentifier = @"Cell1";
		VolumeCell *cell = (VolumeCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[VolumeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		cell.name.text = [self.menuItems objectAtIndex:indexPath.row];
		cell.value.text = [[self.myValues objectAtIndex:indexPath.row] objectForKey:@"Value"];
		cell.value.tag = indexPath.row;
		cell.value.delegate = self;
		
		
		return cell;
	} else if (indexPath.section == 1) {
		static NSString *CellIdentifier = @"Cell2";
		PCRMastermixCell *cell = (PCRMastermixCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[PCRMastermixCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		
		
		if (indexPath.row == 6) {
			cell.name.text = [self.menuItems objectAtIndex:indexPath.row+2];
			cell.stock.hidden = YES;
			cell.final.hidden = NO;
			cell.final.text = [[self.myValues objectAtIndex:indexPath.row+2] objectForKey:@"Final"];
			cell.final.tag = indexPath.row + 20;
			cell.final.delegate = self;
			cell.volume.hidden = YES;

			
			
		} else if (indexPath.row == 7) {
			cell.name.text = [self.menuItems objectAtIndex:indexPath.row+2];
			cell.stock.hidden = YES;
			cell.final.hidden = YES;
			cell.volume.text = [[self.myValues objectAtIndex:indexPath.row+2] objectForKey:@"Volume"];
			cell.volume.hidden = NO;
		} else {
			cell.stock.hidden = NO;
			cell.final.hidden = NO;
			cell.name.text = [self.menuItems objectAtIndex:indexPath.row+2];
			cell.stock.text = [[self.myValues objectAtIndex:indexPath.row+2] objectForKey:@"Stock"];
			cell.final.text = [[self.myValues objectAtIndex:indexPath.row+2] objectForKey:@"Final"];
			cell.volume.text = [[self.myValues objectAtIndex:indexPath.row+2] objectForKey:@"Volume"];
			cell.volume.hidden = NO;
			cell.stock.tag = indexPath.row + 10;
			cell.final.tag = indexPath.row + 20;
			cell.stock.delegate = self;
			cell.final.delegate = self;
		}
		
		return cell;
    }
    return nil;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {

	NSLog(@"textField.tag  %i",textField.tag);
	float temp = [textField.text floatValue];
	
	switch (textField.tag) {
		case 0:  // number of reactions
			[(NSMutableDictionary*)[self.myValues objectAtIndex:0] setObject:[NSString stringWithFormat:@"%.0f",temp] forKey:@"Value"];
			break;
		case 1: // reaction volume
			[(NSMutableDictionary*)[self.myValues objectAtIndex:1] setObject:[NSString stringWithFormat:@"%.0f",temp] forKey:@"Value"];			
			break;
		case 10: // PCR buffer stock
			[(NSMutableDictionary*)[self.myValues objectAtIndex:2] setObject:[NSString stringWithFormat:@"%.0f",temp] forKey:@"Stock"];	
			break;
		case 11: // Seperate Mg stock
			[(NSMutableDictionary*)[self.myValues objectAtIndex:3] setObject:[NSString stringWithFormat:@"%.0f",temp] forKey:@"Stock"];
			break;
		case 12:  // dNTPs stock
			[(NSMutableDictionary*)[self.myValues objectAtIndex:4] setObject:[NSString stringWithFormat:@"%.0f",temp] forKey:@"Stock"];
			break;
		case 13: // FWD primer stock
			[(NSMutableDictionary*)[self.myValues objectAtIndex:5] setObject:[NSString stringWithFormat:@"%.0f",temp] forKey:@"Stock"];
			break;
		case 14: // REV primer stock
			[(NSMutableDictionary*)[self.myValues objectAtIndex:6] setObject:[NSString stringWithFormat:@"%.0f",temp] forKey:@"Stock"];
			break;
		case 15: // Polymerase stock
			[(NSMutableDictionary*)[self.myValues objectAtIndex:7] setObject:[NSString stringWithFormat:@"%.1f",temp] forKey:@"Stock"];
			break;
		case 20: // PCR buffer final
			[(NSMutableDictionary*)[self.myValues objectAtIndex:2] setObject:[NSString stringWithFormat:@"%.1f",temp] forKey:@"Final"];
			break;
		case 21:  // Seperate Mg final
			[(NSMutableDictionary*)[self.myValues objectAtIndex:3] setObject:[NSString stringWithFormat:@"%.1f",temp] forKey:@"Final"];
			break;
		case 22:  // dNTPs final
			[(NSMutableDictionary*)[self.myValues objectAtIndex:4] setObject:[NSString stringWithFormat:@"%.2f",temp] forKey:@"Final"];
			break;
		case 23:  // FWD primer final
			[(NSMutableDictionary*)[self.myValues objectAtIndex:5] setObject:[NSString stringWithFormat:@"%.1f",temp] forKey:@"Final"];
			break;
		case 24:  // REV primer final
			[(NSMutableDictionary*)[self.myValues objectAtIndex:6] setObject:[NSString stringWithFormat:@"%.1f",temp] forKey:@"Final"];
			break;
		case 25:  // Polymerase final
			[(NSMutableDictionary*)[self.myValues objectAtIndex:7] setObject:[NSString stringWithFormat:@"%.2f",temp] forKey:@"Final"];
			break;
		case 26:  // template 
			[(NSMutableDictionary*)[self.myValues objectAtIndex:8] setObject:[NSString stringWithFormat:@"%.1f",temp] forKey:@"Final"];
			break;
		default:
			break;
	}
	[self calculateValues];
	[textField resignFirstResponder];
	NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
	[self.tableViewOutlet scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
	return YES;
}


-(void)calculateValues {
		
	//          myValues Array
	// 0  Number of Reactions
	// 1  Reaction Volume microliters
	// 2  PCR Buffer (X)
	// 3  Seperate MgCl2 Solution
	// 4  dNTPS(nM)
	// 5  FWD primer
	// 6  REV primar
	// 7  Polymerase
	// 8  Template
	// 9  dWater
		
		
	float A = [[[self.myValues objectAtIndex:0] objectForKey:@"Value"] floatValue]; // Number of Reactions
	float B = [[[self.myValues objectAtIndex:1] objectForKey:@"Value"] floatValue];  // Reaction Volume microliters
	NSLog(@"float A %.1f",A);
	NSLog(@"float B %.1f",B);
    float ingredientstotal = 0;
	for (int i = 2;i<8;i++) { // loops throught array item 2 through 7 and solves for volume.
		NSLog(@"i   %i",i);

		float C = [[[self.myValues objectAtIndex:i] objectForKey:@"Stock"] floatValue]; 
		float D = [[[self.myValues objectAtIndex:i] objectForKey:@"Final"] floatValue];
		float Y = D*B*A/C;
		ingredientstotal = ingredientstotal + Y;
		NSLog(@"float C %.1f",C);
		NSLog(@"float D %.1f",D);
		NSLog(@"float Y %.1f",Y);

		[(NSMutableDictionary*)[self.myValues objectAtIndex:i] setObject:[NSString stringWithFormat:@"%.1f",Y] forKey:@"Volume"];
	}
	
	float template = [[[self.myValues objectAtIndex:8] objectForKey:@"Final"] floatValue]; // finds template values
	float total = (A*B)-(ingredientstotal + (template*A));  // calculates total dWater value
	
	[(NSMutableDictionary*)[self.myValues objectAtIndex:9] setObject:[NSString stringWithFormat:@"%.1f",total] forKey:@"Volume"];  // adds total value in array
	NSLog(@"float template %.1f",template);
	NSLog(@"float total %.1f",total);

	NSString *path = [GlobalMethods dataFilePathofDocuments:@"PCRMastermixValues.plist"];  // saves the new array to the database
	BOOL ok = [self.myValues writeToFile:path atomically:YES];
	if (ok != YES) {NSLog(@"myValues did not save!");}
	
	[self.tableViewOutlet reloadData];  // adds the new data to the table
}


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
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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

