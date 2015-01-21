//
//  main.m
//  freeime-table
//
//  Created by 程巍巍 on 1/21/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FreeImeContext.h"
#import "Key_Value_W.h"
#import "Value_Key_W.h"

static FreeImeContext *context;

static void saveKeyValue(NSString *key, NSString *value);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"load table ...");
        NSString *tablePath = [[[[NSString stringWithFormat:@"%s",argv[0]] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"freeime.txt"] stringByResolvingSymlinksInPath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:tablePath isDirectory:NULL]){
            NSLog(@"file exist");
        }
        
        context = [FreeImeContext main];
        NSString *momPath = [[tablePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"FreeImeDB.mom"];
        context.persistentStoreCoordinator = [context kPersistentStoreCoordinator:[NSURL fileURLWithPath:momPath]];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:context.value_key_w.name];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"f_key == NULL"];
        request.predicate = predicate;
        request.fetchLimit = 1;
        
        NSString *table = [NSString stringWithContentsOfFile:tablePath encoding:NSUTF8StringEncoding error:nil];
        
        NSInteger progress = 0;
        
        Value_Key_W *vk;
        while ((vk = [[context executeFetchRequest:request error:nil] firstObject])) {
            NSArray *keys = [[vk.key allObjects] sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(Key_Value_W *obj1, Key_Value_W *obj2) {
                return obj1.key.length < obj2.key.length;
            }];
            if (keys.count == 0) continue;
            vk.f_key = [keys[0] key];
        }
        [context save:nil];
//        // 按行解析 table
//        NSString *line;
//        FILE *file = fopen([tablePath UTF8String], "r");
//        char *buffer = malloc(512);
//        

//
//        NSRegularExpression *keyRegex = [NSRegularExpression regularExpressionWithPattern:@"^[a-z]*" options:0 error:nil];
//        NSRegularExpression *valueRegex = [NSRegularExpression regularExpressionWithPattern:@"[^a-z\\s]+" options:0 error:nil];
//        
//        while (fgets(buffer, 512, file)) {
//            line = [[NSString alloc] initWithUTF8String:buffer];
//            __block NSString *key,*value;
//            [keyRegex enumerateMatchesInString:line options:0 range:NSMakeRange(0, line.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
//                key = [line substringWithRange:result.range];
//                [valueRegex enumerateMatchesInString:line options:0 range:NSMakeRange(0, line.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
//                    value = [line substringWithRange:result.range];
//                    saveKeyValue(key, value);
//                }];
//            }];
//            [context save:nil];
//            if (progress%1000 == 0) {
//                NSLog(@"progress : %li",(long)progress);
//            }
//            progress ++;
//            if (progress%10000 == 0) {
//                char c = getchar();
//            }
//        }
//        NSLog(@"done");
//        free(buffer);
    }
    return 0;
}

static void saveKeyValue(NSString *key, NSString *value)
{
    Value_Key_W *vk = [context wValue:value key:key];
    [[context wKey:key] addValueObject:vk];
}
