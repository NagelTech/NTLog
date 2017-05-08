//
//  NTLog.h
//
//

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSInteger, NTLogEntryType)
{
    NTLogEntryTypeNone    = 0,
    NTLogEntryTypeDebug   = 1,
    NTLogEntryTypeInfo     = 2,
    NTLogEntryTypeWarn    = 4,
    NTLogEntryTypeError   = 8,
    NTLogEntryTypeFatal   = 16,
    
    NTLogEntryTypeAll     = NTLogEntryTypeDebug | NTLogEntryTypeInfo | NTLogEntryTypeWarn | NTLogEntryTypeError | NTLogEntryTypeFatal,
    
} ;


@protocol NTLogListener <NSObject>

@optional

// one of the following must be implemented...

-(void)writeLine:(NSString *)line;
-(void)writeType:(NTLogEntryType)type thread:(NSString *)thread location:(NSString *)location message:(NSString *)message;

@end


#ifdef DEBUG
#   define NTLogDebug(...)         NTLogOutput(@__FILE__, __LINE__, NTLogEntryTypeDebug, __VA_ARGS__)
#else
#   define NTLogDebug(...)
#endif

#define NTLogInfo(...)          NTLogOutput(@__FILE__, __LINE__, NTLogEntryTypeInfo, __VA_ARGS__)
#define NTLog(...)              NTLogOutput(@__FILE__, __LINE__, NTLogEntryTypeInfo, __VA_ARGS__)
#define NTLogWarn(...)          NTLogOutput(@__FILE__, __LINE__, NTLogEntryTypeWarn, __VA_ARGS__)
#define NTLogError(...)         NTLogOutput(@__FILE__, __LINE__, NTLogEntryTypeError, __VA_ARGS__)
#define NTLogFatal(...)         NTLogOutput(@__FILE__, __LINE__, NTLogEntryTypeFatal, __VA_ARGS__)

#ifdef __cplusplus
extern "C" {
#endif

void NTLogEnableConsoleLogging(NTLogEntryType flags);
void NTLogEnableListenerLogging(NTLogEntryType flags);
void NTLogEnableLogging(NTLogEntryType flags);
NSString *NTLogGetLogEntryTypeName(NTLogEntryType logEntryType);
void NTLogSetMaxLineLength(SInt32 maxLineLength);
void NTLogAddListener(id<NTLogListener> listener);
void NTLogOutputv(NSString *filename, int lineNum, NTLogEntryType logEntryType, NSString *format, va_list args);
void NTLogOutput(NSString *filename, int lineNum, NTLogEntryType logEntryType, NSString *format, ...) NS_FORMAT_FUNCTION(4,5);

#ifdef __cplusplus
}
#endif
