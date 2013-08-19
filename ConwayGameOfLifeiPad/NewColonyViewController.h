//
//  NewColonyViewController.h
//  ConwayGameOfLifeiPad
//
//  Created by Timothy Chong on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewColonyViewController;
@class ColorPreviewView;
@protocol NewColonyViewDelegate <NSObject>

-(void) newColonyViewWillDismiss:(NewColonyViewController*) vc;

@end
@interface NewColonyViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic,retain) id<NewColonyViewDelegate> delegate;
@property (retain, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (retain, nonatomic) IBOutlet UITextField *rowTextField;
@property (retain, nonatomic) IBOutlet UITextField *columnsTextField;
@property (retain, nonatomic) IBOutlet UISlider *redSlider;
@property (retain, nonatomic) IBOutlet UISlider *greenSlider;
@property (retain, nonatomic) IBOutlet UISlider *blueSlider;
@property (retain, nonatomic) IBOutlet UISlider *opacitySlider;
@property (retain, nonatomic) IBOutlet ColorPreviewView *colorPreview;
- (IBAction)viewTouched:(id)sender;

@end
