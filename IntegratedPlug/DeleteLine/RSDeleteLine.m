//
//  RSDeleteLine.m
//  IntegratedPlug-ins
//
//  Created by 周荣水 on 2016/10/26.
//  Copyright © 2016年 周荣水. All rights reserved.
//

#import "RSDeleteLine.h"

@implementation RSDeleteLine
- (void)handlerCommandInvocation:(XCSourceEditorCommandInvocation *)invocation {
    XCSourceTextRange *range = invocation.buffer.selections.firstObject;
    
    NSInteger startLine = range.start.line;
    NSInteger endLine = range.end.line;
    
    if (startLine >= invocation.buffer.lines.count) {
        return;
    }
    
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    if (startLine == endLine) {
        [set addIndex:startLine];
    } else {
        for (NSInteger i = startLine; i <= endLine; i++) {
            if (i>=invocation.buffer.lines.count) {
                break;
            }
            [set addIndex:i];
        }
    }
    
    
    [invocation.buffer.lines removeObjectsAtIndexes:set];
    
    // 处理选择区域
    [invocation.buffer.selections removeAllObjects];
    XCSourceTextPosition start = (XCSourceTextPosition){startLine, 0};
    XCSourceTextPosition end = (XCSourceTextPosition){startLine, 0};
    
    XCSourceTextRange *ran = [[XCSourceTextRange alloc] initWithStart:start end:end];
    [invocation.buffer.selections addObject:ran];
}
@end
