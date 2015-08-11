//
//  PPVideoCategorisViewController.m
//  ProtocolPedia
//
//  06/03/14.


#import "PPVideoCategorisViewController.h"

#import "SQLiteAccess.h"
#import "PPVideoCategoryCell.h"

#import "PPVideosViewController.h"

@interface PPVideoCategorisViewController ()

@end

@implementation PPVideoCategorisViewController

@synthesize tableView;
@synthesize dataSource;
@synthesize videoCounts;

static NSString *videoCategoryCellIdentifier = @"Cell";

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
    
    UIImage *slideLeftImage = [UIImage imageNamed:@"btn_slide_left.png"];
    [self setLeftBarButton:slideLeftImage];
    
    self.dataSource = (NSArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT * FROM Categories WHERE CategoryType = \"Video\" ORDER BY \"Name\""]];
    
    self.videoCounts = [NSMutableArray array];
    for (int i = 0; i < [self.dataSource count]; i ++) {
		NSString *count = [SQLiteAccess selectOneValueSQL:[NSString stringWithFormat:@"SELECT count(*) FROM Videos WHERE CategoryId = %@",[[self.dataSource objectAtIndex:i]objectForKey:@"CategoryId"]]];
		[self.videoCounts addObject:count];
	}
    
    UINib *videoCategoryCellNib = [UINib nibWithNibName:[self videoCategoryCellNibName] bundle:nil];
    [self.tableView registerNib: videoCategoryCellNib forCellReuseIdentifier:videoCategoryCellIdentifier];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    applicationDelegate.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    
}

- (void)viewDidUnload{
    [super viewDidUnload];
    
    self.tableView = nil;
}

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
    
    PPVideoCategoryCell *cell = (PPVideoCategoryCell *)[self.tableView dequeueReusableCellWithIdentifier:videoCategoryCellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}

- (NSString *)videoCategoryCellNibName{
    return @"PPVideoCategoryCell";
}

- (void)configureCell:(PPVideoCategoryCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.videoCategoryTitleLabel.text = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Name"];
    
    cell.videoCategoryDescriptionLabel.text = [NSString stringWithFormat:@"%@ videos",[self.videoCounts objectAtIndex:indexPath.row]];
    
    cell.videoCategoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Name"]]];
    
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	[applicationDelegate pushOverLayView];
	
    [tableView_ deselectRowAtIndexPath:indexPath animated:NO];
	
    PPVideosViewController *videoListViewController = [[PPVideosViewController alloc] initWithNibName:@"PPVideosViewController" bundle:nil];
    videoListViewController.selectedCategory = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"CategoryId"];
    
    [delegate.navigationController pushViewController:videoListViewController animated:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
