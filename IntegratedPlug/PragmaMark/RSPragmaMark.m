//
//  RSPragmaMark.m
//  IntegratedPlug-ins
//
//  Created by 周荣水 on 2016/10/26.
//  Copyright © 2016年 周荣水. All rights reserved.
//

#import "RSPragmaMark.h"

static NSString *const insertPragmaMark = @"#pragma mark -- ViewComtroller\n\n#pragma mark -- UIViewController Delegate\n\n#pragma mark -- NetWork Method\n\n#pragma mark -- Public Methods\n\n#pragma mark -- Private Methods\n\n#pragma mark -- Override Methods\n\n#pragma mark -- UICollectionViewDataSource&Delegate\n\n#pragma mark -- UITabelViewDataSource&Delegate";

@implementation RSPragmaMark
-(void)handlerCommandInvocation:(XCSourceEditorCommandInvocation *)invocation{
    if (invocation.buffer.selections.count != 0) {
        XCSourceTextRange* lastObject = invocation.buffer.selections.lastObject;
        NSUInteger endLine = lastObject.end.line;
        
        [invocation.buffer.lines insertObject:insertPragmaMark atIndex:endLine];
    }
}

@end
