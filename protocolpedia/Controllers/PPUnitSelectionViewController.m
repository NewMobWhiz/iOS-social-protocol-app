//
//  PPUnitSelectionViewController.m
//  ProtocolPedia
//
//  05/03/14.


#import "PPUnitSelectionViewController.h"

#import "DilutionCalculatorViewController.h"

@interface PPUnitSelectionViewController ()

@end

@implementation PPUnitSelectionViewController

@synthesize tableView, dataSource;

@synthesize currentSelection, keyValue;

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
}

- (void)viewDidUnload{
    [super viewDidUnload];
    
    self.tableView = nil;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.dataSource count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.textLabel.adjustsFontSizeToFitWidth = YES;
		cell.textLabel.minimumFontSize = 10;
    }
	
    
    if ([self.currentSelection isEqualToString:[self.dataSource objectAtIndex:indexPath.row]]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView_ cellForRowAtIndexPath:indexPath];
	self.currentSelection = cell.textLabel.text;
	NSLog(@"self.currentSelection %@",self.currentSelection);
	NSLog(@"self.keyValue %@",self.keyValue);
	
	UINavigationController *myUINavigationController;
	myUINavigationController = (UINavigationController*)self.parentViewController;
	int n = [myUINavigationController.viewControllers count];
	[(DilutionCalculatorViewController*)[myUINavigationController.viewControllers objectAtIndex:n-2] updateSelectionFor:self.keyValue with:self.currentSelection];
	
    //	[self.appDelegate.settings setObject:self.currentSelection forKey:self.keyValue];
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
