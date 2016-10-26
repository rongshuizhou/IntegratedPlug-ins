//
//  RSCopyLineDown.m
//  IntegratedPlug-ins
//
//  Created by 周荣水 on 2016/10/26.
//  Copyright © 2016年 周荣水. All rights reserved.
//

#import "RSCopyLineDown.h"

@implementation RSCopyLineDown

- (void)handlerCommandInvocation:(XCSourceEditorCommandInvocation *)invocation {
    XCSourceTextRange *range = invocation.buffer.selections.firstObject;
    
    NSInteger startLine = range.start.line;
    NSInteger endLine = range.end.line;
    
    if (startLine >= invocation.buffer.lines.count) {
        return;
    }
    
    NSMutableArray *newlines = [NSMutableArray array];
    if (startLine == endLine) {
        [newlines addObject:[invocation.buffer.lines[startLine] copy]];
    } else {
        for (NSInteger i = startLine; i <= endLine; i++) {
            [newlines addObject:[invocation.buffer.lines[i] copy]];
        }
    }
    
    [newlines enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [invocation.buffer.lines insertObject:obj atIndex:startLine];
    }];
    
    // 设置selections
    XCSourceTextPosition start = (XCSourceTextPosition){startLine + newlines.count, 0};
    XCSourceTextPosition end = (XCSourceTextPosition){endLine + newlines.count, invocation.buffer.lines[endLine + newlines.count].length - 1};
    range = [[XCSourceTextRange alloc] initWithStart:start end:end];
    [invocation.buffer.selections removeAllObjects];
    [invocation.buffer.selections addObject:range];
}

@end
