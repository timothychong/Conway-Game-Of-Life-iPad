//
//  cellListViewController.m
//  ConwayGameOfLifeiPad
//
//  Created by Timothy Chong on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cellListViewController.h"
#import "ColonyStore.h"
#import "Colony.h"
#import "NewColonyViewController.h"
#import "ColorPreviewView.h"
@interface CellListViewController ()

@end

@implementation CellListViewController

@synthesize delegate;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UIBarButtonItem * add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewColony:)];
        [[self navigationItem]setRightBarButtonItem:add];
        [add release];
        [[self navigationItem]setTitle:@"Colony List"];
        
        [[self navigationItem]setLeftBarButtonItem:[self editButtonItem]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setDelegate:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[ColonyStore defaultStore]allColonies]count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"]autorelease];
    }
    
    Colony* c = [[[ColonyStore defaultStore]allColonies]objectAtIndex:[indexPath row]];
    [[cell textLabel]setText:[c label]];
    [[cell textLabel]setFont:[UIFont systemFontOfSize:25]];
    [[cell textLabel]setTextColor:[c color]];
    [[cell detailTextLabel]setText:[NSString stringWithFormat:@"Rows: %d Columns: %d",[c numRow],[c numCol]]];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        Colony* colonyToBeRemoved = [[[ColonyStore defaultStore]allColonies]objectAtIndex:[indexPath row]];
        [[ColonyStore defaultStore] removeColony:colonyToBeRemoved];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
 
    [[ColonyStore defaultStore]moveColonyAtIndex:[fromIndexPath row] toIndex:[toIndexPath row]];
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    [self dismissModalViewControllerAnimated:YES];
    [[ColonyStore defaultStore]setCurrentIndex:[indexPath row]];
    [delegate cellListViewWillDismiss:self];
    
}
                                 
-(IBAction)addNewColony:(id)sender
{
    NewColonyViewController * newColonyVc = [[NewColonyViewController alloc]init];
    [[self navigationController]pushViewController:newColonyVc animated:YES];
    [newColonyVc setDelegate:self];
    [newColonyVc release];
}

-(void)newColonyViewWillDismiss:(NewColonyViewController *)vc
{
    [[self tableView]reloadData];
}

-(void)dealloc
{
    [delegate release];
    [super dealloc];
}
@end
