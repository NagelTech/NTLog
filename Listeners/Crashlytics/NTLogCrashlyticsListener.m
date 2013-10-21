//
//  NTLogCrashlyticsListener.m
//  TakeANumber-iOS
//
//  Created by Ethan Nagel on 11/26/12.
//  Copyright (c) 2012 Tomfoolery, Inc. All rights reserved.
//

#import "NTLogCrashlyticsListener.h"

OBJC_EXTERN void CLSLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

@implementation NTLogCrashlyticsListener


-(void)writeLine:(NSString *)line
{
    CLSLog(@"%@", line);
}


@end
