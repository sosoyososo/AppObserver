//
//  AOCallStackTrace.m
//  AppObserver
//
//  Created by karsa on 2018/2/1.
//  Copyright © 2018年 karsa. All rights reserved.
//

#import "AOCallStackTrace.h"
#import <CrashReporter/CrashReporter.h>

@implementation AOCallStackTrace

+ (NSString *)allCallStackTrace {
    PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD
                                                                       symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];
    PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:config];
    NSData *data = [crashReporter generateLiveReport];
    PLCrashReport *reporter = [[PLCrashReport alloc] initWithData:data error:NULL];
    NSString *report = [PLCrashReportTextFormatter stringValueForCrashReport:reporter
                                                              withTextFormat:PLCrashReportTextFormatiOS];
    return report;
}

@end
