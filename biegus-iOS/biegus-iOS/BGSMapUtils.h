//
//  BGSMapUtils.h
//  biegus-iOS
//
//  Created by Krystian Paszek on 13.05.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BGSMapUtils : NSObject

+ (MKCoordinateRegion)mapRegionForArrayOfLocations:(NSArray*)locations;
+ (MKOverlayRenderer *)rendererForOverlay:(id < MKOverlay >)overlay withColor:(UIColor*)color andLineWidth:(NSInteger)lineWidth;
+ (MKPolyline *)polyLineForArrayOfLocations:(NSArray*)locations;

@end
