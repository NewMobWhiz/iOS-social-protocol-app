//
//  DilutionCalculatorViewController.m
//  ProtocolPedia
//
//   8/30/10.


#import "DilutionCalculatorViewController.h"
#import "DataEntryCell.h"
#import "ResultsCell.h"
#import "UnitSelectionViewController.h"

@implementation DilutionCalculatorViewController


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
	
	NSMutableDictionary *calculatorDataTemp = [[NSMutableDictionary alloc] initWithContentsOfFile:[GlobalMethods dataFilePathofDocuments:@"Dilution.plist"]];
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
	
	[self calculateValues];
	
    UIColor *myColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"Red"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"Green"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"Blue"] floatValue]/255.0) alpha:1.0];
    UIColor *myTintColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"TintRed"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"TintGreen"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"TintBlue"] floatValue]/255.0) alpha:1.0];
    self.navigationController.navigationBar.tintColor = myTintColor;
    self.view.backgroundColor = myColor;
    self.tableViewOutlet.backgroundColor = myColor;
    viewHeader.backgroundColor = myTintColor;
}


-(void) calculateValues { 
	
	
	// get unit multipliers
	
	double a = 0;
	if ([[self.calculatorData objectForKey:@"DilutionStockUnits"] isEqualToString:@"molar"]) {
		a = 1;
	} else if ([[self.calculatorData objectForKey:@"DilutionStockUnits"] isEqualToString:@"millimolar"]) {
		a = pow(10,3);
	} else if ([[self.calculatorData objectForKey:@"DilutionStockUnits"] isEqualToString:@"micromolar"]) {
		a = pow(10,6);
	} else if ([[self.calculatorData objectForKey:@"DilutionStockUnits"] isEqualToString:@"nanomolar"]) {
		a = pow(10,9);
	} else if ([[self.calculatorData objectForKey:@"DilutionStockUnits"] isEqualToString:@"picomolar"]) {	
		a = pow(10,12);
	}
	
	double b = 0;
	if ([[self.calculatorData objectForKey:@"DilutionWorkingUnits"] isEqualToString:@"molar"]) {
		b = 1;
	} else if ([[self.calculatorData objectForKey:@"DilutionWorkingUnits"] isEqualToString:@"millimolar"]) {
		b = pow(10,3);
	} else if ([[self.calculatorData objectForKey:@"DilutionWorkingUnits"] isEqualToString:@"micromolar"]) {
		b = pow(10,6);
	} else if ([[self.calculatorData objectForKey:@"DilutionWorkingUnits"] isEqualToString:@"nanomolar"]) {
		b = pow(10,9);
	} else if ([[self.calculatorData objectForKey:@"DilutionWorkingUnits"] isEqualToString:@"picomolar"]) {	
		b = pow(10,12);
	}
	
	double c = 0;
	if ([[self.calculatorData objectForKey:@"DilutionDesiredUnits"] isEqualToString:@"liters"]) {
		c = 1;
	} else if ([[self.calculatorData objectForKey:@"DilutionDesiredUnits"] isEqualToString:@"milliliters"]) {
		c = pow(10,3);
	} else if ([[self.calculatorData objectForKey:@"DilutionDesiredUnits"] isEqualToString:@"microliters"]) {
		c = pow(10,6);
	} else if ([[self.calculatorData objectForKey:@"DilutionDesiredUnits"] isEqualToString:@"nanoliters"]) {
		c = pow(10,9);
	} else if ([[self.calculatorData objectForKey:@"DilutionDesiredUnits"] isEqualToString:@"picoliters"]) {	
		c = pow(10,12);
	}
	
	double d = 0;
	if ([[self.calculatorData objectForKey:@"ResultsUnits"] isEqualToString:@"liters"]) {
		d = 1;
	} else if ([[self.calculatorData objectForKey:@"ResultsUnits"] isEqualToString:@"milliliters"]) {
		d = pow(10,3);
	} else if ([[self.calculatorData objectForKey:@"ResultsUnits"] isEqualToString:@"microliters"]) {
		d = pow(10,6);
	} else if ([[self.calculatorData objectForKey:@"ResultsUnits"] isEqualToString:@"nanoliters"]) {
		d = pow(10,9);
	} else if ([[self.calculatorData objectForKey:@"ResultsUnits"] isEqualToString:@"picoliters"]) {	
		d = pow(10,12);
	}	
	
	
	// get user data
	
	float diltuionStockValue = [[self.calculatorData objectForKey:@"DiltuionStockValue"] floatValue];
	float dilutionWorkingValue = [[self.calculatorData objectForKey:@"DilutionWorkingValue"] floatValue];
	float dilutionDesiredValue = [[self.calculatorData objectForKey:@"DilutionDesiredValue"] floatValue];	
	
	
	
	
	
	// formula
	
//	float stockSolutionToAdd = ((((dilutionWorkingValue*dilutionDesiredValue)/diltuionStockValue)/a)/b)*c*d;
	float stockSolutionToAdd = (((dilutionWorkingValue/b)*(dilutionDesiredValue/c))/(diltuionStockValue/a))*d;
		
	NSLog(@"a  %f",a);
	NSLog(@"b  %f",b);
	NSLog(@"c  %f",c);
	NSLog(@"d  %f",d);
	NSLog(@"diltuionStockValue  %f",diltuionStockValue);
	NSLog(@"dilutionWorkingValue  %f",dilutionWorkingValue);
	NSLog(@"dilutionDesiredValue  %f",dilutionDesiredValue);	
	NSLog(@"stockSolutionToAdd  %f",stockSolutionToAdd);
	
	
	self.result = [NSString stringWithFormat:@"%.3f", stockSolutionToAdd];
	
	
	
	[self.tableViewOutlet reloadData];
	
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	

	return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (textField.tag == 0) {
		textField.text = [NSString stringWithFormat:@"%.3f",[textField.text floatValue]];
		[self.calculatorData setObject:textField.text forKey:@"DiltuionStockValue"];
	} else if (textField.tag == 1) {
		textField.text = [NSString stringWithFormat:@"%.3f",[textField.text floatValue]];
		[self.calculatorData setObject:textField.text forKey:@"DilutionWorkingValue"];
	} else if (textField.tag == 2) {
		textField.text = [NSString stringWithFormat:@"%.3f",[textField.text floatValue]];
		[self.calculatorData setObject:textField.text forKey:@"DilutionDesiredValue"];
	}
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
	
	BOOL ok = [self.calculatorData writeToFile:[GlobalMethods dataFilePathofDocuments:@"Dilution.plist"] atomically:YES];
	if (ok != YES) {NSLog(@"Dilution did not save!");}
	
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
    
	if (indexPath.row == 3) {
		static NSString *CellIdentifier = @"ResultsCell";
		ResultsCell *cell = (ResultsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[ResultsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		if (!self.result) {
			self.result = @"0";
		}
		cell.resultsName.text = @"Stock Solution to Add";
		cell.resultUnits.text = [self.calculatorData objectForKey:@"ResultsUnits"];
		cell.result.text = self.result;
		return cell;	
	} else {
		static NSString *CellIdentifier = @"DataEntryCell";
		DataEntryCell *cell = (DataEntryCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[DataEntryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		cell.dataValue.tag = indexPath.row;
		cell.dataValue.delegate = self;
		if (indexPath.row == 0) {
			cell.dataName.text = @"Concentration of Stock Solution";
			cell.dataValue.text = [self.calculatorData objectForKey:@"DiltuionStockValue"];
			cell.dataUnits.text = [self.calculatorData objectForKey:@"DilutionStockUnits"];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else if (indexPath.row == 1) {
			cell.dataName.text = @"Concentration of Working Solution";
			cell.dataValue.text = [self.calculatorData objectForKey:@"DilutionWorkingValue"];
			cell.dataUnits.text = [self.calculatorData objectForKey:@"DilutionWorkingUnits"];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else if (indexPath.row == 2) {
			cell.dataName.text = @"Volume of working solution";
			cell.dataValue.text = [self.calculatorData objectForKey:@"DilutionDesiredValue"];
			cell.dataUnits.text = [self.calculatorData objectForKey:@"DilutionDesiredUnits"];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
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
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            UnitSelectionViewController *unitSelectionViewController = [[UnitSelectionViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
//            unitSelectionViewController.navbarTitle = @"Select Stock Soltuion Units";
//            unitSelectionViewController.title = nil;
//            unitSelectionViewController.menuItems = [NSArray arrayWithObjects:@"molar", @"millimolar",@"micromolar",@"nanomolar",@"picomolar",nil];
//            //  @"Extinction Coefficient",
//            unitSelectionViewController.currentSelection = [self.calculatorData objectForKey:@"DilutionStockUnits"];
//            unitSelectionViewController.keyValue = @"DilutionStockUnits";
//            unitSelectionViewController.view.frame = CGRectMake(448, 0, 448, 1004);
//            [self.view addSubview:unitSelectionViewController.view];
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                unitSelectionViewController.view.frame = CGRectMake(0, 0, 448, 1004);
//            }];
//        }
//        else{
            UnitSelectionViewController *unitSelectionViewController = [[UnitSelectionViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
            unitSelectionViewController.navbarTitle = @"Select Stock Soltuion Units";
            unitSelectionViewController.title = nil;
            unitSelectionViewController.menuItems = [NSArray arrayWithObjects:@"molar", @"millimolar",@"micromolar",@"nanomolar",@"picomolar",nil];
            //  @"Extinction Coefficient",
            unitSelectionViewController.currentSelection = [self.calculatorData objectForKey:@"DilutionStockUnits"];
            unitSelectionViewController.keyValue = @"DilutionStockUnits";
            [[self navigationController] pushViewController:unitSelectionViewController animated:YES];
        
//        }
        
			
	} else if (indexPath.row == 1) {
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            UnitSelectionViewController *unitSelectionViewController = [[UnitSelectionViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
//            unitSelectionViewController.navbarTitle = @"Select Stock Soltuion Units";
//            unitSelectionViewController.title = nil;
//            unitSelectionViewController.menuItems = [NSArray arrayWithObjects:@"molar", @"millimolar",@"micromolar",@"nanomolar",@"picomolar",nil];
//            //  @"Extinction Coefficient",
//            unitSelectionViewController.currentSelection = [self.calculatorData objectForKey:@"DilutionStockUnits"];
//            unitSelectionViewController.keyValue = @"DilutionStockUnits";
//            unitSelectionViewController.view.frame = CGRectMake(448, 0, 448, 1004);
//            [self.view addSubview:unitSelectionViewController.view];
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                unitSelectionViewController.view.frame = CGRectMake(0, 0, 448, 1004);
//            }];
//        }
//        else{
            UnitSelectionViewController *unitSelectionViewController = [[UnitSelectionViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
            unitSelectionViewController.navbarTitle = @"Select Stock Soltuion Units";
            unitSelectionViewController.title = nil;
            unitSelectionViewController.menuItems = [NSArray arrayWithObjects:@"molar", @"millimolar",@"micromolar",@"nanomolar",@"picomolar",nil];
            //  @"Extinction Coefficient",
            unitSelectionViewController.currentSelection = [self.calculatorData objectForKey:@"DilutionStockUnits"];
            unitSelectionViewController.keyValue = @"DilutionStockUnits";
            [[self navigationController] pushViewController:unitSelectionViewController animated:YES];
        
//        }	
	} else if (indexPath.row == 2) {
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            UnitSelectionViewController *unitSelectionViewController = [[UnitSelectionViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
//            unitSelectionViewController.navbarTitle = @"Select Desired Working Solution Units";
//            unitSelectionViewController.title = nil;
//            unitSelectionViewController.menuItems = [NSArray arrayWithObjects:@"liters", @"milliliters",@"microliters",@"nanoliters",@"picoliters",nil];
//            unitSelectionViewController.currentSelection = [self.calculatorData objectForKey:@"DilutionDesiredUnits"];
//            unitSelectionViewController.keyValue = @"DilutionDesiredUnits";
//            unitSelectionViewController.view.frame = CGRectMake(448, 0, 448, 1004);
//            [self.view addSubview:unitSelectionViewController.view];
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                unitSelectionViewController.view.frame = CGRectMake(0, 0, 448, 1004);
//            }];
//        }
//        else{
            UnitSelectionViewController *unitSelectionViewController = [[UnitSelectionViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
            unitSelectionViewController.navbarTitle = @"Select Desired Working Solution Units";
            unitSelectionViewController.title = nil;
            unitSelectionViewController.menuItems = [NSArray arrayWithObjects:@"liters", @"milliliters",@"microliters",@"nanoliters",@"picoliters",nil];
            unitSelectionViewController.currentSelection = [self.calculatorData objectForKey:@"DilutionDesiredUnits"];
            unitSelectionViewController.keyValue = @"DilutionDesiredUnits";
            [[self navigationController] pushViewController:unitSelectionViewController animated:YES];
        
//        }
        
			
	} else if (indexPath.row == 3) {
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            UnitSelectionViewController *unitSelectionViewController = [[UnitSelectionViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
//            unitSelectionViewController.navbarTitle = @"Solution to Add Units";
//            unitSelectionViewController.title = nil;
//            unitSelectionViewController.menuItems = [NSArray arrayWithObjects:@"liters", @"milliliters",@"microliters",@"nanoliters",@"picoliters",nil];
//            unitSelectionViewController.currentSelection = [self.calculatorData objectForKey:@"ResultsUnits"];
//            unitSelectionViewController.keyValue = @"ResultsUnits";
//            unitSelectionViewController.view.frame = CGRectMake(448, 0, 448, 1004);
//            [self.view addSubview:unitSelectionViewController.view];
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                unitSelectionViewController.view.frame = CGRectMake(0, 0, 448, 1004);
//            }];
//        }
//        else{
            UnitSelectionViewController *unitSelectionViewController = [[UnitSelectionViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
            unitSelectionViewController.navbarTitle = @"Solution to Add Units";
            unitSelectionViewController.title = nil;
            unitSelectionViewController.menuItems = [NSArray arrayWithObjects:@"liters", @"milliliters",@"microliters",@"nanoliters",@"picoliters",nil];
            unitSelectionViewController.currentSelection = [self.calculatorData objectForKey:@"ResultsUnits"];
            unitSelectionViewController.keyValue = @"ResultsUnits";
            [[self navigationController] pushViewController:unitSelectionViewController animated:YES];
        
//        }
	}
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


//
//
//
//
//@synthesize pickerView;
//@synthesize pickerViewMenu;
//@synthesize selectedPicker;
//@synthesize stockSolutionUnitsButton;
//@synthesize workingSolutionUnitsButton;
//@synthesize desiredWorkingSolutionUnitsButton;
//@synthesize pickerShowing;
//@synthesize stockSolutionField;
//@synthesize workingSolutionField;
//@synthesize desiredSolutionField;
//@synthesize stockSolutionValue;
//@synthesize workingSolutionValue;
//@synthesize desiredWorkingValue;
//
//
//- (void)dealloc {
//	[pickerView release];
//	[pickerViewMenu release];
//	[selectedPicker release];
//	[stockSolutionUnitsButton release];
//	[workingSolutionUnitsButton release];
//	[desiredWorkingSolutionUnitsButton release];
//	[stockSolutionField release];
//	[workingSolutionField release];
//	[desiredSolutionField release];
////	[stockSolutionValue release];
////	[workingSolutionValue release];
////	[desiredWorkingValue release];	
//	
//	
//    [super dealloc];
//}
//
//
//#pragma mark -
//#pragma mark View lifecycle
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//	UIPickerView *tempPickerView = [[UIPickerView alloc] init];
//	self.pickerView = tempPickerView;
//	[tempPickerView release];
//	self.pickerView.dataSource = self;
//	self.pickerView.delegate = self;
//	self.pickerView.showsSelectionIndicator = YES;
//	self.pickerShowing = NO;
//
//	[self.stockSolutionUnitsButton setTitle:[self.appDelegate.settings objectForKey:@"DilutionStockUnits"] forState:UIControlStateNormal];
//	[self.workingSolutionUnitsButton setTitle:[self.appDelegate.settings objectForKey:@"DilutionWorkingUnits"] forState:UIControlStateNormal]; 
//	[self.desiredWorkingSolutionUnitsButton setTitle:[self.appDelegate.settings objectForKey:@"DilutionDesiredUnits"] forState:UIControlStateNormal]; 
//	
//}
//
//-(IBAction) textFieldSelected {
//	NSLog(@"self.pickerShowing  %i",self.pickerShowing);
//	if (self.pickerShowing == YES) {
//		
//		[self hidePickerView];
//	}
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//	[textField resignFirstResponder];
////	if (textField.tag == 1) {
////		self.stockSolutionValue =  [[NSDecimalNumber alloc] initWithString:textField.text];
////		textField.text = [NSString stringWithFormat:@"%lf",[self.stockSolutionValue doubleValue]];
////		[self.appDelegate.settings setObject:[NSString stringWithFormat:@"%f",[self.stockSolutionValue doubleValue]] forKey:@"DilutionStockValue"];
////	} else if (textField.tag == 2) {
////		self.stockSolutionValue =  [[NSDecimalNumber alloc] initWithString:textField.text];
////		textField.text = [NSString stringWithFormat:@"%lf",[self.workingSolutionValue doubleValue]];
////		[self.appDelegate.settings setObject:[NSString stringWithFormat:@"%f",[self.workingSolutionValue doubleValue]] forKey:@"DilutionWorkingUnits"];
////	} else if (textField.tag == 3) {
////		self.stockSolutionValue =  [[NSDecimalNumber alloc] initWithString:textField.text];
////		textField.text = [NSString stringWithFormat:@"%lf",[self.workingSolutionValue doubleValue]];
////		[self.appDelegate.settings setObject:[NSString stringWithFormat:@"%f",[self.workingSolutionValue doubleValue]] forKey:@"DilutionDesiredUnits"];
////	}
//NSLog(@"textField.tag %i",textField.tag);
//NSLog(@"textField.text %@",textField.text);
//	if (textField.tag == 1) {
//		self.stockSolutionValue =  [textField.text floatValue];
//		textField.text = [NSString stringWithFormat:@"%.2f",self.stockSolutionValue];
//		[self.appDelegate.settings setObject:[NSString stringWithFormat:@"%.2f",self.stockSolutionValue] forKey:@"DilutionStockValue"];
//	} else if (textField.tag == 2) {
//		self.workingSolutionValue =  [textField.text floatValue];
//		textField.text = [NSString stringWithFormat:@"%.2f",self.workingSolutionValue];
//		[self.appDelegate.settings setObject:[NSString stringWithFormat:@"%.2f",self.workingSolutionValue] forKey:@"DilutionWorkingValue"];
//	} else if (textField.tag == 3) {
//		self.desiredWorkingValue =  [textField.text floatValue];
//		textField.text = [NSString stringWithFormat:@"%.2f",self.desiredWorkingValue];
//		[self.appDelegate.settings setObject:[NSString stringWithFormat:@"%.2f",self.workingSolutionValue] forKey:@"DilutionDesiredValue"];
//	}
//	return YES;
//}
//
//-(IBAction) resignFirstResponderForTextFields {
//	[self.stockSolutionField resignFirstResponder];
//	[self.workingSolutionField resignFirstResponder];
//	[self.desiredSolutionField resignFirstResponder];
//	[self hidePickerView];
//	
//
//}
//
///*
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//}
//*/
///*
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//}
//*/
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//	if (self.pickerShowing == YES) {
//		[self hidePickerView];
//	}
//	[self.stockSolutionField resignFirstResponder];
//	[self.workingSolutionField resignFirstResponder];
//	[self.desiredSolutionField resignFirstResponder];
////	[self.appDelegate.settings setObject:self.stockSolutionUnitsButton.titleLabel forKey:@"DilutionStockUnits"];
////	[self.appDelegate.settings setObject:self.workingSolutionUnitsButton.titleLabel forKey:@"DilutionWorkingUnits"];
////	[self.appDelegate.settings setObject:self.desiredWorkingSolutionUnitsButton.titleLabel forKey:@"DilutionDesiredUnits"];
//	
//}
//
///*
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//}
//*/
///*
//// Override to allow orientations other than the default portrait orientation.
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//*/
//
//
//#pragma mark -
//#pragma mark Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return 1;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    // Return the number of rows in the section.
//    return 1;
//}
//
//
//// Customize the appearance of table view cells.
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }
//    
//    // Configure the cell...
//    
//    return cell;
//}
//
//
///*
//// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//*/
//
//
///*
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
//    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}
//*/
//
//
///*
//// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
//}
//*/
//
//
///*
//// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the item to be re-orderable.
//    return YES;
//}
//*/
//
//
//#pragma mark -
//#pragma mark Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Navigation logic may go here. Create and push another view controller.
//	/*
//	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//	 [self.navigationController pushViewController:detailViewController animated:YES];
//	 [detailViewController release];
//	 */
//}
//
//#pragma mark -
//#pragma mark pickerView
//
//-(IBAction) stockSolutionUnits {
//	[self.stockSolutionField resignFirstResponder];
//	[self.workingSolutionField resignFirstResponder];
//	[self.desiredSolutionField resignFirstResponder];
//	if ([self.selectedPicker isEqualToString:@"stockSolutionUnits"]){
//		if (self.pickerShowing == NO) {
//			[self showPickerView];
//		} else {
//			[self hidePickerView];
//		}
//	} else {
//		self.selectedPicker = @"stockSolutionUnits";
//		[self showPickerView];
//	}
//
//}
//
//
//-(IBAction) workingSolutionUnits {
//	[self.stockSolutionField resignFirstResponder];
//	[self.workingSolutionField resignFirstResponder];
//	[self.desiredSolutionField resignFirstResponder];
//	if ([self.selectedPicker isEqualToString:@"workingSolutionUnits"]){
//		if (self.pickerShowing == NO) {
//			[self showPickerView];
//		} else {
//			[self hidePickerView];
//		}
//	} else {
//		self.selectedPicker = @"workingSolutionUnits";
//		[self showPickerView];
//	}
//	
//}
//
//
//-(IBAction) desiredWorkingSolutionUnits {
//	[self.stockSolutionField resignFirstResponder];
//	[self.workingSolutionField resignFirstResponder];
//	[self.desiredSolutionField resignFirstResponder];
//	if ([self.selectedPicker isEqualToString:@"desiredWorkingSolutionUnits"]){
//		if (self.pickerShowing == NO) {
//			[self showPickerView];
//		} else {
//			[self hidePickerView];
//		}
//	} else {
//		self.selectedPicker = @"desiredWorkingSolutionUnits";
//		[self showPickerView];
//	}
//
//}
//
//
//-(void) showPickerView {
//	//NSLog(@"%i",self.searchCriteriaSelected);
//	if ([self.selectedPicker isEqualToString:@"stockSolutionUnits"]) {
//		self.pickerViewMenu = [NSArray arrayWithObjects:@"molar", @"millimolar",@"micromolar",@"nanomolar",@"picomolar",nil]; 
//	} else if ([self.selectedPicker isEqualToString:@"workingSolutionUnits"]) {
//		self.pickerViewMenu = [NSArray arrayWithObjects:@"molar", @"millimolar",@"micromolar",@"nanomolar",@"picomolar",nil]; 
//	} else if ([self.selectedPicker isEqualToString:@"desiredWorkingSolutionUnits"]) {
//		self.pickerViewMenu = [NSArray arrayWithObjects:@"liters", @"milliliters",@"microliters",@"nanoliters",@"picoliters",nil]; 
//	}
//	[self.pickerView reloadComponent:0];
//	
//	// size up the picker view to our screen and compute the start/end frame origin for our slide up animation
//	//
//	// compute the start frame
//	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
//	CGSize pickerSize = [self.pickerView sizeThatFits:CGSizeZero];
//	CGRect startRect = CGRectMake(0.0,screenRect.origin.y + screenRect.size.height ,pickerSize.width, pickerSize.height);
//	self.pickerView.frame = startRect;
//	
//	// add pickerview to view
//	[self.view.window addSubview:self.pickerView];
//	
//	// compute the end frame
//	CGRect pickerRect = CGRectMake(0.0,screenRect.origin.y + screenRect.size.height - pickerSize.height,pickerSize.width, pickerSize.height);
//	// start the slide up animation
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.3];
//	[UIView setAnimationDelegate:self];
//	self.pickerView.frame = pickerRect;
//	[UIView commitAnimations];
//	self.pickerShowing = YES;
//	
//	
//}
//
//-(void) hidePickerView {
//	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
//	CGSize pickerSize = [self.pickerView sizeThatFits:CGSizeZero];
//	CGRect endRect = CGRectMake(0.0,screenRect.origin.y + screenRect.size.height,pickerSize.width, pickerSize.height);
//	
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.3];
//	[UIView setAnimationDelegate:self];
//	[UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
//	self.pickerView.frame = endRect;
//	[UIView commitAnimations];
//	self.pickerShowing = NO;
//	
//}
//
//
//-(void) slideDownDidStop{
////	[self showPickerView];
//}
//
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//	// Return Value - The string to use as the title of the indicated component row.
//	return [self.pickerViewMenu objectAtIndex:row];
//	
//	
//}
//
////- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
////	// Return Value - A view object to use as the content of row. The object can be any subclass of UIView, such as UILabel, UIImageView, or even a custom view.
////	
////}
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//	if ([self.selectedPicker isEqualToString:@"stockSolutionUnits"]) {
//		[self.stockSolutionUnitsButton setTitle:[self.pickerViewMenu objectAtIndex:row] forState:UIControlStateNormal];
//	} else if ([self.selectedPicker isEqualToString:@"workingSolutionUnits"]) {
//		[self.workingSolutionUnitsButton setTitle:[self.pickerViewMenu objectAtIndex:row] forState:UIControlStateNormal]; 
//	} else if ([self.selectedPicker isEqualToString:@"desiredWorkingSolutionUnits"]) {
//		[self.desiredWorkingSolutionUnitsButton setTitle:[self.pickerViewMenu objectAtIndex:row] forState:UIControlStateNormal]; 
//	}
//
//}
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//	return 1;
//}
//
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//	return [self.pickerViewMenu count];
//}
//
//
//
//#pragma mark -
//#pragma mark Memory management
//
//- (void)didReceiveMemoryWarning {
//    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
//    
//    // Relinquish ownership any cached data, images, etc that aren't in use.
//}
//
//- (void)viewDidUnload {
//    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
//    // For example: self.myOutlet = nil;
//}
//
//



@end

