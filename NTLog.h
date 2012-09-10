//
//  NTLog.h
//
//

#import <Foundation/Foundation.h>


typedef enum
{
    NTLogEntryTypeDebug   = 1,
    NTLogEntryTypeLog     = 2,
    NTLogEntryTypeWarn    = 4,
    NTLogEntryTypeError   = 8,
    NTLogEntryTypeFatal   = 16,
    
    NTLogEntryTypeAll     = NTLogEntryTypeDebug | NTLogEntryTypeLog | NTLogEntryTypeWarn | NTLogEntryTypeError | NTLogEntryTypeFatal,
    
} NTLogEntryType;



#define NTLogDebug(...)         NTLog_Log(@__FILE__, __LINE__, NTLogEntryTypeDebug, __VA_ARGS__)
#define NTLog(...)              NTLog_Log(@__FILE__, __LINE__, NTLogEntryTypeLog, __VA_ARGS__)
#define NTLogWarn(...)          NTLog_Log(@__FILE__, __LINE__, NTLogEntryTypeWarn, __VA_ARGS__)
#define NTLogError(...)         NTLog_Log(@__FILE__, __LINE__, NTLogEntryTypeError, __VA_ARGS__)
#define NTLogFatal(...)         NTLog_Log(@__FILE__, __LINE__, NTLogEntryTypeFatal, __VA_ARGS__)


void NTLogEnableLogging(NTLogEntryType flags);

void NTLog_Log(NSString *filename, int lineNum, NTLogEntryType logEntryType, NSString *format, ...);

