//
//  ColonyStore.m
//  ConwayGameOfLifeiPad
//
//  Created by Timothy Chong on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ColonyStore.h"
#import "Colony.h"
static ColonyStore * defaultStore = nil;

@implementation ColonyStore
@synthesize currentIndex;

#pragma mark -singleton methods
+(ColonyStore*) defaultStore
{
    if (!defaultStore) {
        defaultStore = [[super alloc]init];
    }
    return defaultStore;
    
}

-(id)init
{
    if(defaultStore)
        return defaultStore;
    self = [super init];
    if (self) {
       
        NSArray * documentDirectories =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * documentDirectory = [documentDirectories objectAtIndex:0];
        NSString * directory = [documentDirectory stringByAppendingPathComponent:@"colonystore"];
        BOOL fileExists;
        fileExists = [[NSFileManager defaultManager] fileExistsAtPath:directory];
        if(fileExists)
        {
            NSLog(@"Retrieve File");
            allColonies = [[NSKeyedUnarchiver unarchiveObjectWithFile:directory]retain];
        }else {
            NSLog(@"File Doesn't Exist, %@",directory);
            
             allColonies = [[NSMutableArray alloc]init];
        Colony * newColony = [[Colony alloc]initColonyWithNumRow:45 NumCol:40];
            [allColonies addObject:newColony];
            [newColony setLabel:@"Colony 1"];
            [newColony release];
        
        }
        currentIndex = 0;
    }
    return self;
}

-(void)saveStore
{
    NSLog(@"Saving");
    NSArray * documentDirectories =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [documentDirectories objectAtIndex:0];
    NSString * directory = [documentDirectory stringByAppendingPathComponent:@"colonyStore"];
    BOOL fileExists;
    NSLog(@"%@",directory);
    fileExists = [[NSFileManager defaultManager] fileExistsAtPath:directory];
    [NSKeyedArchiver archiveRootObject:allColonies toFile:directory];
}

-(id)retain
{
    return defaultStore;  
}
-(oneway void) release
{
    
}
-(NSUInteger)retainCount
{
    return NSUIntegerMax;
}

-(NSArray*) allColonies
{
    return allColonies;
}

-(Colony*) currentColony
{
    return [allColonies objectAtIndex:currentIndex];
}
-(Colony *)addNewColonyWithRow:(int)row Column:(int)col
{
    Colony * newColony = [[Colony alloc]initColonyWithNumRow:row NumCol:col];
    [allColonies addObject:newColony];
    [newColony release];
    return newColony;
}

-(void)removeColony:(Colony *)c
{
    [allColonies removeObjectIdenticalTo:c];
}

-(void)moveColonyAtIndex:(int)from toIndex:(int)to
{
    if(from == to )
        return;
    Colony*a = [allColonies objectAtIndex:from];
    [a retain];
    [allColonies removeObjectIdenticalTo:a];
    [allColonies insertObject:a atIndex:to];
    [a release];
}

@end
