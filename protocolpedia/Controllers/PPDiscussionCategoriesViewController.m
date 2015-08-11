//
//  PPDiscussionCategoriesViewController.m
//  ProtocolPedia
//
//  26/03/14.


#import "PPDiscussionCategoriesViewController.h"

#import "SQLiteAccess.h"

#import "PPTopicsViewController.h"

@interface PPDiscussionCategoriesViewController ()

@end

@implementation PPDiscussionCategoriesViewController

@synthesize dataSource, tableView;
@synthesize parentId;

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
    
    self.dataSource = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT * FROM Categories WHERE ParentId = %@ AND CategoryType = \"Topics\"",self.parentId]];
    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	cell.textLabel.text = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Name"];
	if ([[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"NumberOfItems"] isEqualToString:@"1"]) {
		NSString *tempString = [NSString stringWithFormat:@"%@ topic, %@",[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"NumberOfItems"],[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Description"]];
		cell.detailTextLabel.text = tempString;
	} else {
		NSString *tempString = [NSString stringWithFormat:@"%@ topics, %@",[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"NumberOfItems"],[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Description"]];
		cell.detailTextLabel.text = tempString;
	}
    
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView_ deselectRowAtIndexPath:indexPath animated:NO];
    
    PPTopicsViewController *topicsListViewController = [[PPTopicsViewController alloc] initWithNibName:@"PPTopicsViewController" bundle:nil];
    topicsListViewController.categoryId = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"CategoryId"];
    [self.navigationController pushViewController:topicsListViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
