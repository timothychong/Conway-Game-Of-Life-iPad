//
//  ColonyStore.h
//  ConwayGameOfLifeiPad
//
//  Created by Timothy Chong on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Colony;
@interface ColonyStore : NSObject
{
    NSMutableArray * allColonies;
}

+(ColonyStore*) defaultStore;
-(Colony*) currentColony;
-(NSArray*) allColonies;
-(Colony*) addNewColonyWithRow:(int)row Column:(int)col;
-(void) removeColony:(Colony*) c;
-(void) moveColonyAtIndex:(int) from toIndex:(int)to;
-(void)saveStore;

@property (nonatomic,assign) int currentIndex;

@end
