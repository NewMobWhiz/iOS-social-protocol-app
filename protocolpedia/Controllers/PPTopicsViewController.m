//
//  PPTopicsViewController.m
//  ProtocolPedia
//
//  26/03/14.


#import "PPTopicsViewController.h"

#import "AddTopicViewController.h"
#import "ThreadWebViewController.h"
#import "SQLiteAccess.h"

@interface PPTopicsViewController ()

@end

@implementation PPTopicsViewController

@synthesize tableView, dataSource;
@synthesize categoryId;

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
    
    self.dataSource = [NSMutableArray arrayWithArray:[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT DiscussionId, ThreadId, Subject FROM Discussions WHERE ParentID = \"0\" AND CategoryID = \"%@\"",self.categoryId]]];
    
	
	// set add Topic button for this view
	UIBarButtonItem *addTopicBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Add Topic" style:UIBarButtonItemStyleBordered target:self action:@selector(addTopic:)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	self.navigationItem.rightBarButtonItem = addTopicBarItem;
	
	NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
	[myNotificationCenter addObserver:self selector:@selector(reloadTable:) name:@"AddTopic" object:nil];
    
    UIImage *backImage = [UIImage imageNamed:@"btn_back.png"];
    [self setBackButton:backImage];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    
    self.tableView = nil;
    NSNotificationCenter *authenticationCompleteNotificationCenter = [NSNotificationCenter defaultCenter];
	[authenticationCompleteNotificationCenter removeObserver:self name:@"AddTopic" object:nil];
}

-(void) addTopic:(id)sender {
	if (applicationDelegate.loggedIn == YES) {
		if (applicationDelegate.addingTopic == NO) {
			AddTopicViewController *addTopicViewController = [[AddTopicViewController alloc] initWithNibName:@"AddTopicViewController" bundle:nil];
			addTopicViewController.categoryId = self.categoryId;
			[self.navigationController pushViewController:addTopicViewController animated:YES];
			
		} else {
			[GlobalMethods displayMessage:@"Currently Adding Topic"];
		}
	} else {
		[GlobalMethods displayMessage:@"You must be logged in to add topic"];
	}
}

-(void) reloadTable:(NSNotification*)notification  {
	self.dataSource = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT DiscussionId, ThreadId, Subject FROM Discussions WHERE ParentID = \"0\" AND CategoryID = \"%@\"",self.categoryId]];
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
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Subject"];
    
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView_ deselectRowAtIndexPath:indexPath animated:NO];
    
    
    ThreadWebViewController *threadWebViewController = [[ThreadWebViewController alloc] initWithNibName:@"ThreadWebViewController" bundle:nil];
    threadWebViewController.threadTitle = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Subject"];
    threadWebViewController.title = nil;
    threadWebViewController.threadId = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"ThreadId"];
    [[self navigationController] pushViewController:threadWebViewController animated:YES];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
