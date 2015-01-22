//
//  main.m
//  freeime-table
//
//  Created by 程巍巍 on 1/21/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FreeImeContext.h"
#import "FreePinYin.h"
#import "FreeWuBi.h"
#import "Hans.h"

static FreeImeContext *mainContext;
static void saveContext() {
    [mainContext save:nil];
}

static void importHans(NSString *tablePath){
    // 按行解析 table
    NSString *line;
    FILE *file = fopen([tablePath UTF8String], "r");
    char *buffer = malloc(512);
    
    NSInteger progress = 0;
    
//    NSRegularExpression *keyRegex = [NSRegularExpression regularExpressionWithPattern:@"^[a-z]*" options:0 error:nil];
    NSRegularExpression *hanRegex = [NSRegularExpression regularExpressionWithPattern:@"[^a-z0-9\\s]+" options:0 error:nil];
//    NSRegularExpression *frequencyRegex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+" options:0 error:nil];
    
    __block NSString *han;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:mainContext.hans.name];
    __block Hans *hans;
    __block BOOL isLazy;
    while (fgets(buffer, 512, file)) {
        line = [[NSString alloc] initWithUTF8String:buffer];
        
        [hanRegex enumerateMatchesInString:line options:0 range:(NSRange){0, line.length} usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            han = [line substringWithRange:result.range];
            isLazy = [han hasPrefix:@"~"];
            han = [han substringFromIndex:isLazy];
            request.predicate = [NSPredicate predicateWithFormat:@"value == %@",han];
            hans = [[mainContext executeFetchRequest:request error:nil] firstObject];
            if (hans) {
                hans.frequency = @([hans.frequency integerValue]+1);
            }else{
                hans = [[Hans alloc] initWithEntity:mainContext.hans insertIntoManagedObjectContext:mainContext];
                hans.value = han;
                hans.type = @(isLazy);
            }
        }];
        
        
        if (progress%1000 == 0) {
            [mainContext save:nil];
            NSLog(@"... : %li",(long)progress);
        }
        progress ++;
    }
    [mainContext save:nil];
    NSLog(@"total hans : %li",(long)progress);
    free(buffer);
}

static void importWubi(NSString *tablePath){
    // 按行解析 table
    NSString *line;
    FILE *file = fopen([tablePath UTF8String], "r");
    char *buffer = malloc(512);
    
    __block NSInteger progress = 0;
    
    
    NSRegularExpression *wubiRegex = [NSRegularExpression regularExpressionWithPattern:@"^[a-z]{1,4}" options:0 error:nil];
    NSRegularExpression *hanRegex = [NSRegularExpression regularExpressionWithPattern:@"[^a-z0-9\\s]+" options:0 error:nil];
    //    NSRegularExpression *frequencyRegex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+" options:0 error:nil];
    
    __block NSString *han;
    __block NSString *wubi;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:mainContext.hans.name];
    __block Hans *hans;
    __block BOOL isLazy;
    while (fgets(buffer, 512, file)) {
        line = [[NSString alloc] initWithUTF8String:buffer];
        
        [wubiRegex enumerateMatchesInString:line options:0 range:(NSRange){0, line.length} usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            wubi = [line substringWithRange:result.range];
            [hanRegex enumerateMatchesInString:line options:0 range:(NSRange){0, line.length} usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                han = [line substringWithRange:result.range];
                isLazy = [han hasPrefix:@"~"];
                han = [han substringFromIndex:isLazy];
                request.predicate = [NSPredicate predicateWithFormat:@"value == %@",han];
                hans = [[mainContext executeFetchRequest:request error:nil] firstObject];
                if (!hans) {
                    hans = [[Hans alloc] initWithEntity:mainContext.hans insertIntoManagedObjectContext:mainContext];
                    hans.value = han;
                };
                
                FreeWuBi *fwb = [[FreeWuBi alloc] initWithEntity:mainContext.freeWuBi insertIntoManagedObjectContext:mainContext];
                fwb.key = wubi;
                fwb.value = hans;
                
                if (progress%100 == 0) {
                    saveContext();
                    NSLog(@"... : %li",(long)progress);
                }
                progress ++;
            }];
        }];
        
    }
    saveContext();
    NSLog(@"total wubi  : %li",(long)progress);
    free(buffer);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"load table ...");
        NSString *tablePath = [[[NSString stringWithFormat:@"%s",argv[0]] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"freeime.txt"];;
        
        mainContext = [FreeImeContext main];
        NSString *momPath = [[tablePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"FreeImeDB.mom"];
        mainContext.persistentStoreCoordinator = [mainContext kPersistentStoreCoordinator:[NSURL fileURLWithPath:momPath]];
        
//        importHans(tablePath);
        importWubi(tablePath);
        
    }
    return 0;
}


