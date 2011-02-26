//
//  RootViewController.m
//  iMLate
//
//  Created by Benoît Clouet on 25/02/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import "RootViewController.h"
#import "JSON.h"
#import "IncidentDetailViewController.h"

@implementation RootViewController

@synthesize incidentsList, addButtonItem;
#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.addButtonItem;
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://incidents-ratp.com/api/incident"]
										cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:60.0];
	[theRequest setHTTPMethod:@"GET"];
	
	NSURLResponse *theResponse;


	NSError *error;
	NSData *result = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];

	//NSString *string = @"[{\"reason\": \"AAA\", \"line\": {\"name\": \"RER B\"}, \"time\": \"2011-02-25 08:05:01\"}, {\"reason\": \"BBB\", \"line\": {\"name\": \"RER B\"}, \"time\": \"2011-02-25 11:08:16\"}, {\"reason\": \"CCC\", \"line\": {\"name\": \"Metro 13\"},\"time\": \"2011-02-25 11:11:48\"}, {\"reason\": \"DDD\", \"line\": {\"name\": \"Metro 7\"},	\"time\": \"2011-02-25 22:17:20\"}, {	\"reason\": \"EEE\", 	\"line\": {	\"name\": \"RER C\"	}, 	\"time\": \"2011-02-25 23:53:24\"    }]";	
	NSString *string = [[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"%@", string);
	

	SBJsonParser *json = [SBJsonParser new];
	
	incidentsList = [[NSMutableArray alloc] initWithArray:[json objectWithString:string error:&error] copyItems:YES];
	
	if (incidentsList == nil) {
		
		NSLog(@"Erreur lors de la lecture du code JSON (%@).", [error localizedDescription]);
		
	} else {
		
		for (NSDictionary *incident in incidentsList) {
			
			NSLog(@"\tTime=%@ et Line=%@\nReason=%@\n", [incident objectForKey:@"time" ],
				  [[incident objectForKey:@"line"] objectForKey:@"name"], 
				  [incident objectForKey:@"reason" ]);
			
		}
		
	}

}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


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
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSDictionary *incident = [incidentsList objectAtIndex:indexPath.row];
	
	NSDateFormatter *dateFormater = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *date = [dateFormater dateFromString:[incident objectForKey:@"time"]];
	[dateFormater setDateFormat:@"dd/MM HH:mm"];
	
    NSString *incidentText = [[NSString alloc] initWithFormat:@"%@ \t %@", [dateFormater stringFromDate:date], [[incident objectForKey:@"line"] objectForKey:@"name"]];
	cell.textLabel.text = incidentText;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IncidentDetailViewController *detailViewController = [[IncidentDetailViewController alloc] initWithNibName:@"IncidentDetailViewController" bundle:nil];
	detailViewController.incident = [incidentsList objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}

- (void)addButtonPressed:(id)sender {
	NSLog(@"Button pressed");
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[incidentsList release];
	[addButtonItem release];
}


@end

