//
//  cellListViewController.h
//  ConwayGameOfLifeiPad
//
//  Created by Timothy Chong on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewColonyViewController.h"
@class CellListViewController;
@protocol CellListViewDelegate <NSObject>

-(void) cellListViewWillDismiss:(CellListViewController*)cv;

@end


@interface CellListViewController : UITableViewController <NewColonyViewDelegate>
@property (nonatomic,retain)id<CellListViewDelegate>delegate;
@end
