//
//  NTLog.m
//
//

#import "NTLog.h"


static NTLogEntryType sLogFlags = NTLogEntryTypeAll;    // default to all debugging on
static NTLogEntryType sConsoleLogFlags = NTLogEntryTypeAll;    // default to all debugging on
static NSMutableArray *sListeners = nil;


NSString *NTLog_GetLogEntryTypeName(NTLogEntryType logEntryType)
{
    if ( logEntryType & NTLogEntryTypeFatal )         return @"Fatal";
    if ( logEntryType & NTLogEntryTypeError )         return @"Error";
    if ( logEntryType & NTLogEntryTypeWarn )          return @"Warn";
    if ( logEntryType & NTLogEntryTypeInfo )          return @"Info";
    if ( logEntryType & NTLogEntryTypeDebug )         return @"Debug";
    
    return nil;
}


void NTLogEnableLogging(NTLogEntryType flags)
{
    sLogFlags = flags;
    sConsoleLogFlags = flags;
}

void NTLogEnableConsoleLogging(NTLogEntryType flags)
{
    sConsoleLogFlags = flags;
}


void NTLogAddListener(id<NTLogListener> listener)
{
    if ( !sListeners )
        sListeners = [NSMutableArray new];
    
    [sListeners addObject:listener];
}


void NTLogOutputv(NSString *filename, int lineNum, NTLogEntryType logEntryType, NSString *format, va_list args)
{
    if ( !(sLogFlags & logEntryType) && !(sConsoleLogFlags & logEntryType) )
        return;
    
    const int MAX_LENGTH = 1024 - 3;    // -3 for @"..."
    
	static CFTimeZoneRef zone = nil;
	if (!zone) zone = CFTimeZoneCopyDefault();
    
    NSMutableString *message = [NSMutableString new];

    CFGregorianDate date = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), zone);
     
    [message appendFormat:@"%02zd-%02zd-%02zd ", date.year%100, date.month, date.day];
     
    [message appendFormat:@"%02zd:%02zd:%02zd ", date.hour, date.minute, (int)date.second];

    if ( logEntryType != NTLogEntryTypeInfo )
        [message appendFormat:@"%@: ", NTLog_GetLogEntryTypeName(logEntryType)];
    
    NSString *threadName = nil;

    if ( ![NSThread isMainThread] )
    {
        threadName = [NSThread currentThread].name;
        
        if ( !threadName || !threadName.length )
            threadName = [NSString stringWithFormat:@"Thread-%p", [NSThread currentThread]];
        
        [message appendFormat:@"%@@", threadName];
    }
    
    NSString *location = [NSString stringWithFormat:@"%@:%d", [[filename lastPathComponent] stringByDeletingPathExtension], lineNum];
    
    [message appendFormat:@"[%@] ", location];
    
    NSString *user_message = [[NSString alloc] initWithFormat:format arguments:args];
    
    [message appendString:user_message];
    
    if ( message.length > MAX_LENGTH )
    {
        [message deleteCharactersInRange:NSMakeRange(MAX_LENGTH, message.length-MAX_LENGTH)];
        [message appendString:@"..."];
    }
    
    
    if ( sConsoleLogFlags & logEntryType )
        printf("%s\n", [message UTF8String]);

    if ( sListeners && (sLogFlags & logEntryType) )
    {
        for(id<NTLogListener> listener in sListeners)
        {
            
            if ( [listener respondsToSelector:@selector(writeType:thread:location:message:)] )
                [listener writeType:logEntryType thread:threadName location:location message:user_message];
            
            if ( [listener respondsToSelector:@selector(writeLine:)] )
                [listener writeLine:message];
        }
    }
    
    message = nil;  // arc will deallocate
    user_message = nil;
}


void NTLogOutput(NSString *filename, int lineNum, NTLogEntryType logEntryType, NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    NTLogOutputv(filename, lineNum, logEntryType, format, args);
    va_end(args);
}

