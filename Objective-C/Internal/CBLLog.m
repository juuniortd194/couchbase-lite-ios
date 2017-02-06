//
//  CBLLog.m
//  CouchbaseLite
//
//  Created by Pasin Suriyentrakorn on 1/5/17.
//  Copyright © 2017 Couchbase. All rights reserved.
//

#import "CBLLog.h"
#import "ExceptionUtils.h"


C4LogDomain kCBLDatabaseLogDomain;

static const char* kLevelNames[6] = {"Debug", "Verbose", "Info", "WARNING", "ERROR", "none"};


void cbllog(C4LogDomain domain, C4LogLevel level, NSString *msg, ...) {
    @autoreleasepool {
        va_list args;
        va_start(args, msg);
        NSString* message = [[NSString alloc] initWithFormat: msg arguments: args];
        c4log(domain, level, message.UTF8String);
        va_end(args);
    }
}


static void logCallback(C4LogDomain domain, C4LogLevel level, C4Slice message) {
    NSLog(@"CouchbaseLite %s %s: %.*s", c4log_getDomainName(domain), kLevelNames[level],
          (int)message.size, (char*)message.buf);
    if (level >= kC4LogWarning && [NSUserDefaults.standardUserDefaults boolForKey: @"CBLBreakOnWarning"])
        MYBreakpoint();     // stops debugger at breakpoint. You can resume normally.
}


static C4LogLevel string2level(NSString* value) {
    if (value == nil)
        return kC4LogWarning;
    switch (value.length > 0 ? toupper([value characterAtIndex: 0]) : 'Y') {
        case 'N': case 'F': case '0':
            return kC4LogError + 1;
        case 'V': case '2':
            return kC4LogVerbose;
        case 'D': case '3'...'9':
            return kC4LogDebug;
        default:
            return kC4LogInfo;
    }
}


void CBLLog_Init() {
    // First set the default log level, and register the log callback:
    C4LogLevel defaultLevel = string2level([NSUserDefaults.standardUserDefaults objectForKey: @"CBLLogLevel"]);
    c4log_register(defaultLevel, &logCallback);
    if (defaultLevel != kC4LogWarning)
        NSLog(@"CouchbaseLite default log level is %s and above", kLevelNames[defaultLevel]);

    kCBLDatabaseLogDomain = c4log_getDomain("Database", true);

    // Now map user defaults starting with CBLLog... to log levels:
    NSDictionary* defaults = [NSUserDefaults.standardUserDefaults dictionaryRepresentation];
    for (NSString* key in defaults) {
        if ([key hasPrefix: @"CBLLog"] && ![key isEqualToString: @"CBLLogLevel"]) {
            const char *domainName = key.UTF8String + 6;
            if (*domainName == 0)
                domainName = "Default";
            C4LogDomain domain = c4log_getDomain(domainName, true);
            C4LogLevel level = string2level(defaults[key]);
            c4log_setLevel(domain, level);
            NSLog(@"CouchbaseLite logging to %s domain at level %s", domainName, kLevelNames[level]);
        }
    }
}
