//
//  ColonyViewController.h
//  ConwayGameOfLifeiPad
//
//  Created by Timothy Chong on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ColonyView;
@class Colony;
#import "CellListViewController.h"

@interface ColonyViewController : UIViewController<CellListViewDelegate>
{
    NSTimer *timer;
}
@property (retain, nonatomic) IBOutlet UIBarButtonItem *setting;
@property (retain, nonatomic) IBOutlet ColonyView *colonyView;
@property (retain, nonatomic) IBOutlet UILabel *generationLabel;
@property(retain,nonatomic) Colony* currentColony;
@property (retain, nonatomic) IBOutlet UISlider *slider;
@property (retain, nonatomic) IBOutlet UISwitch *wrapButton;

- (IBAction)changeWrapStatus:(id)sender;
- (IBAction)sliderChanged:(id)sender;
- (IBAction)setting:(id)sender;

@end
