//
//  PPSelectCategoriesViewController.m
//  ProtocolPedia
//
//  25/06/14.


#import "PPSelectCategoriesViewController.h"

#import "SQLiteAccess.h"

@interface PPSelectCategoriesViewController ()

@end

@implementation PPSelectCategoriesViewController

@synthesize tableView, dataSource;
@synthesize setClear, categoryType;

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
    
    [self setRightBarButtonWithString:@"Set/Clear All"];
    
    self.setClear = YES;
	
    if ([self.categoryType isEqualToString:@"Video"]) {
		self.dataSource = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT CategoryId, CategoryType, Name, Selected FROM Categories WHERE CategoryType = \"%@\" ORDER BY Name" ,self.categoryType]];
	} else if ([self.categoryType isEqualToString:@"Topics"]) {
		self.dataSource = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT CategoryId, CategoryType, Name, Selected FROM Categories WHERE CategoryType = \"%@\" AND ParentID = \"1\" ORDER BY Name",self.categoryType]];
	} else if ([self.categoryType isEqualToString:@"Protocol"]) {
		self.dataSource = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT CategoryId, CategoryType, Name, Selected FROM Categories WHERE CategoryType = \"%@\" AND CategoryId <> \"1\" ORDER BY Name",self.categoryType]];
	}
}

- (IBAction)onRightBarButton:(id)sender {
    [self setAll];
}

-(void)setAll {
	if (self.setClear == YES) {
		self.setClear = NO;
		[SQLiteAccess updateWithSQL:[NSString stringWithFormat:@"UPDATE Categories SET Selected = \"Yes\" WHERE CategoryType = \"%@\"",self.categoryType]];
	} else {
		self.setClear = YES;
		[SQLiteAccess updateWithSQL:[NSString stringWithFormat:@"UPDATE Categories SET Selected = \"No\" WHERE CategoryType = \"%@\"",self.categoryType]];
	}
	if ([self.categoryType isEqualToString:@"Video"]) {
		self.dataSource = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT CategoryId, CategoryType, Name, Selected FROM Categories WHERE CategoryType = \"%@\" ORDER BY Name" ,self.categoryType]];
	} else if ([self.categoryType isEqualToString:@"Topics"]) {
		self.dataSource = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT CategoryId, CategoryType, Name, Selected FROM Categories WHERE CategoryType = \"%@\" AND ParentID = \"1\" ORDER BY Name",self.categoryType]];
	} else if ([self.categoryType isEqualToString:@"Protocol"]) {
		self.dataSource = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT CategoryId, CategoryType, Name, Selected FROM Categories WHERE CategoryType = \"%@\" AND CategoryId <> \"1\" ORDER BY Name",self.categoryType]];
	}
	[self.tableView reloadData];
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
    }
    
    cell.textLabel.text = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Name"];
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	if ([[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Selected"] isEqualToString:@"Yes"]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
    
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Selected"] isEqualToString:@"Yes"]) {
		NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataSource];
		NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:[self.dataSource objectAtIndex:indexPath.row]];
		[tempDict setValue:@"No" forKey:@"Selected"];
		[tempArray replaceObjectAtIndex:indexPath.row withObject:tempDict];
		self.dataSource = tempArray;
		[SQLiteAccess updateWithSQL:[NSString stringWithFormat:@"UPDATE Categories SET Selected = \"No\" WHERE CategoryId = \"%@\"",[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"CategoryId"]]];
	} else {
		NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataSource];
		NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:[self.dataSource objectAtIndex:indexPath.row]];
		[tempDict setValue:@"Yes" forKey:@"Selected"];
		[tempArray replaceObjectAtIndex:indexPath.row withObject:tempDict];
		self.dataSource = tempArray;
		[SQLiteAccess updateWithSQL:[NSString stringWithFormat:@"UPDATE Categories SET Selected = \"Yes\" WHERE CategoryId = \"%@\"",[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"CategoryId"]]];
	}
	[tableView_ reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
