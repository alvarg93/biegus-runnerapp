//
//  BGSMapUtils.m
//  biegus-iOS
//
//  Created by Krystian Paszek on 13.05.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import "BGSMapUtils.h"

@implementation BGSMapUtils

+ (MKCoordinateRegion)mapRegionForArrayOfLocations:(NSArray*)locations
{
    MKCoordinateRegion region;
//    NSArray *locations = [self.locationManager recordedRun];
    CLLocation *initialLoc = locations.firstObject;
    
    float minLat = (float)initialLoc.coordinate.latitude;
    float minLng = (float)initialLoc.coordinate.longitude;
    float maxLat = (float)initialLoc.coordinate.latitude;
    float maxLng = (float)initialLoc.coordinate.longitude;
    
    for (CLLocation *location in locations) {
        if ((float)location.coordinate.latitude < minLat) {
            minLat = (float)location.coordinate.latitude;
        }
        if ((float)location.coordinate.longitude < minLng) {
            minLng = (float)location.coordinate.longitude;
        }
        if ((float)location.coordinate.latitude > maxLat) {
            maxLat = (float)location.coordinate.latitude;
        }
        if ((float)location.coordinate.longitude > maxLng) {
            maxLng = (float)location.coordinate.longitude;
        }
    }
    
    region.center.latitude = (minLat + maxLat) / 2.0f;
    region.center.longitude = (minLng + maxLng) / 2.0f;
    
    region.span.latitudeDelta = (maxLat - minLat) * 1.3f; // 30% padding
    region.span.longitudeDelta = (maxLng - minLng) * 1.3f; // 30% padding
    
    return region;
}


+ (MKPolyline *)polyLineForArrayOfLocations:(NSArray*)locations {
//    NSArray *locations = self.locationManager.recordedRun;
    NSInteger count = locations.count;
    CLLocationCoordinate2D coords[count];
    
    for (int i = 0; i < count; i++) {
        CLLocation *location = [locations objectAtIndex:i];
        coords[i] = location.coordinate;
    }
    
    return [MKPolyline polylineWithCoordinates:coords count:count];
}

+ (MKOverlayRenderer *)rendererForOverlay:(id < MKOverlay >)overlay withColor:(UIColor*)color andLineWidth:(NSInteger)lineWidth;
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = color;//[UIColor blueColor];
        aRenderer.lineWidth = lineWidth;//5;
        return aRenderer;
    }
    
    return nil;
}

@end
