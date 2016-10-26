//
//  RSImportPackage.m
//  IntegratedPlug-ins
//
//  Created by 周荣水 on 2016/10/26.
//  Copyright © 2016年 周荣水. All rights reserved.
//

#import "RSImportPackage.h"

@implementation RSImportPackage
-(void)handlerCommandInvocation:(XCSourceEditorCommandInvocation *)invocation{
    //check selections count
    if (invocation.buffer.selections.count != 1) {
        return;
    }
    
    //must be one line
    XCSourceTextRange *selection = invocation.buffer.selections.firstObject;
    if (selection.start.line != selection.end.line) {
        return;
    }
    
    //handle
    NSString *selectedString = nil;
    NSInteger lastImportLineIndex = NSNotFound;
    
    //find the last import line index & selected string
    for (int idx = 0; idx < invocation.buffer.lines.count; idx++) {
        NSString *line = invocation.buffer.lines[idx];
        
        NSString* importLine = [self isOcSource:invocation] ? @"#import" : @"import ";
        
        if ([line hasPrefix:importLine]) {
            lastImportLineIndex = idx;
        }
        if (idx == selection.start.line) {
            selectedString = [line substringWithRange:NSMakeRange(selection.start.column, selection.end.column - selection.start.column+1)];
        }
    }
    
    //check selected string
    NSString* trimString = [selectedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!trimString || trimString.length < 1 || [trimString isEqualToString:@"\n"]) {
        return;
    }
    
    //check invocation contains import string
    NSString *importString = [self isOcSource:invocation] ? [NSString stringWithFormat:@"#import \"%@.h\"", selectedString] : [NSString stringWithFormat:@"import %@",selectedString];
    if ([invocation.buffer.completeBuffer containsString:importString]) {
        return;
    }
    
    NSUInteger lineForEmpty = [self lineForEmptyImportLine:invocation.buffer.lines invocation:invocation];
    NSUInteger lineForAboveClassDefinition = [self lineForAboveClassDefinition:invocation.buffer.lines invocation:invocation];
    
    if (lastImportLineIndex != NSNotFound) {//file contains #import lines
        [invocation.buffer.lines insertObject:importString atIndex:lastImportLineIndex+1];
        
    }else if(lineForEmpty != NSNotFound){//file does not contains #import lines,put it in first line under comment
        [invocation.buffer.lines insertObject:importString atIndex:lineForEmpty+1];
        
    }else if(lineForAboveClassDefinition != NSNotFound){
        [invocation.buffer.lines insertObject:importString atIndex:lineForAboveClassDefinition+1];
    }

}


-(BOOL)isOcSource:(XCSourceEditorCommandInvocation *)invocation{
    return [invocation.buffer.contentUTI containsString:@"objective-c-source"];
}

- (NSInteger)lineForEmptyImportLine:(NSMutableArray *)lines invocation:(XCSourceEditorCommandInvocation *)invocation{
    for (int i=0; i<lines.count; i++) {
        NSString* lineString = [lines objectAtIndex:i];
        
        if ([lineString hasPrefix:@"//"]) {
            continue;
        }
        if ([lineString isEqualToString:@"\n"]) {
            return i;
        }
        NSString* prefix = [self isOcSource:invocation] ? @"@" :@"class";
        if ([lineString hasPrefix:prefix]) {
            return NSNotFound;
        }
    }
    return NSNotFound;
}

- (NSInteger)lineForAboveClassDefinition:(NSMutableArray *)lines invocation:(XCSourceEditorCommandInvocation *)invocation{
    for (int i=0; i<lines.count; i++) {
        NSString* lineString = [lines objectAtIndex:i];
        
        if ([lineString hasPrefix:@"//"]) {
            continue;
        }
        NSString* prefix = [self isOcSource:invocation] ? @"@" :@"class";
        if ([lineString hasPrefix:prefix]) {
            return i >1 ? (i - 1): 0;
        }
    }
    return NSNotFound;
}

@end
