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

@class MSOutlookServicesAttachmentFetcher;
@class MSOutlookServicesAttachmentCollectionFetcher;
@class MSOutlookServicesEventMessageFetcher;
@class MSOutlookServicesMessageOperations;

#import <office365_odata_base/office365_odata_base.h>
#import "MSOutlookServicesModels.h"

/**
* The header for type MSOutlookServicesMessageFetcher.
*/

@protocol MSOutlookServicesMessageFetcher<MSODataEntityFetcher>

@optional

- (NSURLSessionTask *) readWithCallback:(void (^)(MSOutlookServicesMessage *message, MSODataException *exception))callback;
- (id<MSOutlookServicesMessageFetcher>)addCustomParametersWithName:(NSString *)name value:(id)value;
- (id<MSOutlookServicesMessageFetcher>)addCustomHeaderWithName:(NSString *)name value:(NSString *)value;
- (id<MSOutlookServicesMessageFetcher>)select:(NSString *)params;
- (id<MSOutlookServicesMessageFetcher>)expand:(NSString *)value;

@required

@property (copy, nonatomic, readonly) MSOutlookServicesMessageOperations *operations;

- (MSOutlookServicesAttachmentCollectionFetcher *)getAttachments;
- (MSOutlookServicesAttachmentFetcher *) getAttachmentsById:(NSString*)_id;
- (MSOutlookServicesEventMessageFetcher *)asEventMessage;	

@end

@interface MSOutlookServicesMessageFetcher : MSODataEntityFetcher<MSOutlookServicesMessageFetcher>

- (instancetype)initWithUrl:(NSString*)urlComponent parent:(id<MSODataExecutable>)parent;
- (NSURLSessionTask *) updateMessage:(MSOutlookServicesMessage *)message callback:(void (^)(MSOutlookServicesMessage *message, MSODataException *error))callback;
- (NSURLSessionTask *) deleteMessage:(void (^)(int status, MSODataException *exception))callback;

@end