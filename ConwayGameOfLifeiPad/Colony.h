//
//  Colony.h
//  ConwayGameOfLifeiPad
//
//  Created by Timothy Chong on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Colony : NSObject < NSCoding>
{
}

-(id) initColonyWithNumRow:(int)r NumCol:(int)c;
-(void) setCellAliveWithRow:(int)r Col:(int)c;
-(void) setCellDeadWithRow:(int)r Col:(int)c;
-(BOOL) isCellAliveWithRow:(int)r Col:(int)c;
-(int) countAdjectAliveCellsWithRow:(int)r Col:(int)c;
-(void) evolve;
-(void) reset;
-(NSString *) report;
-(NSString *) cellToAliveReport;
-(void) setRandomCells;
-(void) setCellsWithString:(NSString*) cellsString;


@property (nonatomic, assign) int numCol,numRow,generation;
@property (nonatomic, assign) BOOL wrapOn;
@property (nonatomic, assign) char ** cells;
@property (nonatomic, assign) char ** evolveCells;
@property (nonatomic, copy) NSString* label;
@property (nonatomic, retain) UIColor * color;

@end
