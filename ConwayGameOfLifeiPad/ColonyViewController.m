//
//  ColonyViewController.m
//  ConwayGameOfLifeiPad
//
//  Created by Timothy Chong on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ColonyViewController.h"
#import "ColonyView.h"
#import "ColonyStore.h"
#import "Colony.h"
#import "SettingViewController.h"
#import "cellListViewController.h"
@interface ColonyViewController ()
@end
@implementation ColonyViewController
@synthesize slider;
@synthesize wrapButton;
@synthesize setting;
@synthesize colonyView;
@synthesize generationLabel;
@synthesize currentColony;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem* set = [[UIBarButtonItem alloc]initWithTitle:@"Setting" style: UIBarButtonItemStylePlain target:self action:@selector(setting:)];
        [[self navigationItem]setRightBarButtonItem:set];
        [set release];
        [[self navigationItem]setTitle:@"Conway Game Of Life iPad"];
        UIBarButtonItem* list = [[UIBarButtonItem alloc]initWithTitle:@"Colonies" style:UIBarButtonItemStylePlain target:self action:@selector(changeColony)];
        [[self navigationItem] setLeftBarButtonItem:list];
        [list release];
    } 
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view]setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    [colonyView setBackgroundColor:[UIColor  colorWithRed:0.875 green:0.9 blue:0.91 alpha:1]];
    [generationLabel setText:[NSString stringWithFormat:@"%d",[currentColony generation]]];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setSetting:nil];
    [self setColonyView:nil];
    [self setSlider:nil];
    [self setGenerationLabel:nil];
    [self setCurrentColony:nil];

    [self setWrapButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self sliderChanged:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
     [self updateColony];
    [super viewWillAppear:animated];
    [colonyView setNeedsDisplay];
    [generationLabel setText:[NSString stringWithFormat:@"%d",[currentColony generation]]];
    [wrapButton setOn:[currentColony wrapOn] animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
    timer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

#pragma mark -buttons


- (IBAction)evolveOnce:(id)sender {
    [currentColony evolve];
     [generationLabel setText:[NSString stringWithFormat:@"%d",[currentColony generation]]];
    [colonyView setNeedsDisplay];
}

- (IBAction)changeWrapStatus:(id)sender {
    if([sender isOn])
        [[[ColonyStore defaultStore]currentColony]setWrapOn:YES];
    else
        [[[ColonyStore defaultStore]currentColony]setWrapOn:NO];
}

- (IBAction)sliderChanged:(id)sender {
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    if([slider value] != 0)
    {double num = (1-[slider value])/10;
    timer = [NSTimer scheduledTimerWithTimeInterval:num+.01 target:self selector:@selector(evolveOneGeneration) userInfo:nil repeats:YES];
    }
}
-(void) evolveOneGeneration
{
    [[[ColonyStore defaultStore]currentColony]evolve];
    [generationLabel setText:[NSString stringWithFormat:@"%d",[currentColony generation]]];
    [colonyView setNeedsDisplay];
}

-(IBAction)setting:(id)sender
{
    SettingViewController* settingView = [[SettingViewController alloc]init];
    [[self navigationController] pushViewController:settingView animated:YES];
    [settingView release];
        /*
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You need to have at least one colony available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
         */
}

- (void)dealloc {
    [setting release];
    [colonyView release];
    [slider release];
    [generationLabel release];
    [currentColony release];
    [wrapButton release];
    [super dealloc];
}

-(void) changeColony
{
    [timer invalidate];
    timer = nil;
    CellListViewController * cellListCv = [[CellListViewController alloc]init];
    UINavigationController * navCv = [[UINavigationController alloc]initWithRootViewController:cellListCv];
    [cellListCv setDelegate:self];
    [cellListCv release];
    [navCv setModalPresentationStyle:UIModalPresentationPageSheet];
    [navCv setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:navCv animated:YES];
    navCv.view.superview.autoresizingMask = 
    UIViewAutoresizingFlexibleTopMargin | 
    UIViewAutoresizingFlexibleBottomMargin;    
    navCv.view.superview.frame = CGRectMake(navCv.view.superview.frame.origin.x,navCv.view.superview.frame.origin.y,540.0,529.0);
    navCv.view.superview.center = self.view.center;
    [navCv release];
}

-(void)updateColony
{
    Colony* c = [[ColonyStore defaultStore]currentColony];
    [self setCurrentColony:c];
    [colonyView updateColony];

}

-(void)cellListViewWillDismiss:(CellListViewController *)cv
{
    [slider setValue:0];
    [self viewWillAppear:YES];
    
}

@end
