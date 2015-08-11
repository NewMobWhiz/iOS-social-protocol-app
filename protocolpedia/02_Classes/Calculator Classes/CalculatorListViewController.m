//
//  CalculatorListViewController.m
//  ProtocolPedia
//
//   7/8/10.


#import "CalculatorListViewController.h"
#import "DilutionCalculatorViewController.h"
#import "PCRMastermixViewController.h"
#import "MolarityViewController.h"
#import "ResuspensionViewController2.h"
#import "iAd/iAd.h"
#import "labTimerCalculator.h"

@implementation CalculatorListViewController




#pragma mark -
#pragma mark View lifecycle




- (void)revealSidebar {
	_revealBlock();
}

-(void)viewWillAppear:(BOOL)animated{
    UIColor *myColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"Red"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"Green"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"Blue"] floatValue]/255.0) alpha:1.0];
    UIColor *myTintColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"TintRed"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"TintGreen"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"TintBlue"] floatValue]/255.0) alpha:1.0];
    viewHeader.backgroundColor = myTintColor;
    self.view.backgroundColor = myColor;
    self.tableViewOutlet.backgroundColor = myColor;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRevealBlock:(RevealBlock)revealBlock{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _revealBlock = [revealBlock copy];
        
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
        lb1.text = @"Calculators";
        lb1.textAlignment = UITextAlignmentCenter;
        [viewHeader addSubview:lb1];
        
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 46, 40)];
        [btnBack setImage:[UIImage imageNamed:@"icn_menu_main.png"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
        [viewHeader addSubview:btnBack];
    }
    return self;
}

-(void)closeSubView{
    if ([self.view viewWithTag:999]) {
        UIView *v = [self.view viewWithTag:999];
        [v removeFromSuperview];
        v = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.navbarTitle = @"Calculators";
	self.navigationItem.title = nil;
	self.menuItems = [NSArray arrayWithObjects:	@"Dilution",
												@"Molarity",
												@"Oligo Resuspension",
												@"PCR Mastermix",
												@"Timer",
												nil];
    
    [self.tableViewOutlet setBackgroundView:nil];
																										
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
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuItems count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//	if (section == 0) {
//		return @"DNA Utilities";
//	} else if (section == 1) {
//		return @"General Lab Techniques";
//	} else if (section == 2) {
//		return @"Conversion Utilities";
//	}
//    return nil;
//
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//	return 30;
//
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//	
//	UILabel *sectionHeaderLabel = [[[UILabel alloc] init] autorelease];
//	
//
//	//sectionHeaderLabel.frame = CGRectMake(20, 30, 260, 30);;
//	
//	
//	sectionHeaderLabel.shadowColor = nil;
//	sectionHeaderLabel.textColor = [UIColor whiteColor];
//	sectionHeaderLabel.backgroundColor = [UIColor clearColor];
//	sectionHeaderLabel.font = [UIFont boldSystemFontOfSize:17];
//	if (section == 0) {
//		sectionHeaderLabel.text =  @"   DNA Utilities";
//	} else if (section == 1) {
//		sectionHeaderLabel.text =  @"   General Lab Techniques";
//	} else if (section == 2) {
//		sectionHeaderLabel.text =  @"   Conversion Utilities";
//	}
//    return sectionHeaderLabel;
//}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
		static NSString *CellIdentifier = @"Cell1";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
		cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", cell.textLabel.text]];
	
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
	
	if (indexPath.row == 0) {
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            DilutionCalculatorViewController *dilutionCalculatorViewController = [[DilutionCalculatorViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
//            dilutionCalculatorViewController.navbarTitle = [self.menuItems objectAtIndex:indexPath.row];
//            dilutionCalculatorViewController.title = nil;
//            dilutionCalculatorViewController.view.frame = CGRectMake(448, 0, 448, 1004);
//            dilutionCalculatorViewController.view.tag = 999;
//            [self.view addSubview:dilutionCalculatorViewController.view];
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                dilutionCalculatorViewController.view.frame = CGRectMake(0, 0, 448, 1004);
//            }];
//        }
//        else{
            DilutionCalculatorViewController *dilutionCalculatorViewController = [[DilutionCalculatorViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
            dilutionCalculatorViewController.navbarTitle = [self.menuItems objectAtIndex:indexPath.row];
            dilutionCalculatorViewController.title = nil;
            [[self navigationController] pushViewController:dilutionCalculatorViewController animated:YES];
        
//        }
		
	} else if (indexPath.row == 1) {
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            MolarityViewController *molarityViewController = [[MolarityViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
//            molarityViewController.navbarTitle = [self.menuItems objectAtIndex:indexPath.row];
//            molarityViewController.title = nil;
//            molarityViewController.view.frame = CGRectMake(448, 0, 448, 1004);
//            molarityViewController.view.tag = 999;
//            [self.view addSubview:molarityViewController.view];
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                molarityViewController.view.frame = CGRectMake(0, 0, 448, 1004);
//            }];
//        }
//        else{
            MolarityViewController *molarityViewController = [[MolarityViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
            molarityViewController.navbarTitle = [self.menuItems objectAtIndex:indexPath.row];
            molarityViewController.title = nil;
            [[self navigationController] pushViewController:molarityViewController animated:YES];
        
//        }
					
	} else if (indexPath.row == 2) {
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            ResuspensionViewController2 *resuspensionViewController2 = [[ResuspensionViewController2 alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
//            resuspensionViewController2.navbarTitle = [self.menuItems objectAtIndex:indexPath.row];
//            resuspensionViewController2.title = nil;
//            resuspensionViewController2.view.tag = 999;
//            resuspensionViewController2.view.frame = CGRectMake(448, 0, 448, 1004);
//            [self.view addSubview:resuspensionViewController2.view];
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                resuspensionViewController2.view.frame = CGRectMake(0, 0, 448, 1004);
//            }];
//        }
//        else{
            ResuspensionViewController2 *resuspensionViewController2 = [[ResuspensionViewController2 alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
            resuspensionViewController2.navbarTitle = [self.menuItems objectAtIndex:indexPath.row];
            resuspensionViewController2.title = nil;
            [[self navigationController] pushViewController:resuspensionViewController2 animated:YES];
        
//        }
					
	} else if (indexPath.row == 3) {
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            PCRMastermixViewController *pcrMastermixViewController = [[PCRMastermixViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
//            pcrMastermixViewController.navbarTitle = [self.menuItems objectAtIndex:indexPath.row];
//            pcrMastermixViewController.title = nil;
//            pcrMastermixViewController.view.tag = 999;
//            pcrMastermixViewController.view.frame = CGRectMake(448, 0, 448, 1004);
//            [self.view addSubview:pcrMastermixViewController.view];
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                pcrMastermixViewController.view.frame = CGRectMake(0, 0, 448, 1004);
//            }];
//        }
//        else{
            PCRMastermixViewController *pcrMastermixViewController = [[PCRMastermixViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
            pcrMastermixViewController.navbarTitle = [self.menuItems objectAtIndex:indexPath.row];
            pcrMastermixViewController.title = nil;
            [[self navigationController] pushViewController:pcrMastermixViewController animated:YES];
        
//        }
				
	}else {
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            labTimerCalculator *timerCal = [[labTimerCalculator alloc]initWithNibName:@"labTimerCalculator" bundle:[NSBundle mainBundle]];
//            timerCal.view.tag = 999;
//            timerCal.view.frame = CGRectMake(448, 0, 448, 1004);
//            [self.view addSubview:timerCal.view];
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                timerCal.view.frame = CGRectMake(0, 0, 448, 1004);
//            }];
//        }
//        else{
            labTimerCalculator *timerCal = [[labTimerCalculator alloc]initWithNibName:@"labTimerCalculator" bundle:[NSBundle mainBundle]];
            //timerCal.navbarTitle = [self.menuItems objectAtIndex:indexPath.row];
            //	timerCal.title = nil;
            
            [self.navigationController pushViewController:timerCal animated:YES];
        
//        }
		
	}

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

