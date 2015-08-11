//
// GHMenuViewController.m
//

#import "GHMenuViewController.h"
#import "GHMenuCell.h"
#import "GHRevealViewController.h"
#import <QuartzCore/QuartzCore.h>


#pragma mark -
#pragma mark Implementation
@implementation GHMenuViewController {
    GHRevealViewController *_sidebarVC;
    UISearchBar *_searchBar;
    UITableView *_menuTableView;
    NSArray *_headers;
    NSArray *_controllers;
    NSArray *_cellInfos;
}

#pragma mark Memory Management
- (id)initWithSidebarViewController:(GHRevealViewController *)sidebarVC
                      withSearchBar:(UISearchBar *)searchBar
                        withHeaders:(NSArray *)headers
                    withControllers:(NSArray *)controllers
                      withCellInfos:(NSArray *)cellInfos {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _sidebarVC = sidebarVC;
        _searchBar = searchBar;
        _headers = headers;
        _controllers = controllers;
        _cellInfos = cellInfos;
        
        _sidebarVC.sidebarViewController = self;
        _sidebarVC.contentViewController = _controllers[0];
    }
    return self;
}

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:_searchBar];
    
    _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds) - 0.0f)
                                                  style:UITableViewStylePlain];
    _menuTableView.scrollEnabled = NO;
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    _menuTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _menuTableView.backgroundColor = [UIColor colorWithRed:36.0/255 green:36.0/255 blue:36.0/255 alpha:1.0];
    _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_menuTableView];
//    [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    
    _vMask = [[UIView alloc] initWithFrame:CGRectMake(kGHRevealSidebarWidth, 0, self.view.bounds.size.width - kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds))];
    [self.view addSubview:_vMask];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:_sidebarVC
                                                                                 action:@selector(dragContentView:)];
    panGesture.cancelsTouchesInView = YES;
    [_vMask addGestureRecognizer:panGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    self.view.frame = CGRectMake(0.0f, 0.0f,kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
    [_searchBar sizeToFit];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return (orientation == UIInterfaceOrientationPortraitUpsideDown)
    ? (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    : YES;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([UIScreen mainScreen].bounds.size.height > 480) {
        return 60;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"GHMenuCell";
    GHMenuCell *cell = (GHMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GHMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *info = _cellInfos[indexPath.row];
    cell.textLabel.text = info[kSidebarCellTextKey];
    cell.imageView.image = info[kSidebarCellImageKey];
    
    if (indexPath.row == _controllers.count - 1) {
        UIView *bgView = [[UIView alloc] init];
		bgView.backgroundColor = [UIColor clearColor];
        [cell setSelectedBackgroundView:bgView];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _controllers.count - 1) {
        _sidebarVC.contentViewController = _controllers[0];
        [_sidebarVC toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
        return;
    }
    _sidebarVC.contentViewController = _controllers[indexPath.row + 1];
    [_sidebarVC toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
}

#pragma mark Public Methods
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
    [_menuTableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
    if (scrollPosition == UITableViewScrollPositionNone) {
        [_menuTableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    }
    _sidebarVC.contentViewController = _controllers[indexPath.row + 1];
}

-(void)reloadTableView{
    [_menuTableView reloadData];
}

@end