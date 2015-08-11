//
//  PPDiscussionsViewController.m
//  ProtocolPedia
//
//  26/03/14.


#import "PPDiscussionsViewController.h"

#import "SQLiteAccess.h"
#import "PPDiscussionViewCell.h"

#import "PPDiscussionCategoriesViewController.h"

@interface PPDiscussionsViewController ()

@end

@implementation PPDiscussionsViewController

@synthesize tableView, dataSource;

@synthesize getForumDiscussions;

static NSString *discussionCellIdentifier = @"Cell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSString *)discussionViewCell{
    return @"PPDiscussionViewCell";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *slideLeftImage = [UIImage imageNamed:@"btn_slide_left.png"];
    [self setLeftBarButton:slideLeftImage];
 
    
    UIBarButtonItem *updateForumBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStyleBordered target:self action:@selector(getForumDiscussionsMethod:)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];    
	self.navigationItem.rightBarButtonItem = updateForumBarItem;
	
    UINib *discussionCellNib = [UINib nibWithNibName:[self discussionViewCell] bundle:nil];
    [self.tableView registerNib: discussionCellNib forCellReuseIdentifier:discussionCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
    self.dataSource = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:@"SELECT * FROM Categories WHERE ParentId = 0 AND CategoryType = \"Topics\""];
	[self.tableView reloadData];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PPDiscussionViewCell *cell = (PPDiscussionViewCell *)[self.tableView dequeueReusableCellWithIdentifier:discussionCellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(PPDiscussionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.discussionTitleLabel.text = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Name"];
    
    if ([[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"NumberOfItems"] isEqualToString:@"1"]) {
		NSString *tempString = [NSString stringWithFormat:@"%@ catagory",[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"NumberOfItems"]];
		cell.discussionDescriptionLabel.text = tempString;
	} else {
		NSString *tempString = [NSString stringWithFormat:@"%@ catagories",[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"NumberOfItems"]];
		cell.discussionDescriptionLabel.text = tempString;
	}
    cell.discussionImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Name"]]];
    
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PPDiscussionCategoriesViewController *forumCategoriesViewController = [[PPDiscussionCategoriesViewController alloc] initWithNibName:@"PPDiscussionCategoriesViewController" bundle:nil];
    forumCategoriesViewController.parentId = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"CategoryId"];
    [delegate.navigationController pushViewController:forumCategoriesViewController animated:YES];
    
}


-(void) getForumDiscussionsMethod:(id)sender {
    
	if (applicationDelegate.loggedIn == YES) {
		if ((applicationDelegate.changingFavorite == NO) &&
			(applicationDelegate.addingTopic == NO) &&
			(applicationDelegate.currentlyDownloading == NO)) {
            
			@autoreleasepool {
			NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
			[myNotificationCenter addObserver:self selector:@selector(getForumDiscussionsComplete:) name:@"GetForumDiscussions" object:nil];
			
			GetForumDiscussions *tempGetForumDiscussions = [[GetForumDiscussions alloc] init];
			self.getForumDiscussions = tempGetForumDiscussions;
			[self.getForumDiscussions getMethodNow];
			
			}
		}
	} else {
		[GlobalMethods displayMessage:@"You must be logged in to update forums"];
	}
	
}


-(void) getForumDiscussionsComplete:(NSNotification *)notification {
	@autoreleasepool {
        NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
	[myNotificationCenter removeObserver:self name:@"GetForumDiscussions" object:nil];
	if ([[notification object] errorReceived]) {
		[GlobalMethods receivedError:[[notification object] errorReceived]];
	} else {
		[GlobalMethods postNotification:@"AddTopic" withObject:nil];
		[GlobalMethods displayMessage:@"Forum Update Complete"];
	}
	}
    
}	

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
