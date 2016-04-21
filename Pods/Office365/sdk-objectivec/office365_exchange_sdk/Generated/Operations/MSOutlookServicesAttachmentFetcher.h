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

@class MSOutlookServicesFileAttachmentFetcher;
@class MSOutlookServicesItemAttachmentFetcher;
@class MSOutlookServicesAttachmentOperations;

#import <office365_odata_base/office365_odata_base.h>
#import "MSOutlookServicesModels.h"

/**
* The header for type MSOutlookServicesAttachmentFetcher.
*/

@protocol MSOutlookServicesAttachmentFetcher<MSODataEntityFetcher>

@optional

- (NSURLSessionTask *) readWithCallback:(void (^)(MSOutlookServicesAttachment *attachment, MSODataException *exception))callback;
- (id<MSOutlookServicesAttachmentFetcher>)addCustomParametersWithName:(NSString *)name value:(id)value;
- (id<MSOutlookServicesAttachmentFetcher>)addCustomHeaderWithName:(NSString *)name value:(NSString *)value;
- (id<MSOutlookServicesAttachmentFetcher>)select:(NSString *)params;
- (id<MSOutlookServicesAttachmentFetcher>)expand:(NSString *)value;

@required

@property (copy, nonatomic, readonly) MSOutlookServicesAttachmentOperations *operations;

- (MSOutlookServicesFileAttachmentFetcher *)asFileAttachment;	
- (MSOutlookServicesItemAttachmentFetcher *)asItemAttachment;	

@end

@interface MSOutlookServicesAttachmentFetcher : MSODataEntityFetcher<MSOutlookServicesAttachmentFetcher>

- (instancetype)initWithUrl:(NSString*)urlComponent parent:(id<MSODataExecutable>)parent;
- (NSURLSessionTask *) updateAttachment:(MSOutlookServicesAttachment *)attachment callback:(void (^)(MSOutlookServicesAttachment *attachment, MSODataException *error))callback;
- (NSURLSessionTask *) deleteAttachment:(void (^)(int status, MSODataException *exception))callback;

@end