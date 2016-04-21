/*******************************************************************************
Copyright (c) Microsoft Open Technologies, Inc. All Rights Reserved.
Licensed under the MIT or Apache License; see LICENSE in the source repository
root for authoritative license information.﻿

**NOTE** This code was generated by a tool and will occasionally be
overwritten. We welcome comments and issues regarding this code; they will be
addressed in the generation tool. If you wish to submit pull requests, please
do so for the templates in that tool.

This code was generated by Vipr (https://github.com/microsoft/vipr) using
the T4TemplateWriter (https://github.com/msopentech/vipr-t4templatewriter).
******************************************************************************/

@class MSGraphServiceDeviceConfigurationOperations;

#import <office365_odata_base/office365_odata_base.h>
#import "MSGraphServiceModels.h"

/**
* The header for type MSGraphServiceDeviceConfigurationFetcher.
*/

@protocol MSGraphServiceDeviceConfigurationFetcher<MSODataEntityFetcher>

@optional

- (NSURLSessionTask *) readWithCallback:(void (^)(MSGraphServiceDeviceConfiguration *deviceConfiguration, MSODataException *exception))callback;
- (id<MSGraphServiceDeviceConfigurationFetcher>)addCustomParametersWithName:(NSString *)name value:(id)value;
- (id<MSGraphServiceDeviceConfigurationFetcher>)addCustomHeaderWithName:(NSString *)name value:(NSString *)value;
- (id<MSGraphServiceDeviceConfigurationFetcher>)select:(NSString *)params;
- (id<MSGraphServiceDeviceConfigurationFetcher>)expand:(NSString *)value;

@required

@property (copy, nonatomic, readonly) MSGraphServiceDeviceConfigurationOperations *operations;


@end

@interface MSGraphServiceDeviceConfigurationFetcher : MSODataEntityFetcher<MSGraphServiceDeviceConfigurationFetcher>

- (instancetype)initWithUrl:(NSString*)urlComponent parent:(id<MSODataExecutable>)parent;
- (NSURLSessionTask *) updateDeviceConfiguration:(MSGraphServiceDeviceConfiguration *)deviceConfiguration callback:(void (^)(MSGraphServiceDeviceConfiguration *deviceConfiguration, MSODataException *error))callback;
- (NSURLSessionTask *) deleteDeviceConfiguration:(void (^)(int status, MSODataException *exception))callback;

@end