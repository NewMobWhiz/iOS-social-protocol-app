//
//  MolarityViewController.m
//  ProtocolPedia
//
//   9/4/10.


#import "MolarityViewController.h"
#import "DataEntryCell.h"
#import "ResultsCell.h"
#import "UnitSelectionViewController.h"

@implementation MolarityViewController

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
	
	NSMutableDictionary *calculatorDataTemp = [[NSMutableDictionary alloc] initWithContentsOfFile:[GlobalMethods dataFilePathofDocuments:@"Molarity.plist"]];
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
    
    UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, wDevice, 50)] ;
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
    viewHeader.backgroundColor = myTintColor;
    self.tableViewOutlet.backgroundColor = myColor;
}


-(void) calculateValues { 
	
	
	
	// get unit multipliers
	
	double a = 0;
	NSLog(@"[self.calculatorData objectForKey:@\"MolarityDesiredMolarUnits\"] %@",[self.calculatorData objectForKey:@"MolarityDesiredMolarUnits"]);
	if ([[self.calculatorData objectForKey:@"MolarityDesiredMolarUnits"] isEqualToString:@"molar"]) {
		a = 1;
	} else if ([[self.calculatorData objectForKey:@"MolarityDesiredMolarUnits"] isEqualToString:@"millimolar"]) {
		a = pow(10,3);
	} else if ([[self.calculatorData objectForKey:@"MolarityDesiredMolarUnits"] isEqualToString:@"micromolar"]) {
		a = pow(10,6);
	} else if ([[self.calculatorData objectForKey:@"MolarityDesiredMolarUnits"] isEqualToString:@"nanomolar"]) {
		a = pow(10,9);
	} else if ([[self.calculatorData objectForKey:@"MolarityDesiredMolarUnits"] isEqualToString:@"picomolar"]) {	
		a = pow(10,12);
	}

	double b = 0;
	NSLog(@"[self.calculatorData objectForKey:@\"MolarityFinalVolumeUnits\"] %@",[self.calculatorData objectForKey:@"MolarityFinalVolumeUnits"]);

	if ([[self.calculatorData objectForKey:@"MolarityFinalVolumeUnits"] isEqualToString:@"liters"]) {
		b = 1;
	} else if ([[self.calculatorData objectForKey:@"MolarityFinalVolumeUnits"] isEqualToString:@"milliliters"]) {
		b = pow(10,3);
	} else if ([[self.calculatorData objectForKey:@"MolarityFinalVolumeUnits"] isEqualToString:@"microliters"]) {
		b = pow(10,6);
	} else if ([[self.calculatorData objectForKey:@"MolarityFinalVolumeUnits"] isEqualToString:@"nanoliters"]) {
		b = pow(10,9);
	} else if ([[self.calculatorData objectForKey:@"MolarityFinalVolumeUnits"] isEqualToString:@"picoliters"]) {	
		b = pow(10,12);
	}

	double c = 0;
	NSLog(@"[self.calculatorData objectForKey:@\"UnitsOfSolutionToAdd\"] %@",[self.calculatorData objectForKey:@"UnitsOfSolutionToAdd"]);
	if ([[self.calculatorData objectForKey:@"UnitsOfSolutionToAdd"] isEqualToString:@"liters"]) {
		c = 1;
	} else if ([[self.calculatorData objectForKey:@"UnitsOfSolutionToAdd"] isEqualToString:@"milliliters"]) {
		c = pow(10,3);
	} else if ([[self.calculatorData objectForKey:@"UnitsOfSolutionToAdd"] isEqualToString:@"microliters"]) {
		c = pow(10,6);
	} else if ([[self.calculatorData objectForKey:@"UnitsOfSolutionToAdd"] isEqualToString:@"nanoliters"]) {
		c = pow(10,9);
	} else if ([[self.calculatorData objectForKey:@"UnitsOfSolutionToAdd"] isEqualToString:@"picoliters"]) {	
		c = pow(10,12);
	}




	// get user data
	
	float molecularWeight = [[self.calculatorData objectForKey:@"MolarityMolecularWeightValue"] floatValue];
	float molarSolution = [[self.calculatorData objectForKey:@"MolarityDesiredMolarValue"] floatValue];
	float finalVolume = [[self.calculatorData objectForKey:@"MolarityFinalVolumeValue"] floatValue];	
	
	

	
	
	// formula
	
	float volumeToAdd = ((molecularWeight/a)*(molarSolution/b)*(finalVolume/c));
	
	NSLog(@"a  %f",a);
	NSLog(@"b  %f",b);
	NSLog(@"c  %f",c);
	NSLog(@"molecularWeight  %f",molecularWeight);
	NSLog(@"molarSolution  %f",molarSolution);
	NSLog(@"finalVolume  %f",finalVolume);	
	NSLog(@"volumeToAdd  %f",volumeToAdd);
	
	
	self.result = [NSString stringWithFormat:@"%.3f", volumeToAdd];
	
	
	
							
	//	if ([[self.calculatorData objectForKey:@"ResuspensionQtyUnits"] isEqualToString:@"nmole"]) {
	//		float A = 10*[[self.calculatorData objectForKey:@"ResuspensionQtyValue"] floatValue];
	//		NSLog(@"[self.appDelegate.settings objectForKey:@\"ResuspensionQtyValue\"] %@",[self.calculatorData objectForKey:@"ResuspensionQtyValue"]);
	//		NSLog(@"A %f",A);
	//		
	//		self.result = [NSString stringWithFormat:@"%.2f",A];
	//		
	//	} else {
	//		float T = 0;
	//		if ([[self.calculatorData objectForKey:@"ResuspensionType"] isEqualToString:[NSString stringWithFormat:@"Single-Stranded DNA, 33%cg/OD260",181]]) {
	//			T = 0.33;
	//		} else if ([[self.calculatorData objectForKey:@"ResuspensionType"] isEqualToString:[NSString stringWithFormat:@"Double-Stranded DNA, 50%cg/OD260",181]]) {
	//			T = 0.50;
	//		} else if ([[self.calculatorData objectForKey:@"ResuspensionType"] isEqualToString:[NSString stringWithFormat:@"Single-Stranded RNA, 40%cg/OD260",181]]) {
	//			T = 0.40;
	//		}
	//		float M = [[self.calculatorData objectForKey:@"ResuspensionMolecularWeight"] floatValue];
	//		float Q = [[self.calculatorData objectForKey:@"ResuspensionQtyValue"] floatValue];
	//		
	//		float R = 0;
	//		if (M != 0) {
	//			R = ((Q*T)/M)*pow(10,7);
	//		}
	//		NSLog(@"pow(10,7)  %f",pow(10,7));
	//		
	//		NSLog(@"33 %@",[NSString stringWithFormat:@"Single-Stranded DNA, 33%cg/OD260",181]);
	//		NSLog(@"app 33 %@",[self.calculatorData objectForKey:@"ResuspensionType"]);
	//		NSLog(@"T %f",T);
	//		NSLog(@"M %f",M);
	//		NSLog(@"Q %f",Q);
	//		NSLog(@"R %f",R);
	//		
	//		
	//		self.result = [NSString stringWithFormat:@"%.1f", R]; 
	//	}
	//	NSLog(@"self.result %@",self.result);
	
	
	[self.tableViewOutlet reloadData];
	
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	
//	if (textField.tag == 0) {
//		textField.text = [NSString stringWithFormat:@"%.3f",[textField.text floatValue]];
//		[self.calculatorData setObject:textField.text forKey:@"MolarityMolecularWeightValue"];
//	} else if (textField.tag == 1) {
//		textField.text = [NSString stringWithFormat:@"%.3f",[textField.text floatValue]];
//		[self.calculatorData setObject:textField.text forKey:@"MolarityDesiredMolarValue"];
//	} else if (textField.tag == 2) {
//		textField.text = [NSString stringWithFormat:@"%.3f",[textField.text floatValue]];
//		[self.calculatorData setObject:textField.text forKey:@"MolarityFinalVolumeValue"];
//	}
//	[self calculateValues];
	return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	if (textField.tag == 0) {
		textField.text = [NSString stringWithFormat:@"%.3f",[textField.text floatValue]];
		[self.calculatorData setObject:textField.text forKey:@"MolarityMolecularWeightValue"];
	} else if (textField.tag == 1) {
		textField.text = [NSString stringWithFormat:@"%.3f",[textField.text floatValue]];
		[self.calculatorData setObject:textField.text forKey:@"MolarityDesiredMolarValue"];
	} else if (textField.tag == 2) {
		textField.text = [NSString stringWithFormat:@"%.3f",[textField.text floatValue]];
		[self.calculatorData setObject:textField.text forKey:@"MolarityFinalVolumeValue"];
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
	
	BOOL ok = [self.calculatorData writeToFile:[GlobalMethods dataFilePathofDocuments:@"Molarity.plist"] atomically:YES];
	if (ok != YES) {NSLog(@"Molarity did not save!");}
	
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
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		if (!self.result) {
			self.result = @"0";
		}
		cell.resultsName.text = @"Volume of Solution to Add:";
		cell.resultUnits.text = @"grams"; //[self.calculatorData objectForKey:@"UnitsOfSolutionToAdd"];
		cell.result.text = self.result;
//		NSLog(@"cell.dataUnits.text  %@",cell.resultUnits.text);
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
			cell.dataName.text = @"Molecular Weight";
			cell.dataValue.text = [self.calculatorData objectForKey:@"MolarityMolecularWeightValue"];
			cell.dataUnits.text = @"grams/mole";
			cell.accessoryType = UITableViewCellAccessoryNone;
		} else if (indexPath.row == 1) {
			cell.dataName.text = @"Desired Molar Solution";
			cell.dataValue.text = [self.calculatorData objectForKey:@"MolarityDesiredMolarValue"];
			cell.dataUnits.text = [self.calculatorData objectForKey:@"MolarityDesiredMolarUnits"];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else if (indexPath.row == 2) {
			cell.dataName.text = @"Desired Final Volume";
			cell.dataValue.text = [self.calculatorData objectForKey:@"MolarityFinalVolumeValue"];
			cell.dataUnits.text = [self.calculatorData objectForKey:@"MolarityFinalVolumeUnits"];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
//		NSLog(@"cell.dataUnits.text  %@",cell.dataUnits.text);

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

//	NSLog(@"self.calculatorData %@",self.calculatorData);

	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	if (indexPath.row == 0) {
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            UnitSelectionViewController *unitSelectionViewController = [[UnitSelectionViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
//            unitSelectionViewController.navbarTitle = @"Select Stock Soltuion Units";
//            unitSelectionViewController.title = nil;
//            unitSelectionViewController.menuItems = [NSArray arrayWithObjects:@"molar", @"millimolar",@"micromolar",@"nanomolar",@"picomolar",nil];
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
            unitSelectionViewController.currentSelection = [self.calculatorData objectForKey:@"DilutionStockUnits"];
            unitSelectionViewController.keyValue = @"DilutionStockUnits";
            [[self navigationController] pushViewController:unitSelectionViewController animated:YES];
        
//        }
		
	} else if (indexPath.row == 1) {
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            UnitSelectionViewController *unitSelectionViewController = [[UnitSelectionViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
//            unitSelectionViewController.navbarTitle = @"Select Working Solution Units";
//            unitSelectionViewController.title = nil;
//            unitSelectionViewController.menuItems = [NSArray arrayWithObjects:@"molar", @"millimolar",@"micromolar",@"nanomolar",@"picomolar",nil];
//            unitSelectionViewController.currentSelection = [self.calculatorData objectForKey:@"MolarityDesiredMolarUnits"];
//            unitSelectionViewController.keyValue = @"MolarityDesiredMolarUnits";
//            unitSelectionViewController.view.frame = CGRectMake(448, 0, 448, 1004);
//            [self.view addSubview:unitSelectionViewController.view];
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                unitSelectionViewController.view.frame = CGRectMake(0, 0, 448, 1004);
//            }];
//        }
//        else{
            UnitSelectionViewController *unitSelectionViewController = [[UnitSelectionViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
            unitSelectionViewController.navbarTitle = @"Select Working Solution Units";
            unitSelectionViewController.title = nil;
            unitSelectionViewController.menuItems = [NSArray arrayWithObjects:@"molar", @"millimolar",@"micromolar",@"nanomolar",@"picomolar",nil];
            unitSelectionViewController.currentSelection = [self.calculatorData objectForKey:@"MolarityDesiredMolarUnits"];
            unitSelectionViewController.keyValue = @"MolarityDesiredMolarUnits";
            [[self navigationController] pushViewController:unitSelectionViewController animated:YES];
        
//        }
			
	} else if (indexPath.row == 2) {
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            UnitSelectionViewController *unitSelectionViewController = [[UnitSelectionViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
//            unitSelectionViewController.navbarTitle = @"Select Desired Working Solution Units";
//            unitSelectionViewController.title = nil;
//            unitSelectionViewController.menuItems = [NSArray arrayWithObjects:@"liters", @"milliliters",@"microliters",@"nanoliters",@"picoliters",nil];
//            unitSelectionViewController.currentSelection = [self.calculatorData objectForKey:@"MolarityFinalVolumeUnits"];
//            unitSelectionViewController.keyValue = @"MolarityFinalVolumeUnits";
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
            unitSelectionViewController.currentSelection = [self.calculatorData objectForKey:@"MolarityFinalVolumeUnits"];
            unitSelectionViewController.keyValue = @"MolarityFinalVolumeUnits";
            [[self navigationController] pushViewController:unitSelectionViewController animated:YES];
           
//        }
	}
}


-(void) updateSelectionFor:(NSString*)key with:(NSString*)value  {
NSLog(@"self.calculatorData %@",self.calculatorData);

	[self.calculatorData setObject:value forKey:key];
NSLog(@"self.calculatorData after %@",self.calculatorData);

	
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
//@implementation MolarityViewController
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
//	//	[stockSolutionValue release];
//	//	[workingSolutionValue release];
//	//	[desiredWorkingValue release];	
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
//	self.stockSolutionUnitsButton.hidden = YES;
//	
////	DilutionStockValue = MolecularMolecularWeightValue;
////	DilutionWorkingUnits = MolarityDesiredMolarUnits;
//	
////	[self.stockSolutionUnitsButton setTitle:[self.appDelegate.settings objectForKey:@"DilutionStockUnits"] forState:UIControlStateNormal];
//	[self.workingSolutionUnitsButton setTitle:[self.appDelegate.settings objectForKey:@"MolarityDesiredMolarUnits"] forState:UIControlStateNormal]; 
//	[self.desiredWorkingSolutionUnitsButton setTitle:[self.appDelegate.settings objectForKey:@"MolarityFinalVolumeUnits"] forState:UIControlStateNormal]; 
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
//	//	if (textField.tag == 1) {
//	//		self.stockSolutionValue =  [[NSDecimalNumber alloc] initWithString:textField.text];
//	//		textField.text = [NSString stringWithFormat:@"%lf",[self.stockSolutionValue doubleValue]];
//	//		[self.appDelegate.settings setObject:[NSString stringWithFormat:@"%f",[self.stockSolutionValue doubleValue]] forKey:@"DilutionStockValue"];
//	//	} else if (textField.tag == 2) {
//	//		self.stockSolutionValue =  [[NSDecimalNumber alloc] initWithString:textField.text];
//	//		textField.text = [NSString stringWithFormat:@"%lf",[self.workingSolutionValue doubleValue]];
//	//		[self.appDelegate.settings setObject:[NSString stringWithFormat:@"%f",[self.workingSolutionValue doubleValue]] forKey:@"DilutionWorkingUnits"];
//	//	} else if (textField.tag == 3) {
//	//		self.stockSolutionValue =  [[NSDecimalNumber alloc] initWithString:textField.text];
//	//		textField.text = [NSString stringWithFormat:@"%lf",[self.workingSolutionValue doubleValue]];
//	//		[self.appDelegate.settings setObject:[NSString stringWithFormat:@"%f",[self.workingSolutionValue doubleValue]] forKey:@"DilutionDesiredUnits"];
//	//	}
//	NSLog(@"textField.tag %i",textField.tag);
//	NSLog(@"textField.text %@",textField.text);
//	if (textField.tag == 1) {
//		self.stockSolutionValue =  [textField.text floatValue];
//		textField.text = [NSString stringWithFormat:@"%.2f",self.stockSolutionValue];
//		[self.appDelegate.settings setObject:[NSString stringWithFormat:@"%.2f",self.stockSolutionValue] forKey:@"MolarityMolecularWeightValue"];
//	} else if (textField.tag == 2) {
//		self.workingSolutionValue =  [textField.text floatValue];
//		textField.text = [NSString stringWithFormat:@"%.2f",self.workingSolutionValue];
//		[self.appDelegate.settings setObject:[NSString stringWithFormat:@"%.2f",self.workingSolutionValue] forKey:@"MolarityDesiredMolarValue"];
//	} else if (textField.tag == 3) {
//		self.desiredWorkingValue =  [textField.text floatValue];
//		textField.text = [NSString stringWithFormat:@"%.2f",self.desiredWorkingValue];
//		[self.appDelegate.settings setObject:[NSString stringWithFormat:@"%.2f",self.workingSolutionValue] forKey:@"MolarityFinalVolumeValue"];
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
// - (void)viewWillAppear:(BOOL)animated {
// [super viewWillAppear:animated];
// }
// */
///*
// - (void)viewDidAppear:(BOOL)animated {
// [super viewDidAppear:animated];
// }
// */
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//	if (self.pickerShowing == YES) {
//		[self hidePickerView];
//	}
//	[self.stockSolutionField resignFirstResponder];
//	[self.workingSolutionField resignFirstResponder];
//	[self.desiredSolutionField resignFirstResponder];
//	//	[self.appDelegate.settings setObject:self.stockSolutionUnitsButton.titleLabel forKey:@"DilutionStockUnits"];
//	//	[self.appDelegate.settings setObject:self.workingSolutionUnitsButton.titleLabel forKey:@"DilutionWorkingUnits"];
//	//	[self.appDelegate.settings setObject:self.desiredWorkingSolutionUnitsButton.titleLabel forKey:@"DilutionDesiredUnits"];
//	
//}
//
///*
// - (void)viewDidDisappear:(BOOL)animated {
// [super viewDidDisappear:animated];
// }
// */
///*
// // Override to allow orientations other than the default portrait orientation.
// - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
// // Return YES for supported orientations
// return (interfaceOrientation == UIInterfaceOrientationPortrait);
// }
// */
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
// // Override to support conditional editing of the table view.
// - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
// // Return NO if you do not want the specified item to be editable.
// return YES;
// }
// */
//
//
///*
// // Override to support editing the table view.
// - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
// 
// if (editingStyle == UITableViewCellEditingStyleDelete) {
// // Delete the row from the data source
// [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
// }   
// else if (editingStyle == UITableViewCellEditingStyleInsert) {
// // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
// }   
// }
// */
//
//
///*
// // Override to support rearranging the table view.
// - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
// }
// */
//
//
///*
// // Override to support conditional rearranging of the table view.
// - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
// // Return NO if you do not want the item to be re-orderable.
// return YES;
// }
// */
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
//	//	[self showPickerView];
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


@end
