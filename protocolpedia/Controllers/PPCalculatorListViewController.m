//
//  PPCalculatorListViewController.m
//  ProtocolPedia
//
//  27/02/14.


#import "PPCalculatorListViewController.h"

#import "labTimerCalculator.h"

#import "CalculatorViewCell.h"

#import "PPDilutionCalculatorViewController.h"
#import "PPMolarityViewController.h"
#import "PPResuspensionViewController.h"
#import "PPPCRMastermixViewController.h"

@interface PPCalculatorListViewController ()

@end

@implementation PPCalculatorListViewController

@synthesize tableView, dataSource;

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
    
    self.dataSource = @[@"Dilution", @"Molarity", @"Oligo Resuspension", @"PCR Mastermix", @"Timer"];
    
    UIImage *slideLeftImage = [UIImage imageNamed:@"btn_slide_left.png"];
    [self setLeftBarButton:slideLeftImage];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    applicationDelegate.viewDeckController.panningMode = IIViewDeckFullViewPanning;
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if ([self cellNibName] != nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:[self cellNibName] owner:nil options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    cell = currentObject;
                    break;
                }
            }
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }
}

- (void)configureCell:(CalculatorViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.titleLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [self.dataSource objectAtIndex:indexPath.row]]];
    
}

- (NSString *)cellNibName{
    return @"CalculatorViewCell";
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	if (indexPath.row == 0) {
        PPDilutionCalculatorViewController *dilutionCalculatorVC = [[PPDilutionCalculatorViewController alloc]initWithNibName:@"PPDilutionCalculatorViewController" bundle:nil];
        [delegate.navigationController pushViewController:dilutionCalculatorVC animated:YES];
        
		
	} else if (indexPath.row == 1) {
        
        PPMolarityViewController *molarityVC = [[PPMolarityViewController alloc] initWithNibName:@"PPMolarityViewController" bundle:nil];
        [delegate.navigationController pushViewController:molarityVC animated:YES];
        
        
	} else if (indexPath.row == 2) {
        
        PPResuspensionViewController *resuspensionVC = [[PPResuspensionViewController alloc] initWithNibName:@"PPResuspensionViewController" bundle:nil];
        [delegate.navigationController pushViewController:resuspensionVC animated:YES];
        
        
	} else if (indexPath.row == 3) {
        PPPCRMastermixViewController *pcrMastermixVC = [[PPPCRMastermixViewController alloc] initWithNibName:@"PPPCRMastermixViewController" bundle:nil];
        [delegate.navigationController pushViewController:pcrMastermixVC animated:YES];
        
        
	}else {
        
        labTimerCalculator *timerCal = [[labTimerCalculator alloc]initWithNibName:@"labTimerCalculator" bundle:[NSBundle mainBundle]];
        
        [delegate.navigationController pushViewController:timerCal animated:YES];
        
		
	}
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
