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

#import <Foundation/Foundation.h>
#import "MSOutlookServicesProtocols.h"
#import "MSOutlookServicesEntity.h"

/**
* The header for type Item.
*/

@interface MSOutlookServicesItem : MSOutlookServicesEntity

@property (retain, nonatomic, readwrite, getter=changeKey, setter=setChangeKey:) NSString *ChangeKey;
@property (retain, nonatomic, readwrite, getter=categories, setter=setCategories:) NSMutableArray *Categories;
@property (retain, nonatomic, readwrite, getter=dateTimeCreated, setter=setDateTimeCreated:) NSDate *DateTimeCreated;
@property (retain, nonatomic, readwrite, getter=dateTimeLastModified, setter=setDateTimeLastModified:) NSDate *DateTimeLastModified;

@end