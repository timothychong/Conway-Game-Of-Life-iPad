//
//  Colony.m
//  ConwayGameOfLifeiPad
//
//  Created by Timothy Chong on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Colony.h"

@implementation Colony
@synthesize numCol,numRow,wrapOn,generation,cells,evolveCells,label,color;

#pragma mark -initialization
-(id)init
{
    @throw [NSException exceptionWithName:@"WrongInitializer" reason:@"Should Call initColony" userInfo:nil];
    return nil;
}
-(id) initColonyWithNumRow:(int)r NumCol:(int)c
{
    self = [super init];
    if (self) {        
        [self setNumCol:c];
        [self setNumRow:r];
        [self setGeneration:0];
        [self setWrapOn:YES];
        cells = (char**)malloc(r*sizeof(char*));
        for (int a = 0; a < r; a++) {
            cells[a] = (char*)malloc(c*sizeof(char));
        }
        evolveCells = (char**)malloc((r+2)*sizeof(char*));
        for (int a = 0; a < r+2 ; a++) {
            evolveCells[a] = (char*)malloc((c+2)*sizeof(char));
        }
        color = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:1];
        [self reset];
    }
    
    return self;
}

#pragma mark -changeCellsStatus
-(void) setCellAliveWithRow:(int)r Col:(int)c
{
    cells[r][c] = 1;
}
-(void) setCellDeadWithRow:(int)r Col:(int)c
{
    cells[r][c] = 0;
}
-(int) countAdjectAliveCellsWithRow:(int)r Col:(int)c
{
    int count = evolveCells[r-1][c-1]+evolveCells[r+1][c-1]+evolveCells[r][c-1]+evolveCells[r-1][c]+evolveCells[r+1][c]+evolveCells[r-1][c+1]+evolveCells[r+1][c+1]+evolveCells[r][c+1];
    return count;
}

-(BOOL) isCellAliveWithRow:(int)r Col:(int)c
{
    if(cells[r][c] == 0)
        return NO;
    else 
        return YES;
}

-(void) reset
{
    for(int a = 0; a < numRow;a++)
        for(int b = 0; b < numCol; b++)
            cells[a][b] = 0;
    
    for(int c = 0; c < numRow+2 ;c++)
        for(int d = 0; d < numCol+2 ; d++)
            evolveCells[c][d] = 0;
}



#pragma mark -Others
-(void) evolve
{
    generation++;
    for(int c = 0; c < numRow+2 ;c++)
        for(int d = 0; d < numCol+2 ; d++)
            evolveCells[c][d] = 0;
    [self setWrap];
    
    for(int a = 0; a< numRow; a++)
        for(int b = 0; b < numCol; b++)
        {
            switch([self countAdjectAliveCellsWithRow:a+1 Col:b+1])
            {
                case 2:break;
                case 3:cells[a][b] = 1;break;
                default:cells[a][b] = 0;break;
            }
        }
    
    
}
-(void) setWrap
{
    for(int a = 0; a< numRow; a++)
        for(int b = 0; b < numCol; b++)
            evolveCells[a+1][b+1] = cells[a][b];
   if(wrapOn)
   {
        for(int a = 0; a< numRow; a++)
        {
            evolveCells[a+1][0] = cells[a][numCol-1];
            evolveCells[a+1][numCol+1] = cells[a][0];
        }
        for (int b = 0; b < numCol; b++) {
            evolveCells[0][b+1] = cells[numRow-1][b];
            evolveCells[numRow+1][b+1] = cells[0][b];
        }
        evolveCells[0][0] = cells[numRow-1][numCol-1];
        evolveCells[0][numCol+1] = cells[numRow-1][0];
        evolveCells[numRow+1][0] = cells[0][numCol-1];
        evolveCells[numRow+1][numCol+1] = cells[0][0];
   }
}

-(void)setRandomCells
{
    for(int a = 0 ; a<numRow; a++)
    {
        for(int b =0; b<numCol; b++)
        {
            int c = rand() % 2;
            cells[a][b] = c;
        }
    }
}
-(NSString *) report
{
    NSMutableString* str = [[NSMutableString alloc]init];    
    [str appendFormat:@"\n\nGenertion # %d\n",generation];
    for(int a = 0; a < numRow;a++)
    {
        for(int b = 0; b < numCol; b++)
            if(cells[a][b] == 0)
                [str appendString:@"0"];
            else 
                [str appendString:@"1"];
        [str appendString:@"\n"];
    }
    [str appendString:@"\n"];
    return [str autorelease];
}

-(NSString *)cellToAliveReport
{
    NSMutableString * str = [[NSMutableString alloc]init];
    for(int a = 0; a < numRow;a++)
    {
        for(int b = 0; b < numCol; b++)
        {
            if(cells[a][b] == 1)
                [str appendFormat:@"%d %d\n",a,b];                 
        }
    }
    return [str autorelease];
}

-(void) setCellsWithString:(NSString*) cellsString
{
    [self reset];
    NSScanner *scan = [[NSScanner alloc]initWithString:cellsString];
    NSString* temp=[[NSString alloc]init];
    NSCharacterSet *seperator = [NSCharacterSet characterSetWithCharactersInString:@" "];
    NSCharacterSet *seperator1 = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
    while(![scan isAtEnd])
    {
        [scan scanUpToCharactersFromSet:seperator intoString:&temp];
        int a = [temp intValue];
        [scan scanUpToCharactersFromSet:seperator1 intoString:&temp];
        int b = [temp intValue];
        if(a >= 0 && a < numRow && b >= 0 && b < numCol)
        cells[a][b] = 1;
    }
    [scan release];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    NSString * saveStr = [[NSString alloc]initWithFormat:@"%@",[self cellToAliveReport]];
    [aCoder encodeObject:saveStr forKey:@"colonyCell"];
    [aCoder encodeInt:generation forKey:@"generation"];
    [aCoder encodeInt:numCol forKey:@"column"];
    [aCoder encodeInt:numRow forKey:@"row"];
    [aCoder encodeBool:wrapOn forKey:@"wrapOn"];
    [aCoder encodeObject:label forKey:@"label"];
    [aCoder encodeObject:color forKey:@"color"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setGeneration:[aDecoder decodeIntForKey:@"generation"]];
        [self setNumCol:[aDecoder decodeIntForKey:@"column"]];
        [self setNumRow:[aDecoder decodeIntForKey:@"row"]];
        [self setWrapOn:[aDecoder decodeBoolForKey:@"wrapOn"]];
        [self setLabel:[aDecoder decodeObjectForKey:@"label"]];
        NSString* str = [aDecoder decodeObjectForKey:@"colonyCell"];
        [self setColor:[aDecoder decodeObjectForKey:@"color"]];
        int c = [self numCol];
        int r = [self numRow];
        cells = (char**)malloc(r*sizeof(char*));
        for (int a = 0; a < r; a++) {
            cells[a] = (char*)malloc(c*sizeof(char));
        }
        evolveCells = (char**)malloc((r+2)*sizeof(char*));
        for (int a = 0; a < r+2 ; a++) {
            evolveCells[a] = (char*)malloc((c+2)*sizeof(char));
        }
        [self setCellsWithString:str];
        
    }
    return self;
}

-(void)dealloc
{
    for (int a = 0; a < numRow; a++) {
        free(cells[a]);
    }
    for (int a = 0; a < numRow+2 ; a++) {
        free(evolveCells[a]); 
    }
    
    free(cells);
    free(evolveCells);
    [label release];
    [color release];
    [super dealloc];   
}



@end
