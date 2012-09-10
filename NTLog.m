//
//  NTLog.m
//
//

#import "NTLog.h"


static NTLogEntryType sLogFlags = NTLogEntryTypeAll;    // default to all debugging on


NSString *NTLog_GetLogEntryTypeName(NTLogEntryType logEntryType);


NSString *NTLog_GetLogEntryTypeName(NTLogEntryType logEntryType)
{
    if ( logEntryType & NTLogEntryTypeFatal )         return @"Fatal";
    if ( logEntryType & NTLogEntryTypeError )         return @"Error";
    if ( logEntryType & NTLogEntryTypeWarn )          return @"Warn";
    if ( logEntryType & NTLogEntryTypeLog )           return @"Log";
    if ( logEntryType & NTLogEntryTypeDebug )         return @"Debug";
    
    return nil;
}


void NTLogEnableLogging(NTLogEntryType flags)
{
    sLogFlags = flags;
}


void NTLog_Log(NSString *filename, int lineNum, NTLogEntryType logEntryType, NSString *format, ...)
{
    if ( !(sLogFlags & logEntryType) )
        return ;    // ignore
    
    const int MAX_LENGTH = 1024 - 3;    // -3 for @"..."
    
	static CFTimeZoneRef zone = nil;
	if (!zone) zone = CFTimeZoneCopyDefault();
    
    va_list args;
    va_start(args, format);
    
    NSMutableString *message = [NSMutableString new];
    
    /* not needed when using NSLog
     CFGregorianDate date = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), zone);
     
     [message appendFormat:@"%02i/%02i/%02i ", date.year%100, date.month, date.day];
     
     [message appendFormat:@"%02i:%02i:%02i ", date.hour, date.minute, (unsigned)date.second];
     */
    
    
    if ( logEntryType != NTLogEntryTypeLog )
        [message appendFormat:@"%@: ", NTLog_GetLogEntryTypeName(logEntryType)];
    
    if ( ![NSThread isMainThread] )
    {
        NSString *threadName = [NSThread currentThread].name;
        
        if ( !threadName || !threadName.length )
            threadName = [NSString stringWithFormat:@"Thread-%p", [NSThread currentThread]];
        
        [message appendFormat:@"%@@", threadName];
    }
    
    [message appendFormat:@"[%@:%d] ", [[filename lastPathComponent] stringByDeletingPathExtension], lineNum];
    
    NSString *user_message = [[NSString alloc] initWithFormat:format arguments:args];
    
    [message appendString:user_message];
    user_message = nil; // arc
    
    if ( message.length > MAX_LENGTH )
    {
        [message deleteCharactersInRange:NSMakeRange(MAX_LENGTH, message.length-MAX_LENGTH)];
        [message appendString:@"..."];
    }
    
    //    printf("%s\n", [message UTF8String]);    // Might cause problems in IOS 5.1+ ??
    
    NSLog(@"%@", message);      // use formatting in case our formatted string uses any formatting.
    
    message = nil;  // arc will deallocate
}

