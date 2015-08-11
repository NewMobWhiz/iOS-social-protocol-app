//
//  PPPCRMastermixViewController.m
//  ProtocolPedia
//
//  05/03/14.


#import "PPPCRMastermixViewController.h"

#import "InfoViewController.h"

#import "PPCalculatorVolumeCell.h"
#import "PPCalculatorPcrMastermixCell.h"

@interface PPPCRMastermixViewController ()

@end

@implementation PPPCRMastermixViewController

@synthesize tableView, dataSource;
@synthesize myValues;

static NSString *CellIdentifier = @"Cell";
static NSString *volumeCellIdentifier = @"volumeCell";
static NSString *pcrMastermixCellIdentifier = @"pcrMastermixCell";


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
    
    self.dataSource = [NSArray arrayWithObjects:@"No. of Reactions",[NSString stringWithFormat:@"Reaction Volume (%cl)",181],
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
	
    UINib *volumeCellNib = [UINib nibWithNibName:[self volumeCellNibName] bundle:nil];
    [self.tableView registerNib: volumeCellNib forCellReuseIdentifier:volumeCellIdentifier];
    
    UINib *pcrMastermixCellNib = [UINib nibWithNibName:[self pcrMastermixCellNibName] bundle:nil];
    [self.tableView registerNib:pcrMastermixCellNib forCellReuseIdentifier:pcrMastermixCellIdentifier];
    
	[self calculateValues];
    
}

-(void) loadInfo:(id)sender {
	InfoViewController *infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
	infoViewController.navbarTitle = @"PCR Mastermix Info";
	infoViewController.title = 	nil;
	infoViewController.thisString = @"This is a test!";
	[[self navigationController] pushViewController:infoViewController animated:YES];
	
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
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0)
        return 0.0;
    else
        return 25.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
        return nil;
    }
    else {
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLabel.frame = CGRectMake(40, 0, self.tableView.frame.size.width, 25);
        tempLabel.text = [NSString stringWithFormat:@"        stock                  final             mastermix(%cl)",181];
        tempLabel.textAlignment = UITextAlignmentLeft;
        tempLabel.font = [UIFont systemFontOfSize:14];
        tempLabel.textColor = [UIColor whiteColor];
        tempLabel.backgroundColor = [UIColor lightGrayColor];
		return tempLabel;
	}
}

- (NSString *)volumeCellNibName{
    return @"PPCalculatorVolumeCell";
}

- (NSString *)pcrMastermixCellNibName{
    return @"PPCalculatorPcrMastermixCell";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        PPCalculatorVolumeCell *cell = (PPCalculatorVolumeCell *)[self.tableView dequeueReusableCellWithIdentifier:volumeCellIdentifier];
        [self configureVolumeCell:cell atIndexPath:indexPath];
        return cell;
        
    }
    if (indexPath.section == 1) {
        
        PPCalculatorPcrMastermixCell *cell = (PPCalculatorPcrMastermixCell *)[self.tableView dequeueReusableCellWithIdentifier:pcrMastermixCellIdentifier];
        [self configurePcrMastermixCell:cell atIndexPath:indexPath];
        return cell;
        
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
}

- (void)configureVolumeCell:(PPCalculatorVolumeCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    cell.name.text = [self.dataSource objectAtIndex:indexPath.row];
    cell.value.text = [[self.myValues objectAtIndex:indexPath.row] objectForKey:@"Value"];
    cell.value.tag = indexPath.row;
    cell.value.delegate = self;
    
}

- (void)configurePcrMastermixCell:(PPCalculatorPcrMastermixCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6) {
        cell.name.text = [self.dataSource objectAtIndex:indexPath.row+2];
        cell.stock.hidden = YES;
        cell.final.hidden = NO;
        cell.final.text = [[self.myValues objectAtIndex:indexPath.row+2] objectForKey:@"Final"];
        cell.final.tag = indexPath.row + 20;
        cell.final.delegate = self;
        cell.volume.hidden = YES;
        
        
        
    } else if (indexPath.row == 7) {
        cell.name.text = [self.dataSource objectAtIndex:indexPath.row+2];
        cell.stock.hidden = YES;
        cell.final.hidden = YES;
        cell.volume.text = [[self.myValues objectAtIndex:indexPath.row+2] objectForKey:@"Volume"];
        cell.volume.hidden = NO;
    } else {
        cell.stock.hidden = NO;
        cell.final.hidden = NO;
        cell.name.text = [self.dataSource objectAtIndex:indexPath.row+2];
        cell.stock.text = [[self.myValues objectAtIndex:indexPath.row+2] objectForKey:@"Stock"];
        cell.final.text = [[self.myValues objectAtIndex:indexPath.row+2] objectForKey:@"Final"];
        cell.volume.text = [[self.myValues objectAtIndex:indexPath.row+2] objectForKey:@"Volume"];
        cell.volume.hidden = NO;
        cell.stock.tag = indexPath.row + 10;
        cell.final.tag = indexPath.row + 20;
        cell.stock.delegate = self;
        cell.final.delegate = self;
    }
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
	[self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
	
	[self.tableView reloadData];  // adds the new data to the table
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
