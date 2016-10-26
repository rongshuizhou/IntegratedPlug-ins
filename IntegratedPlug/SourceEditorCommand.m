//
//  SourceEditorCommand.m
//  IntegratedPlug
//
//  Created by 周荣水 on 2016/10/26.
//  Copyright © 2016年 周荣水. All rights reserved.
//

#import "SourceEditorCommand.h"

@implementation SourceEditorCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
    // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
    if (![invocation.commandIdentifier rangeOfString:NSStringFromClass(self.class)].length) {
        completionHandler(nil);
    }
    [self handlerCommandInvocation:invocation];
    
    
    completionHandler(nil);
}


- (void)handlerCommandInvocation:(XCSourceEditorCommandInvocation *)invocation {}

@end
