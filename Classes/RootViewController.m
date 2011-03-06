//
//  RootViewController.m
//  iMLate
//
//  Created by Benoît Clouet on 25/02/11.
//  Copyright 2011 Myself. All rights reserved.
//
#import "RootViewController.h"

@implementation RootViewController

@synthesize incidentsList, addButtonItem, refreshButtonItem, cancelButtonItem, connection, RESTAction, displayFormat;
#pragma mark -
#pragma mark View lifecycle

// Fetch and allocs an array of incidents from the website
- (void)initAndLaunchAsyncRequest {
	NSMutableURLRequest *theRequest;
	self.navigationItem.leftBarButtonItem = self.cancelButtonItem;
	
	// Display an activity indicator
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];

	// Init data placeholder
	responseData = [[NSMutableData data] retain];
	// Build the GET request
	NSString *URLString = [[NSString alloc] initWithFormat:@"http://%@/api/incidents.json/%@", 
			  [[NSUserDefaults standardUserDefaults] objectForKey:INCIDENT_SERVER_HOST], self.RESTAction];
	LogDebug(@"URL %@", URLString);
	theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy
						  timeoutInterval:60.0];
	[theRequest setHTTPMethod:@"GET"];
	// Asynchronously execute request
	connection = [[[NSURLConnection alloc] initWithRequest:theRequest delegate:self] autorelease];
	self.navigationItem.leftBarButtonItem = self.cancelButtonItem;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	LogError(@"%@", [error localizedDescription]);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Connexion impossible au serveur" 
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	[responseData release];
	
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	self.navigationItem.leftBarButtonItem = self.refreshButtonItem;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *string;
	NSError *error = nil;
	SBJsonParser *json = [SBJsonParser new];
	NSMutableArray *tempArray;
    // Once this method is invoked, "responseData" contains the complete result

	string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	//string = [[NSString alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];

	//LogDebug(@"%@", string);

	// Parse the JSon string
	tempArray = [[NSMutableArray alloc] initWithArray:[json objectWithString:string error:&error] copyItems:YES];
	
	[responseData release];
	
	// Check whether the parsing went smoothly
	if (error) {
		LogError(@"Erreur lors de la lecture du code JSON (%s).", [error localizedDescription]);
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"La récupération de la liste des incidents a échoué" 
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	} else {
		incidentsList = tempArray;
		[self.tableView reloadData];
	}
	// Stop the activity indicator
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	self.navigationItem.leftBarButtonItem = self.refreshButtonItem;
}

// Triggered when the view is about to appear
- (void)viewDidLoad {
    [super viewDidLoad];
	// Put a small button with a small + sign and the refresh button
	self.navigationItem.rightBarButtonItem = self.addButtonItem;
	self.navigationItem.leftBarButtonItem = self.refreshButtonItem;
	self.RESTAction = REST_ACTION_ALL;
	self.displayFormat = @"dd/MM HH:mm";
}

// Reload data when it can have been modified
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// Load the incident from the website
	[self initAndLaunchAsyncRequest];
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [incidentsList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Get the current incident
	NSDictionary *incident = [incidentsList objectAtIndex:indexPath.row];
	
	// Format date & time properly
	NSDateFormatter *dateFormater = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *date = [dateFormater dateFromString:[incident objectForKey:LAST_MODIFIED_TIME]];
	[dateFormater setDateFormat:self.displayFormat];

	// Build a new cell if needed
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	// Build a text string to display under the form : 25/02	Ligne 7
    NSString *incidentText = [[NSString alloc] initWithFormat:@"%@ \t %@", [dateFormater stringFromDate:date], [incident objectForKey:LINE]];
	
	// Put the string onto the cell
	cell.textLabel.text = incidentText;
	
	// Put a disclosure indicator at the right of the cell
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate
// Prepare for the display of an incident
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Init the detail view
    IncidentDetailViewController *detailViewController = [[IncidentDetailViewController alloc] initWithNibName:@"IncidentDetailViewController" bundle:nil];
	
	// Get the data that are to be diplayed
	detailViewController.incident = [[NSMutableDictionary alloc] initWithDictionary:[incidentsList objectAtIndex:indexPath.row] copyItems:YES];
	
	// Push the view of one incident
	[self.navigationController pushViewController:detailViewController animated:YES];
	
	// Release when we are over
	[detailViewController release];
}

// Prepare for the addition of a new incident
- (void)addButtonPressed:(id)sender {
	LogDebug(@"Add button pressed");
	// Create the add view dialog
	IncidentAddViewController *addViewController = [[IncidentAddViewController alloc] initWithNibName:@"IncidentAddViewController" bundle:nil];
	
	// Bind the view dialog to a freshly created navigation controller
	UINavigationController *addNavigationController = [[UINavigationController alloc] initWithRootViewController:addViewController];
	
	// Push the view for a new incident
	[self presentModalViewController:addNavigationController animated:YES];
}

- (IBAction) refreshButtonPressed: (id)sender{
	[self initAndLaunchAsyncRequest];
}

- (IBAction) cancelButtonPressed:(id)sender {
	[connection cancel];
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	self.navigationItem.leftBarButtonItem = self.refreshButtonItem;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
}

- (void)dealloc {
    [super dealloc];
	[incidentsList release];
	[addButtonItem release];
	[refreshButtonItem release];
	[cancelButtonItem release];
	[connection release];
	[RESTAction release];
}

@end
