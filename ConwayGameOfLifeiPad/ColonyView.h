//
//  ColonyView.h
//  ConwayGameOfLifeiPad
//
//  Created by Timothy Chong on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Colony;
@interface ColonyView : UIView
-(void) updateColony;
@property (nonatomic,retain) Colony* colony;
@property (nonatomic,assign) int col, row;
@property (nonatomic,assign)double incX,incY;
@property (nonatomic,assign) BOOL setCellAlive;
@end
