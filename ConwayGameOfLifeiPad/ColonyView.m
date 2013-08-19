//
//  ColonyView.m
//  ConwayGameOfLifeiPad
//
//  Created by Timothy Chong on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ColonyView.h"
#import "ColonyStore.h"
#import "Colony.h"
@implementation ColonyView
@synthesize colony,col,row,incX,incY,setCellAlive;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)updateColony
{
    Colony* c = [[ColonyStore defaultStore]currentColony];
    [self setColony:c];
    [self setRow:[c numRow]];
    [self setCol:[c numCol]];
    incX = (double)([self bounds].size.width-10)/col;
    incY = (double)([self bounds].size.height-10)/row;
   

}

-(void)drawRect:(CGRect)rect
{
    CGRect bounds = [self bounds];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint sides[5];
    sides[0].x = 0; sides[0].y = 0;
    sides[1].x = 0; sides[1].y = bounds.size.height;
    sides[2].x = bounds.size.width; sides[2].y = bounds.size.height;
    sides[3].x = bounds.size.width; sides[3].y = 0;
    sides[4].x = 0; sides[4].y = 0;
    [[UIColor purpleColor]setStroke];
    
    CGContextSetLineWidth(context,10);
    CGContextAddLines(context, sides, 5);
    CGContextStrokePath(context);
    
    CGRect rectangle;
    CGSize s; s.height = incY-3; s.width=incX-3;
    rectangle.size = s;
    if(colony)
    {
        for(int a = 0; a < row; a++)
        {
            for(int b = 0; b < col ; b++)
            {
                if([colony isCellAliveWithRow:a Col:b])
                {
                    CGPoint p; 
                    p.x = 6.5 + b*incX; 
                    p.y = 6.5 + a*incY;
                    rectangle.origin = p;
                    [[colony color]setFill];
                    CGContextFillRect(context, rectangle);
                }
            }
        }

    }
    
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for( UITouch *t in touches)
    {
        CGPoint loc = [t locationInView:self];
        CGRect bounds = [self bounds];
        
        if( loc.x <=bounds.size.width-5 && loc.x >=5 &&loc.y <=bounds.size.height-5 &&loc.y >= 5)
        {
            int x = (int)(((loc.x-6.5) / incX));
            int y = (int)(((loc.y-6.5) / incY));
            if((x < col && y< row))
            {
                setCellAlive = ![colony isCellAliveWithRow:y Col:x];
                if(setCellAlive)
                    [colony setCellAliveWithRow:y Col:x];
                else 
                    [colony setCellDeadWithRow:y Col:x];
                
            }else 
                printf("Cell out of range: %d, %d",x,y);
            [self setNeedsDisplay];
        }
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for( UITouch *t in touches)
    {
        CGPoint loc = [t locationInView:self];
        CGRect bounds = [self bounds];
        
        if( loc.x <=bounds.size.width-5 && loc.x >=5 &&loc.y <=bounds.size.height-5 &&loc.y >= 5)
        {
            int x = (int)(((loc.x-6.5) / incX));
            int y = (int)(((loc.y-6.5) / incY));
            if((x < col && y< row))
            {
                if(setCellAlive)
                    [colony setCellAliveWithRow:y Col:x];
                else 
                    [colony setCellDeadWithRow:y Col:x];
            }else 
                printf("Cell out of range: %d, %d",x,y);
            [self setNeedsDisplay];
        }
    }
}

-(void)dealloc
{
    [colony release];
    [super dealloc];
}



@end
