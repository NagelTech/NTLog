//
//  NTLog.m
//
//

#import "NTLog.h"


static NTLogEntryType sLogFlags = NTLogEntryTypeAll;            // default to all debugging on
static NTLogEntryType sConsoleLogFlags = NTLogEntryTypeAll;     // default to all debugging on
static SInt32 sMaxLineLength = 1024;                            // default
static NSArray *sListeners = nil;


NSString *NTLogGetLogEntryTypeName(NTLogEntryType logEntryType)
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


void NTLogSetMaxLineLength(int maxLineLength)
{
    sMaxLineLength = maxLineLength;
}


void NTLogAddListener(id<NTLogListener> listener)
{
    assert([NSThread isMainThread]);
    sListeners = [sListeners arrayByAddingObject:listener] ?: @[listener];
}


void NTLogOutputv(NSString *filename, int lineNum, NTLogEntryType logEntryType, NSString *format, va_list args)
{
    // grab our own copy of these values on the stack, so nothing changes during the call

    NTLogEntryType logFlags = sLogFlags;
    NTLogEntryType consoleLogFlags = sConsoleLogFlags;
    SInt32 maxLineLength = sMaxLineLength;
    NSArray *listeners = sListeners;

    if ( !(logFlags & logEntryType) && !(consoleLogFlags & logEntryType) )
        return ;
    
	static CFTimeZoneRef zone;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zone = CFTimeZoneCopyDefault();
    });

    NSMutableString *message = [NSMutableString new];

    CFGregorianDate date = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), zone);
     
    [message appendFormat:@"%02zd-%02zd-%02zd ", date.year%100, date.month, date.day];
     
    [message appendFormat:@"%02zd:%02zd:%02zd ", date.hour, date.minute, (int)date.second];

    if ( logEntryType != NTLogEntryTypeInfo )
        [message appendFormat:@"%@: ", NTLogGetLogEntryTypeName(logEntryType)];
    
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
    
    if ( maxLineLength > 0 && message.length > maxLineLength )
    {
        [message deleteCharactersInRange:NSMakeRange(maxLineLength - 3, message.length - (maxLineLength - 3))];
        [message appendString:@"..."];
    }

    if ( sConsoleLogFlags & logEntryType )
        printf("%s\n", [message UTF8String]);

    if ( listeners && (logFlags & logEntryType) )
    {
        for(id<NTLogListener> listener in listeners)
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

