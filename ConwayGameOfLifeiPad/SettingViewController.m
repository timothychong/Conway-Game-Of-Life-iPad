//
//  SettingViewController.m
//  ConwayGameOfLifeiPad
//
//  Created by Timothy Chong on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "Colony.h"
#import "ColonyStore.h"
#import "ColorPreviewView.h"
#import "ColonyView.h"
#import "CellListViewController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize previewView;
@synthesize numberRows;
@synthesize numberColumns;
@synthesize scrollPreview;
@synthesize cellsPicker;
@synthesize descriptionTextField;
@synthesize generationTextField;
@synthesize sliderRed;
@synthesize sliderBlue;
@synthesize sliderGreen;
@synthesize sliderOpacity;
@synthesize cellTextView,colony,colorView,pickerLabels;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pickerLabels = [[NSArray alloc]initWithObjects:@"Custom",@"Random",@"Glider",@"Glider Gun",@"Spaceship",@"Pulsar", nil];
        UIBarButtonItem* list = [[UIBarButtonItem alloc]initWithTitle:@"Colonies" style:UIBarButtonItemStylePlain target:self action:@selector(changeColony)];
        [[self navigationItem] setRightBarButtonItem:list];
        [list release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [scrollPreview addSubview:previewView];
    //[scrollPreview setScrollEnabled:YES];
    [scrollPreview setContentSize:CGSizeMake(344, 386)];
    [scrollPreview setMinimumZoomScale:0.5];
    [scrollPreview setMaximumZoomScale:5];
    [scrollPreview setDelegate:self];
    [[self view] setBackgroundColor:[UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1]];
    sliderRed.transform= CGAffineTransformRotate(sliderRed.transform, 270.0/180*M_PI);
    sliderBlue.transform= CGAffineTransformRotate(sliderBlue.transform, 270.0/180*M_PI);
    sliderGreen.transform= CGAffineTransformRotate(sliderGreen.transform, 270.0/180*M_PI);
    sliderOpacity.transform= CGAffineTransformRotate(sliderOpacity.transform, 270.0/180*M_PI);
         [previewView setBackgroundColor:[UIColor  colorWithRed:0.875 green:0.9 blue:0.91 alpha:1]];
    [previewView updateColony];
    // Do any additional setup after loading the view from its nib.

}

- (void)viewDidUnload
{
    [self setCellTextView:nil];
    [self setDescriptionTextField:nil];
    [self setGenerationTextField:nil];
    [self setSliderRed:nil];
    [self setSliderBlue:nil];
    [self setSliderGreen:nil];
    [self setSliderOpacity:nil];
    [self setCellsPicker:nil];
    [self setPickerLabels:nil];
    [self setPreviewView:nil];
    [self setNumberRows:nil];
    [self setNumberColumns:nil];
    [self setScrollPreview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self viewTouched:nil];
    [super viewWillAppear:animated];
    [self updateAllCellsFromColony];
}

-(void) changeColony
{
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

-(void) updateAllCellsFromColony
{
    Colony* newC = [[ColonyStore defaultStore]currentColony];
    [self setColony:newC];
    [previewView updateColony];
    [cellTextView setText:[colony cellToAliveReport]];
    [descriptionTextField setText:[colony label]];
    [generationTextField setText:[NSString stringWithFormat:@"%d",[colony generation]]];
    UIColor * color = [colony color];
    float red,green,blue,opacity;
    [color getRed:&red green:&green blue:&blue alpha:&opacity];
    [sliderRed setValue:red];
    [sliderGreen setValue:green];
    [sliderBlue setValue:blue];
    [sliderOpacity setValue:opacity];
    [colorView setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:opacity]];
    [numberRows setText:[NSString stringWithFormat:@"%d",[colony numRow]]];
    [numberColumns setText:[NSString stringWithFormat:@"%d",[colony numCol]]];
    [previewView setNeedsDisplay];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self viewTouched:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

-(void)dealloc
{
    [cellTextView release];
    [colony release];
    [descriptionTextField release];
    [generationTextField release];
    [sliderRed release];
    [sliderBlue release];
    [sliderGreen release];
    [sliderOpacity release];
    [colorView release];
    [cellsPicker release];
    [pickerLabels release];
    [previewView release];
    [numberRows release];
    [numberColumns release];
    [scrollPreview release];
    [super dealloc];
}

- (IBAction)viewTouched:(id)sender {
    [colony setCellsWithString:[cellTextView text]];
    [colony setLabel:[descriptionTextField text]];
    [colony setGeneration: [[generationTextField text]intValue]];
    [self updateAllCellsFromColony];
    [[self view]endEditing:YES];
}

- (IBAction)revertCells:(id)sender {
    [cellTextView setText:[colony cellToAliveReport]];
    [self updateAllCellsFromColony];
    [[self view]endEditing:YES];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == generationTextField)
    {
        NSString* str = [[generationTextField text]stringByReplacingCharactersInRange:range withString:string];
        int holder;
        NSScanner *scan = [NSScanner scannerWithString:str];
        return ([scan scanInt:&holder]&&[scan isAtEnd]) || [[scan string]isEqualToString:@""];
    }
    return YES;
}

- (IBAction)clearCells:(id)sender {
    [colony reset];
    [self updateAllCellsFromColony];
}

- (IBAction)sliderChanged:(id)sender {
    float red = [sliderRed value];
    float green = [sliderGreen value];
    float blue = [sliderBlue value];
    float opacity = [sliderOpacity value];
    UIColor * newColor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:opacity];
    [colony setColor:newColor];
    [newColor release];
     [colorView setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:opacity]];
    [previewView setNeedsDisplay];
}

- (IBAction)resetGeneration:(id)sender {
    [generationTextField setText:@"0"];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerLabels objectAtIndex:row];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
     return [pickerLabels count];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (row) {
        case 1:
            [colony setRandomCells];
            [self updateAllCellsFromColony];
            break;
        case 2:
            [cellTextView setText:@"0 1\n1 2\n2 0\n2 1\n2 2"];
            [colony setWrapOn:NO];
            break;
        case 3:
            if([colony numCol] < 38 || [colony numRow] < 12)
                [self patternNotForSize];
            else {
                [colony setWrapOn:NO];
             [cellTextView setText:@"5 1\n6 1\n6 2\n5 2\n3 13\n3 14\n4 12\n4 16\n5 11\n5 17\n6 11\n6 15\n6 17\n6 18\n7 11\n7 17\n8 12\n8 16\n9 13\n9 14\n3 21\n4 21\n5 21\n3 22\n4 22\n5 22\n2 23\n6 23\n1 25\n2 25\n6 25\n7 25\n3 35\n3 36\n4 35\n4 36\n"];
            }
            break;
        case 4:
        if([colony numCol] < 7 || [colony numRow] < 6)
            [self patternNotForSize];
        else {
                [cellTextView setText:@"0 0\n0 3\n1 4\n2 0\n2 4\n3 1\n3 2\n3 3\n3 4"];
            [colony setWrapOn:YES];
        }
            break;
        case 5:
            if([colony numCol] < 16 || [colony numRow] < 16)
                [self patternNotForSize];
            else {
            [cellTextView setText:@"1 3\n1 4\n1 5\n1 9\n1 10\n3 1\n1 11\n3 6\n3 8\n3 13\n4 1\n4 6\n4 8\n4 13\n5 1\n5 6\n5 8\n5 13\n6 3\n6 4\n6 5\n6 9\n6 10\n6 11\n8 3\n8 4\n8 5\n8 9\n8 10\n8 11\n9 1\n9 6\n9 8\n9 13\n10 1\n10 6\n10 8\n10 13\n11 1\n11 6\n11 8\n10 13\n11 1\n11 6\n11 8\n11 13\n13 3\n13 4\n13 5\n13 9\n13 10\n13 11"];
            }
        default:
            break;
    }
    [self viewTouched:nil];
}

-(void) patternNotForSize
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Pattern not applicable for the size of colony" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    [cellsPicker selectRow:0 inComponent:0 animated:YES];
   
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [colony setGeneration:0];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [cellsPicker selectRow:0 inComponent:0 animated:YES];
}
-(void)cellListViewWillDismiss:(CellListViewController *)cv
{
    [self viewWillAppear:YES];
    [cellsPicker selectRow:0 inComponent:0 animated:YES];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return previewView;
}
@end
