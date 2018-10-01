//
//  AWFCombinedSource.h
//  AerisMap
//
//  Created by Nicholas Shipes on 8/14/14.
//  Copyright (c) 2014 AerisWeather, LLC. All rights reserved.
//

#import <AerisMapKit/AWFPointSource.h>

@class AWFDataRepresentableStyle;

/**
 An `AWFCombinedSource` object represents a data source that manages a combination of different overlays on a map. Specifically, this layer type
 manages annotations, overlays, polygons and polylines needed to display a specific data layer.
 */
@interface AWFCombinedSource : AWFPointSource

/**
 The overlays being managed by the source (readonly).
 */
@property (readonly, nonatomic, strong) NSArray *overlays;

/**
 The polygons being managed by the source (readonly).
 */
@property (readonly, nonatomic, strong) NSArray *polygons;

/**
 The polylines being managed by the source (readonly).
 */
@property (readonly, nonatomic, strong) NSArray *polylines;

/**
 The style to apply to the source's overlays.
 */
@property (nonatomic, strong) id overlayStyle;

@property (nonatomic, strong) AWFDataRepresentableStyle *styleProvider;

/**
 An array of animations associated with the content source. For combined sources, each map data representable type will have its own animation instance for
 managing the rendering of data for that map representable type.
 */
@property (nonatomic, strong, nullable) NSArray<AWFAnimation *> *animations;

@property (nonatomic, assign) BOOL showAnnotationsDuringAnimation;
@property (nonatomic, assign) BOOL showOverlaysDuringAnimation;
@property (nonatomic, assign) BOOL showPolygonsDuringAnimation;
@property (nonatomic, assign) BOOL showPolylinesDuringAnimation;

/**
 Returns a single overlay representing a set of objects on the map based on a specific group identifier.
 
 @param identifier The group identifier to return an overlay for.
 @return Returns a single map overlay object, which varies depending on the map strategy being used.
 */
- (NSArray *)overlayForIdentifier:(NSString *)identifier;

/**
 Returns an array of polygons representing a set of objects on the map based on a specific group identifier.
 
 @param identifier The group identifier to return polygons for.
 @return Returns an array of map polygon objects, which varies depending on the map strategy being used.
 */
- (NSArray *)polygonsForIdentifier:(NSString *)identifier;

/**
 Returns an array of polylines representing a set of objects on the map based on a specific group identifier.
 
 @param identifier The group identifier to return polylines for.
 @return Returns an array of map polyline objects, which varies depending on the map strategy being used.
 */
- (NSArray *)polylinesForIdentifier:(NSString *)identifier;

@end
