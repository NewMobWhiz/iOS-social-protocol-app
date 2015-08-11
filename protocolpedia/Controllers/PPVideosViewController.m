//
//  PPVideosViewController.m
//  ProtocolPedia
//
//  26/03/14.


#import "PPVideosViewController.h"

#import "VideoWebViewController.h"
#import "SQLiteAccess.h"

@interface PPVideosViewController ()

@end

@implementation PPVideosViewController

@synthesize tableView, dataSource;
@synthesize selectedCategory;

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
    
    NSString *selectVideos = [NSString stringWithFormat:@"SELECT VideoId, Title  FROM Videos WHERE CategoryID = \"%@\"",self.selectedCategory];
	NSMutableArray *tempMenuItems = (NSMutableArray*)[[NSMutableArray alloc] initWithArray:[SQLiteAccess selectManyRowsWithSQL:selectVideos]];
	self.dataSource = tempMenuItems;
	
    UIImage *backImage = [UIImage imageNamed:@"btn_back.png"];
    [self setBackButton:backImage];
    
    [applicationDelegate popOverLayView];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize maxSize = CGSizeMake(300.0, 500.0);
    CGSize textLabelSize = [[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Title"] sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    return textLabelSize.height + 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CGSize maxSize = CGSizeMake(300.0, 500.0);
    CGSize textLabelSize = [[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Title"] sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    cell.textLabel.frame = CGRectMake(0.0, 0.0, textLabelSize.width, textLabelSize.height);
    cell.textLabel.text = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Title"];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	if ([GlobalMethods canConnect]) {
		[tableView_ deselectRowAtIndexPath:indexPath animated:NO];
        
        VideoWebViewController *videoWebViewController = [[VideoWebViewController alloc] initWithNibName:@"VideoWebViewController" bundle:nil];
        videoWebViewController.selectedVideoId = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"VideoId"];
        [[self navigationController] pushViewController:videoWebViewController animated:YES];
        
	} else {
		[GlobalMethods displayMessage:@"You must be connected to the internet to view video"];
	}
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
