//
//  CALayer+XibConfiguration.m
//  biegus-iOS
//
//  Created by Krystian Paszek on 23.04.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}


@end
