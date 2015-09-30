//
//  NTLog.h
//
//

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSInteger, NTLogEntryType)
{
    NTLogEntryTypeNone    = 0,
    NTLogEntryTypeDebug   = 1,
    NTLogEntryTypeLog     = 2,
    NTLogEntryTypeWarn    = 4,
    NTLogEntryTypeError   = 8,
    NTLogEntryTypeFatal   = 16,
    
    NTLogEntryTypeAll     = NTLogEntryTypeDebug | NTLogEntryTypeLog | NTLogEntryTypeWarn | NTLogEntryTypeError | NTLogEntryTypeFatal,
    
} ;


@protocol NTLogListener <NSObject>

@optional

// one of the following must be implemented...

-(void)writeLine:(NSString *)line;
-(void)writeType:(NTLogEntryType)type thread:(NSString *)thread location:(NSString *)location message:(NSString *)message;

@end


#define NTLogDebug(...)         NTLog_Log(@__FILE__, __LINE__, NTLogEntryTypeDebug, __VA_ARGS__)
#define NTLog(...)              NTLog_Log(@__FILE__, __LINE__, NTLogEntryTypeLog, __VA_ARGS__)
#define NTLogWarn(...)          NTLog_Log(@__FILE__, __LINE__, NTLogEntryTypeWarn, __VA_ARGS__)
#define NTLogError(...)         NTLog_Log(@__FILE__, __LINE__, NTLogEntryTypeError, __VA_ARGS__)
#define NTLogFatal(...)         NTLog_Log(@__FILE__, __LINE__, NTLogEntryTypeFatal, __VA_ARGS__)

#ifdef __cplusplus
extern "C" {
#endif

void NTLogEnableConsoleLogging(NTLogEntryType flags);
void NTLogEnableLogging(NTLogEntryType flags);
NSString *NTLog_GetLogEntryTypeName(NTLogEntryType logEntryType);
void NTLog_AddListener(id<NTLogListener> listener);
void NTLog_Logv(NSString *filename, int lineNum, NTLogEntryType logEntryType, NSString *format, va_list args);
void NTLog_Log(NSString *filename, int lineNum, NTLogEntryType logEntryType, NSString *format, ...) NS_FORMAT_FUNCTION(4,5);

#ifdef __cplusplus
}
#endif
