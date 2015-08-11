//
//  PPResuspensionViewController.m
//  ProtocolPedia
//
//  05/03/14.


#import "PPResuspensionViewController.h"

#import "PPUnitSelectionViewController.h"

#import "PPCalculatorDataCell.h"
#import "PPCalculatorDataEntryCell.h"
#import "PPCalculatorResultsCell.h"

@interface PPResuspensionViewController ()

@end

@implementation PPResuspensionViewController

@synthesize tableView;
@synthesize result, calculatorData;


static NSString *CellIdentifier = @"Cell";
static NSString *dataEntryCellIdentifier = @"dataEntryCell";
static NSString *resultsCellIdentifier = @"resultsCell";
static NSString *dataCellIdentifier = @"dataCell";


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
    // Do any additional setup after loading the view from its nib.
    
    UIImage *backImage = [UIImage imageNamed:@"btn_back.png"];
    [self setBackButton:backImage];
    
    UINib *dataEntryCellNib = [UINib nibWithNibName:[self dataEntryCellNibName] bundle:nil];
    [self.tableView registerNib: dataEntryCellNib forCellReuseIdentifier:dataEntryCellIdentifier];
    
    UINib *resultsCellNib = [UINib nibWithNibName:[self resultsCellNibName] bundle:nil];
    [self.tableView registerNib:resultsCellNib forCellReuseIdentifier:resultsCellIdentifier];
    
    UINib *dataCellNib = [UINib nibWithNibName:[self dataCellNibName] bundle:nil];
    [self.tableView registerNib:dataCellNib forCellReuseIdentifier:dataCellIdentifier];
    
    self.calculatorData = [[NSMutableDictionary alloc] initWithContentsOfFile:[GlobalMethods dataFilePathofDocuments:@"Resuspension.plist"]];
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
	if ([[self.calculatorData objectForKey:@"ResuspensionQtyUnits"] isEqualToString:@"nmole"]) {
		[self.calculatorData setObject:@"Not Needed" forKey:@"ResuspensionMolecularWeightNote"];
	}	else {
		[self.calculatorData setObject:@"" forKey:@"ResuspensionMolecularWeightNote"];
	}
	[self calculateValues];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
	BOOL ok = [self.calculatorData writeToFile:[GlobalMethods dataFilePathofDocuments:@"Resuspension.plist"] atomically:YES];
	if (ok != YES) {NSLog(@"calculatorData did not save!");}
	
}

- (void)viewDidUnload{
    [super viewDidUnload];
    
    self.tableView = nil;
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
    
	
	[self.tableView reloadData];
    
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
	}
    
	[self calculateValues];
    
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

- (NSString *)dataEntryCellNibName{
    return @"PPCalculatorDataEntryCell";
}

- (NSString *)resultsCellNibName{
    return @"PPCalculatorResultsCell";
}

- (NSString *)dataCellNibName{
    return @"PPCalculatorDataCell";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {

        PPCalculatorDataCell *cell = (PPCalculatorDataCell *)[self.tableView dequeueReusableCellWithIdentifier:dataCellIdentifier];
        [self configureDataCell:cell atIndexPath:indexPath];
        return cell;
        
    }
    if (indexPath.row == 3) {
        
        PPCalculatorResultsCell *cell = (PPCalculatorResultsCell *)[self.tableView dequeueReusableCellWithIdentifier:resultsCellIdentifier];
        [self configureResultsCell:cell atIndexPath:indexPath];
        return cell;
        
    }
    else {
        
        PPCalculatorDataEntryCell *cell = (PPCalculatorDataEntryCell *)[self.tableView dequeueReusableCellWithIdentifier:dataEntryCellIdentifier];
        [self configureDataEntryCell:cell atIndexPath:indexPath];
        return cell;
        
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
}

- (void)configureDataCell:(PPCalculatorDataCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    cell.titleLabel.text = @"Type";
    cell.descriptionLabel.text = [self.calculatorData objectForKey:@"ResuspensionType"];
    
}
- (void)configureDataEntryCell:(PPCalculatorDataEntryCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    cell.dataValue.tag = indexPath.row;
    cell.dataValue.delegate = self;
    
    if (indexPath.row == 1) {
        cell.dataName.text = @"Quantity";
        cell.dataValue.text = [self.calculatorData objectForKey:@"ResuspensionQtyValue"];
        cell.dataUnits.text = [self.calculatorData objectForKey:@"ResuspensionQtyUnits"];
        
    } else if (indexPath.row == 2) {
        cell.dataName.text = @"Molecular Weight";
        cell.dataValue.text = [self.calculatorData objectForKey:@"ResuspensionMolecularWeight"];
        cell.dataUnits.text = [self.calculatorData objectForKey:@"ResuspensionMolecularWeightNote"];
    }
    
}

- (void)configureResultsCell:(PPCalculatorResultsCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    cell.resultsName.text = [NSString stringWithFormat:@"Resuspend Volume (100%cM concentration)",181];
    cell.resultUnits.text = @"microliters";//[NSString stringWithFormat:@"%cl",181];
    cell.result.text = self.result;
    
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView_ deselectRowAtIndexPath:indexPath animated:NO];
	
    if (indexPath.row == 0) {
		
        PPUnitSelectionViewController *unitSelectionVC = [[PPUnitSelectionViewController alloc] initWithNibName:@"PPUnitSelectionViewController" bundle:nil];
        unitSelectionVC.dataSource = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Single-Stranded DNA, 33%cg/OD260",181],[NSString stringWithFormat:@"Double-Stranded DNA, 50%cg/OD260",181],[NSString stringWithFormat:@"Single-Stranded RNA, 40%cg/OD260",181],nil];
        unitSelectionVC.currentSelection = [applicationDelegate.settings objectForKey:@"ResuspensionType"];
		unitSelectionVC.keyValue = @"ResuspensionType";
		[self.navigationController pushViewController:unitSelectionVC animated:YES];
		
        
	} else if (indexPath.row == 1) {
		PPUnitSelectionViewController *unitSelectionVC = [[PPUnitSelectionViewController alloc] initWithNibName:@"PPUnitSelectionViewController" bundle:nil];
        unitSelectionVC.dataSource = [NSArray arrayWithObjects:@"OD260", @"nmole",nil]; ;
		unitSelectionVC.currentSelection = [self.calculatorData objectForKey:@"ResuspensionQtyUnits"];
		unitSelectionVC.keyValue = @"ResuspensionQtyUnits";
		[self.navigationController pushViewController:unitSelectionVC animated:YES];
		
	} 
}


-(void) updateSelectionFor:(NSString*)key with:(NSString*)value  {
	[self.calculatorData setObject:value forKey:key];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
