//
//  SourceEditorCommand.h
//  IntegratedPlug
//
//  Created by 周荣水 on 2016/10/26.
//  Copyright © 2016年 周荣水. All rights reserved.
//

#import <XcodeKit/XcodeKit.h>

@interface SourceEditorCommand : NSObject <XCSourceEditorCommand>
- (void)handlerCommandInvocation:(XCSourceEditorCommandInvocation *)invocation;

@end
