//
//  PPMolarityViewController.m
//  ProtocolPedia
//
//  05/03/14.


#import "PPMolarityViewController.h"

#import "PPUnitSelectionViewController.h"

#import "PPCalculatorDataEntryCell.h"
#import "PPCalculatorResultsCell.h"

@interface PPMolarityViewController ()

@end

@implementation PPMolarityViewController

@synthesize tableView;

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
    
    self.calculatorData = [[NSMutableDictionary alloc] initWithContentsOfFile:[GlobalMethods dataFilePathofDocuments:@"Molarity.plist"]];
	
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self calculateValues];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
	BOOL ok = [self.calculatorData writeToFile:[GlobalMethods dataFilePathofDocuments:@"Molarity.plist"] atomically:YES];
	if (ok != YES) {NSLog(@"Molarity did not save!");}
	
}

- (void)viewDidUnload{
    [super viewDidUnload];
    
    self.tableView = nil;
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
	
	[self.tableView reloadData];
	
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	
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
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
}

- (void)configureDataEntryCell:(PPCalculatorDataEntryCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    cell.dataValue.tag = indexPath.row;
    cell.dataValue.delegate = self;
    
    if (indexPath.row == 0) {
        cell.dataName.text = @"Molecular Weight";
        cell.dataValue.text = [self.calculatorData objectForKey:@"MolarityMolecularWeightValue"];
        cell.dataUnits.text = @"grams/mole";
        
    } else if (indexPath.row == 1) {
        cell.dataName.text = @"Desired Molar Solution";
        cell.dataValue.text = [self.calculatorData objectForKey:@"MolarityDesiredMolarValue"];
        cell.dataUnits.text = [self.calculatorData objectForKey:@"MolarityDesiredMolarUnits"];
        
    } else if (indexPath.row == 2) {
        cell.dataName.text = @"Desired Final Volume";
        cell.dataValue.text = [self.calculatorData objectForKey:@"MolarityFinalVolumeValue"];
        cell.dataUnits.text = [self.calculatorData objectForKey:@"MolarityFinalVolumeUnits"];
        
    }
    
}

- (void)configureResultsCell:(PPCalculatorResultsCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.result) {
        self.result = @"0";
    }
    cell.resultsName.text = @"Volume of Solution to Add:";
    cell.resultUnits.text = @"grams"; //[self.calculatorData objectForKey:@"UnitsOfSolutionToAdd"];
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
        unitSelectionVC.currentSelection = [self.calculatorData objectForKey:@"MolarityDesiredMolarUnits"];
        unitSelectionVC.keyValue = @"MolarityDesiredMolarUnits";
        [self.navigationController pushViewController:unitSelectionVC animated:YES];
        
	} else if (indexPath.row == 2) {
        PPUnitSelectionViewController *unitSelectionVC = [[PPUnitSelectionViewController alloc] initWithNibName:@"PPUnitSelectionViewController" bundle:nil];
        unitSelectionVC.dataSource = [NSArray arrayWithObjects:@"liters", @"milliliters",@"microliters",@"nanoliters",@"picoliters",nil];
        unitSelectionVC.currentSelection = [self.calculatorData objectForKey:@"MolarityFinalVolumeUnits"];
        unitSelectionVC.keyValue = @"MolarityFinalVolumeUnits";
        [self.navigationController pushViewController:unitSelectionVC animated:YES];
        
	}
}


-(void) updateSelectionFor:(NSString*)key with:(NSString*)value  {
    NSLog(@"self.calculatorData %@",self.calculatorData);
    
	[self.calculatorData setObject:value forKey:key];
    NSLog(@"self.calculatorData after %@",self.calculatorData);
    
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
