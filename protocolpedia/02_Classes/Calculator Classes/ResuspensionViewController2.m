//
//  ResuspensionViewController2.m
//  ProtocolPedia
//
//   9/5/10.


#import "ResuspensionViewController2.h"
#import "DataEntryCell.h"
#import "ResultsCell.h"
#import "UnitSelectionViewController.h"


@implementation ResuspensionViewController2

@synthesize result;
@synthesize calculatorData;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSMutableDictionary *calculatorDataTemp = [[NSMutableDictionary alloc] initWithContentsOfFile:[GlobalMethods dataFilePathofDocuments:@"Resuspension.plist"]];
	self.calculatorData = calculatorDataTemp;
	
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
						
	if ([[self.calculatorData objectForKey:@"ResuspensionQtyUnits"] isEqualToString:@"nmole"]) {
		[self.calculatorData setObject:@"Not Needed" forKey:@"ResuspensionMolecularWeightNote"];
	}	else {
		[self.calculatorData setObject:@"" forKey:@"ResuspensionMolecularWeightNote"];
	}
	[self calculateValues];
    
    UIColor *myColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"Red"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"Green"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"Blue"] floatValue]/255.0) alpha:1.0];
    UIColor *myTintColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"TintRed"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"TintGreen"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"TintBlue"] floatValue]/255.0) alpha:1.0];
    viewHeader.backgroundColor = myTintColor;
    self.view.backgroundColor = myColor;
    self.tableViewOutlet.backgroundColor = myColor;
}


-(void) calculateValues { 

	
	if ([[self.calculatorData objectForKey:@"ResuspensionQtyUnits"] isEqualToString:@"nmole"]) {  //  do nmole formula
		float A = 10*[[self.calculatorData objectForKey:@"ResuspensionQtyValue"] floatValue];  // multiply Qty by 10
		self.result = [NSString stringWithFormat:@"%.3f",A]; // add to result with 3 decimal places

	} else {  // do OD260 formula
		// find T multiplier depeding on Type selection
		float T = 0;
		if ([[self.calculatorData objectForKey:@"ResuspensionType"] isEqualToString:[NSString stringWithFormat:@"Single-Stranded DNA, 33%cg/OD260",181]]) {
			T = 0.33;
		} else if ([[self.calculatorData objectForKey:@"ResuspensionType"] isEqualToString:[NSString stringWithFormat:@"Double-Stranded DNA, 50%cg/OD260",181]]) {
			T = 0.50;
		} else if ([[self.calculatorData objectForKey:@"ResuspensionType"] isEqualToString:[NSString stringWithFormat:@"Single-Stranded RNA, 40%cg/OD260",181]]) {
			T = 0.40;
		}
		
		// get Qty and Molecular Wt values
		float M = [[self.calculatorData objectForKey:@"ResuspensionMolecularWeight"] floatValue];
		float Q = [[self.calculatorData objectForKey:@"ResuspensionQtyValue"] floatValue];
		
		float R = 0;
		if (M != 0) {
			R = ((Q*T)/M)*pow(10,6);
		}
		
		// print out data in log for debugging
		NSLog(@"pow(10,6)  %f",pow(10,6));
		NSLog(@"T %f",T);
		NSLog(@"M %f",M);
		NSLog(@"Q %f",Q);
		NSLog(@"R %f",R);
		
		
		self.result = [NSString stringWithFormat:@"%.3f", R]; 
	}
	
		// print out data in log for debugging
		NSLog(@"self.result %@",self.result);

	
	[self.tableViewOutlet reloadData];

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];


	return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (textField.tag == 1) {
		textField.text = [NSString stringWithFormat:@"%.3f",[textField.text floatValue]];
		[self.calculatorData setObject:textField.text forKey:@"ResuspensionQtyValue"];
	} else if (textField.tag == 2) {
		textField.text = [NSString stringWithFormat:@"%.2f",[textField.text floatValue]];
		[self.calculatorData setObject:textField.text forKey:@"ResuspensionMolecularWeight"];
	} //else if (textField.tag == 3) {
	//		textField.text = [NSString stringWithFormat:@"%.0f",[textField.text floatValue]];
	//		[self.calculatorData setObject:textField.text forKey:@"ResuspensionFinalValue"];
	//	}
	[self calculateValues];

}
//-(void) resignFirstResponderForTextFields {
//	[self.stockSolutionField resignFirstResponder];
//	[self.workingSolutionField resignFirstResponder];
//	[self.desiredSolutionField resignFirstResponder];
//
//}


/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
	BOOL ok = [self.calculatorData writeToFile:[GlobalMethods dataFilePathofDocuments:@"Resuspension.plist"] atomically:YES];
	if (ok != YES) {NSLog(@"calculatorData did not save!");}
	
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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if ((indexPath.row == 1) || (indexPath.row == 2)) {
		static NSString *CellIdentifier = @"Cell1";
		DataEntryCell *cell = (DataEntryCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[DataEntryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		cell.dataValue.tag = indexPath.row;
		cell.dataValue.delegate = self;
		if (indexPath.row == 1) {
			cell.dataName.text = @"Quantity";
			cell.dataValue.text = [self.calculatorData objectForKey:@"ResuspensionQtyValue"];
			cell.dataUnits.text = [self.calculatorData objectForKey:@"ResuspensionQtyUnits"];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else if (indexPath.row == 2) {
			cell.dataName.text = @"Molecular Weight";
			cell.dataValue.text = [self.calculatorData objectForKey:@"ResuspensionMolecularWeight"];
			cell.dataUnits.text = [self.calculatorData objectForKey:@"ResuspensionMolecularWeightNote"];
		} //else if (indexPath.row == 3) {
//			cell.dataName.text = @"Final Concentration";
//			cell.dataValue.text = [self.calculatorData objectForKey:@"ResuspensionFinalValue"];
//			cell.dataUnits.text = [self.calculatorData objectForKey:@"ResuspensionFinalUnits"];
//			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//		}
		return cell;
		
		
	} else if (indexPath.row == 3) {
		static NSString *CellIdentifier = @"Cell2";
		ResultsCell *cell = (ResultsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[ResultsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
		}
		
		cell.resultsName.text = [NSString stringWithFormat:@"Resuspend Volume (100%cM concentration)",181];
		cell.resultUnits.text = @"microliters";//[NSString stringWithFormat:@"%cl",181];
		cell.result.text = self.result;

		return cell;	
	
	
	} else if (indexPath.row == 0) {
	
		static NSString *CellIdentifier = @"Cell3";

		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.text = @"Type";
		cell.detailTextLabel.text = [self.calculatorData objectForKey:@"ResuspensionType"];
		return cell;
	}
	return nil;
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
	if (indexPath.row == 0) {
		UnitSelectionViewController *unitSelectionViewController = [[UnitSelectionViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
		unitSelectionViewController.navbarTitle = @"Select Type";
		unitSelectionViewController.title = nil;
		unitSelectionViewController.menuItems = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Single-Stranded DNA, 33%cg/OD260",181],[NSString stringWithFormat:@"Double-Stranded DNA, 50%cg/OD260",181],[NSString stringWithFormat:@"Single-Stranded RNA, 40%cg/OD260",181],nil]; 
			//  @"Extinction Coefficient", 
		unitSelectionViewController.currentSelection = [appDelegate.settings objectForKey:@"ResuspensionType"];
		unitSelectionViewController.keyValue = @"ResuspensionType";
		[[self navigationController] pushViewController:unitSelectionViewController animated:YES];
			
	} else if (indexPath.row == 1) {
		UnitSelectionViewController *unitSelectionViewController = [[UnitSelectionViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
		unitSelectionViewController.navbarTitle = @"Select Qty Units";
		unitSelectionViewController.title = nil;
		unitSelectionViewController.menuItems = [NSArray arrayWithObjects:@"OD260", @"nmole",nil]; ; 
		unitSelectionViewController.currentSelection = [self.calculatorData objectForKey:@"ResuspensionQtyUnits"];
		unitSelectionViewController.keyValue = @"ResuspensionQtyUnits";
		[[self navigationController] pushViewController:unitSelectionViewController animated:YES];
		
	} //else if (indexPath.row == 3) {
//		UnitSelectionViewController *unitSelectionViewController = [[UnitSelectionViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
//		unitSelectionViewController.title = @"Select Final Concentration Units";
//		unitSelectionViewController.menuItems = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%cM (%cmole/l or pmole/%cl)",181,181,181], 
//														[NSString stringWithFormat:@"ng/%cl (%cg/ml or mg/l)",181,181],
//														[NSString stringWithFormat:@"%cg/%cl (mg/ml or g/l)",181,181],
//														[NSString stringWithFormat:@"OD260/%cl",181],
//														@"OD260/ml",
//														nil]; 
//		unitSelectionViewController.currentSelection = [self.calculatorData objectForKey:@"ResuspensionFinalUnits"];
//		unitSelectionViewController.keyValue = @"ResuspensionFinalUnits";
//		[[self navigationController] pushViewController:unitSelectionViewController animated:YES];
//		[unitSelectionViewController release];	
//	}
}


-(void) updateSelectionFor:(NSString*)key with:(NSString*)value  {
	[self.calculatorData setObject:value forKey:key];

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

