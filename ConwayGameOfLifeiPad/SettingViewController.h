//
//  SettingViewController.h
//  ConwayGameOfLifeiPad
//
//  Created by Timothy Chong on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Colony;
@class ColorPreviewView;
@class ColonyView;
#import "CellListViewController.h"
@interface SettingViewController : UIViewController <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,CellListViewDelegate>
@property (nonatomic,retain) Colony * colony;
@property (retain, nonatomic) IBOutlet UITextView *cellTextView;
@property (retain, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (retain, nonatomic) IBOutlet UITextField *generationTextField;
@property (retain, nonatomic) IBOutlet UISlider *sliderRed;
@property (retain, nonatomic) IBOutlet UISlider *sliderBlue;
@property (retain, nonatomic) IBOutlet UISlider *sliderGreen;
@property (retain, nonatomic) IBOutlet UISlider *sliderOpacity;
@property (retain, nonatomic) IBOutlet ColorPreviewView *colorView;
@property (retain, nonatomic) IBOutlet UIPickerView *cellsPicker;
@property (retain,nonatomic) NSArray * pickerLabels;
@property (retain, nonatomic) IBOutlet ColonyView *previewView;
@property (retain, nonatomic) IBOutlet UILabel *numberRows;
@property (retain, nonatomic) IBOutlet UILabel *numberColumns;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollPreview;
- (IBAction)clearCells:(id)sender;
- (IBAction)sliderChanged:(id)sender;
- (IBAction)resetGeneration:(id)sender;
- (IBAction)viewTouched:(id)sender;
- (IBAction)revertCells:(id)sender;

@end
