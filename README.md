NTLog
=====

A simple, extensible iOS logging system.

NTLog is a replacement for NSLog with the following features:

 * Multiple log types - Debug, Info, Error, or "Fatal"
 
 * Outputs information about the context of each log entry - File/Line Number, Thread and type of log entry (Warning, Error, etc.)
 
 * Support for enabling/disabling logging based on the type or globally. Additionally you can explicitly disable NSLog output for app store builds while still logging to other sources.
 
 * Extensible - You can easily add your own log listeners to log to files or other services. Currently Crashlytics is supported as a listener. (This is implemented as a subspec in cocoapods.)


CocoaPods Installation
======================

Installation with CocoaPods is straight-forward. The main main logging system is implemented as a subspec 'Core', to add it, simply unclude it un your podfile:

    pod 'NTLog/Core'

Listeners are also implemented as subspecs and may be added similarly:

    pod 'NTLog/Crashlytics'
    
Old School Installation
=======================

Add the contents of the **Core** folder to tour project get the basic NTLog functionality. Add the contents of the **Listeners/Crashlytics** folder to add Crashlytics Log Listener support.

Usage
=====
 
There are 5 basic functions (well marcos technically) for logging. Each takes a stringWithFormat-style formatted string. `NTLog()` will output as "Info" while the others, (`NTLogDebug`, `NTLogWarn`, etc) output as the associated log types.

    NTLog(@"Hello from NTLog!");
    NTLogDebug("Value Of someVariable: %@", someVariable);

You can enable/disable console logging for any log type by calling `NTLogEnableConsoleLogging()`. Typically you would set this in a macro in your AppDelegate's didFinishLaunching:

    #ifndef DEBUG
        NTEnableConsoleLogging(0); // disable console logging for appstore builds
    #endif
  
Additionally, you can enable or disable logging for any log type using `NTLogEnableLogging()'. This function takes bit flags indicating what logging you want to see. If you wanted to see only errors and fatal errors, you could configure the following:

    NTLogEnableLogging(NTLogEntryTypeError | NTLogEntryTypeFatal);
    
Log Listeners
=============

Log Listeners are simple classes that, once registered with NTLg will receive each log message. Log Listeners must conform to the `NTLogListener` protocol an implement either `writeLine:` or `writeType:thread:location:message`. The first flavor receives a fully formatted string matching the output to NSLog while the second receives the component parts. Only one of these will be called both are implemented.

Listeners are added by calling `NTLog_AddListener()`, passing an instance of the listener.

Crashlytics Log Listener
========================

Th Crashlytics log listener outputs log messages to Crashlytics so they will be available in crash reports. This can some in **very** handy when dealing with more obscure bugs. Console Logging is filtered separately from the Log Listeners, so you can configure log mesages to go to Crashlytics while having console logging disabled.

All you need to do to use this is add the listener in your AppDelegate's didFinishLaunching after you have initialized the Crashlytics library. Your typical start-up might look like the following:

    NTLogEnableLogging(NTLogEntryTypeAll); // Log everything internally and to the crash reporters
    
    #ifdef APPSTORE // (assuming you are defining this somewhere in your build process)
        NTLogEnableConsoleLogging(NTLogEntryTypeNone); // No console logging for App Store builds
    #endif
    
    [Crashlytics startWithAPIKey:@"BLAHBLAHBLAHBLAH"];
    NTLog_AddListener([NTLogCrashlyticsListener new]);