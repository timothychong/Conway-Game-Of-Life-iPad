//
//  NewColonyViewController.m
//  ConwayGameOfLifeiPad
//
//  Created by Timothy Chong on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewColonyViewController.h"
#import "ColonyStore.h"
#import "ColorPreviewView.h"
#import "Colony.h"
@interface NewColonyViewController ()

@end

@implementation NewColonyViewController
@synthesize delegate;
@synthesize descriptionTextField;
@synthesize rowTextField;
@synthesize columnsTextField;
@synthesize redSlider;
@synthesize greenSlider;
@synthesize blueSlider;
@synthesize opacitySlider;
@synthesize colorPreview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem * doneItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
        [[self navigationItem] setRightBarButtonItem:doneItem];
        [doneItem release];
        
        UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        [[self navigationItem] setLeftBarButtonItem:cancelItem];
        [cancelItem release];
        
        [[self navigationItem] setTitle:@"Create New Colony"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [colorPreview setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    [descriptionTextField setText:[NSString stringWithFormat:@"Colony %d", [[[ColonyStore defaultStore]allColonies]count]+1]];
    
   
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setDescriptionTextField:nil];
    [self setRowTextField:nil];
    [self setColumnsTextField:nil];
    [self setRedSlider:nil];
    [self setGreenSlider:nil];
    [self setBlueSlider:nil];
    [self setOpacitySlider:nil];
    [self setColorPreview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)sliderChanged:(id)sender {
    
    float red = [redSlider value];
    float green = [greenSlider value];
    float blue = [blueSlider value];
    float opacity = [opacitySlider value];
    [colorPreview setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:opacity]];
    [colorPreview setNeedsDisplay];
}


-(IBAction)cancel:(id)sender
{
    [[self navigationController]popViewControllerAnimated:YES];
}

-(IBAction)save:(id)sender
{
    Colony * newC= [[ColonyStore defaultStore]addNewColonyWithRow:[[rowTextField text]intValue] Column:[[columnsTextField text]intValue]];
    [newC setLabel:[descriptionTextField text]];
    float red = [redSlider value];
    float green = [greenSlider value];
    float blue = [blueSlider value];
    float opacity = [opacitySlider value];
    [newC setColor:[UIColor colorWithRed:red green:green blue:blue alpha:opacity]];
    [[self navigationController]popViewControllerAnimated:YES];
    [delegate newColonyViewWillDismiss:self];
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == descriptionTextField)
    {
    }else if(textField == rowTextField)
    {
        int a = [[rowTextField text]intValue];
        if(a < 5 || a > 100)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Row Number can only be between 5 and 100" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            [textField setText:@"45"];
        }
    }else if (textField == columnsTextField) {
        int b = [[columnsTextField text]intValue];
        if(b < 5 || b > 100)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Column Number can only be between 5 and 100" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            [textField setText:@"40"];
        }

    }
}

-(void)dealloc
{
    [delegate release];
    [descriptionTextField release];
    [rowTextField release];
    [columnsTextField release];
    [redSlider release];
    [greenSlider release];
    [blueSlider release];
    [opacitySlider release];
    [colorPreview release];
    [super dealloc];
}



- (IBAction)viewTouched:(id)sender {
    [[self view]endEditing:YES];
}
@end
