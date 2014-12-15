//
//  ESCJSContext_Prevate.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/6/14.
//
//

#ifndef ESCDevelopTool_ESCJSContext_Prevate_h
#define ESCDevelopTool_ESCJSContext_Prevate_h

#import "ESCJSContext.h"

#import <objc/message.h>
#import <objc/runtime.h>

struct kECSBlockDescriptor {
    unsigned long reserved;
    unsigned long size;
    void *rest[1];
};

struct kECSBlock {
    void *isa;
    int flags;
    int reserved;
    void *funcPtr;
    struct kECSBlockDescriptor *descriptor;
};

static const char *kECSGetBlockSignature(id blockObj)
{
    struct kECSBlock *block = (__bridge void *)blockObj;
    struct kECSBlockDescriptor *descriptor = block->descriptor;
    
    int copyDisposeFlag = 1 << 25;
    int signatureFlag = 1 << 30;
    
    assert(block->flags & signatureFlag);
    
    int index = 0;
    if(block->flags & copyDisposeFlag)
        index += 2;
    
    return descriptor->rest[index];
}

#pragma mark- ESCBlockInvoker
@interface ESCJSFunctionCallback : NSInvocation

+ (id)callbackWithNSBlock:(id)blockObj;

- (id)evaluateWithArguments:(NSArray *)arguments;

@end

#pragma mark- ESCJSFunction

@interface ESCJSFunction ()

@property (nonatomic, weak) ESCJSContext *context;

@property (nonatomic) JSObjectRef func;

- (id)initWithContext:(ESCJSContext *)context function:(JSObjectRef)function;

@end

#pragma mark- ESCJSContext

@interface ESCJSContext ()

@property (nonatomic, assign) JSGlobalContextRef ctx;

@property (nonatomic, strong) NSMapTable *blockTable;

@property (nonatomic, strong) NSString *name;

@end


#endif
