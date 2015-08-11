//
//  PPDillutionCalculatorViewController.m
//  ProtocolPedia
//
//  04/03/14.


#import "PPDilutionCalculatorViewController.h"

#import "PPCalculatorDataEntryCell.h"
#import "PPCalculatorResultsCell.h"

#import "PPUnitSelectionViewController.h"

@interface PPDilutionCalculatorViewController ()

@end

@implementation PPDilutionCalculatorViewController

@synthesize tableView;

@synthesize calculatorData;
@synthesize result;

static NSString *CellIdentifier = @"Cell";
static NSString *dataEntryCellIdentifier = @"dataEntryCell";
static NSString *resultsCellIdentifier = @"resultsCell";


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
    
    self.calculatorData = [[NSMutableDictionary alloc] initWithContentsOfFile:[GlobalMethods dataFilePathofDocuments:@"Dilution.plist"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self calculateValues];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
	BOOL ok = [self.calculatorData writeToFile:[GlobalMethods dataFilePathofDocuments:@"Dilution.plist"] atomically:YES];
	if (ok != YES) {NSLog(@"Dilution did not save!");}
	
}

- (void)viewDidUnload{
    [super viewDidUnload];
    
    self.tableView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
	
	
	[self.tableView reloadData];
	
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

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

- (void)configureDataEntryCell:(PPCalculatorDataEntryCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    cell.dataValue.tag = indexPath.row;
    cell.dataValue.delegate = self;
    
    if (indexPath.row == 0) {
        cell.dataName.text = @"Concentration of Stock Solution";
        cell.dataValue.text = [self.calculatorData objectForKey:@"DiltuionStockValue"];
        cell.dataUnits.text = [self.calculatorData objectForKey:@"DilutionStockUnits"];
        
    } else if (indexPath.row == 1) {
        cell.dataName.text = @"Concentration of Working Solution";
        cell.dataValue.text = [self.calculatorData objectForKey:@"DilutionWorkingValue"];
        cell.dataUnits.text = [self.calculatorData objectForKey:@"DilutionWorkingUnits"];
        
    } else if (indexPath.row == 2) {
        cell.dataName.text = @"Volume of working solution";
        cell.dataValue.text = [self.calculatorData objectForKey:@"DilutionDesiredValue"];
        cell.dataUnits.text = [self.calculatorData objectForKey:@"DilutionDesiredUnits"];
        
    }
    
}

- (void)configureResultsCell:(PPCalculatorResultsCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.result) {
        self.result = @"0";
    }
    cell.resultsName.text = @"Stock Solution to Add";
    cell.resultUnits.text = [self.calculatorData objectForKey:@"ResultsUnits"];
    cell.result.text = self.result;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView_ deselectRowAtIndexPath:indexPath animated:NO];
	if (indexPath.row == 0) {
        
        PPUnitSelectionViewController *unitSelectionVC = [[PPUnitSelectionViewController alloc] initWithNibName:@"PPUnitSelectionViewController" bundle:nil];
        unitSelectionVC.dataSource = [NSArray arrayWithObjects:@"molar", @"millimolar",@"micromolar",@"nanomolar",@"picomolar",nil];
        unitSelectionVC.currentSelection = [self.calculatorData objectForKey:@"DilutionStockUnits"];
        unitSelectionVC.keyValue = @"DilutionStockUnits";
        [self.navigationController pushViewController:unitSelectionVC animated:YES];
        
        
	} else if (indexPath.row == 1) {
        
        PPUnitSelectionViewController *unitSelectionVC = [[PPUnitSelectionViewController alloc] initWithNibName:@"PPUnitSelectionViewController" bundle:nil];
        unitSelectionVC.dataSource = [NSArray arrayWithObjects:@"molar", @"millimolar",@"micromolar",@"nanomolar",@"picomolar",nil];
        unitSelectionVC.currentSelection = [self.calculatorData objectForKey:@"DilutionWorkingUnits"];
        unitSelectionVC.keyValue = @"DilutionWorkingUnits";
        [self.navigationController pushViewController:unitSelectionVC animated:YES];
        
	} else if (indexPath.row == 2) {
        
        PPUnitSelectionViewController *unitSelectionVC = [[PPUnitSelectionViewController alloc] initWithNibName:@"PPUnitSelectionViewController" bundle:nil];
        unitSelectionVC.dataSource = [NSArray arrayWithObjects:@"liters", @"milliliters",@"microliters",@"nanoliters",@"picoliters",nil];
        unitSelectionVC.currentSelection = [self.calculatorData objectForKey:@"DilutionDesiredUnits"];
        unitSelectionVC.keyValue = @"DilutionDesiredUnits";
        [self.navigationController pushViewController:unitSelectionVC animated:YES];
        
        
        
	} else if (indexPath.row == 3) {
        
        PPUnitSelectionViewController *unitSelectionVC = [[PPUnitSelectionViewController alloc] initWithNibName:@"PPUnitSelectionViewController" bundle:nil];
        unitSelectionVC.dataSource = [NSArray arrayWithObjects:@"liters", @"milliliters",@"microliters",@"nanoliters",@"picoliters",nil];
        unitSelectionVC.currentSelection = [self.calculatorData objectForKey:@"ResultsUnits"];
        unitSelectionVC.keyValue = @"ResultsUnits";
        [self.navigationController pushViewController:unitSelectionVC animated:YES];
        
	}
}


-(void) updateSelectionFor:(NSString*)key with:(NSString*)value  {
	[self.calculatorData setObject:value forKey:key];
	
}


@end
