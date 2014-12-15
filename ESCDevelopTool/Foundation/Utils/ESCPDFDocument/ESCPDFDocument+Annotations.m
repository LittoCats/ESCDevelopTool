//
//  ESCPDFDocument+Annotations.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/28/14.
//	Copyright (c) 11/28/14 Littocats. All rights reserved.
//

#import "ESCPDFDocument+Private.h"

@implementation ESCPDFDocument (Annotations)

- (NSDictionary *)__DetailWithAnnotationDictionary:(CGPDFDictionaryRef)annot
{

    
    return nil;
}

- (NSDictionary *)__ScanPage:(CGPDFPageRef)page
{
    if (!self._opTable) self._opTable = [self __operatorTableInit];

    NSMutableDictionary *info = [NSMutableDictionary new];
    
    CGPDFContentStreamRef contentStream = CGPDFContentStreamCreateWithPage(page);
    CGPDFScannerRef scanner = CGPDFScannerCreate(contentStream, self._opTable, (__bridge void *)(info));
    CGPDFScannerScan(scanner);
    
    CGPDFScannerRelease(scanner);
    CGPDFContentStreamRelease(contentStream);
 
    return info;
}

- (CGPDFOperatorTableRef)__operatorTableInit
{
    CGPDFOperatorTableRef ot = CGPDFOperatorTableCreate();
    CGPDFOperatorTableSetCallback (ot, "MP", &op_MP);
    CGPDFOperatorTableSetCallback (ot, "DP", &op_DP);
    CGPDFOperatorTableSetCallback (ot, "BMC", &op_BMC);
    CGPDFOperatorTableSetCallback (ot, "BDC", &op_BDC);
    CGPDFOperatorTableSetCallback (ot, "EMC", &op_EMC);
    return ot;
}

#pragma mark- operator table callback
static void op_MP (CGPDFScannerRef s, void *info)
{
    const char *name;
    
    if (!CGPDFScannerPopName(s, &name))
        return;
    
    printf("op_MP /%s\n", name);
}
static void op_DP (CGPDFScannerRef s, void *info)
{
    const char *name;
    
    if (!CGPDFScannerPopName(s, &name))
        return;
    
    printf("op_DP /%s\n", name);
}
static void op_BMC (CGPDFScannerRef s, void *info)
{
    const char *name;
    
    if (!CGPDFScannerPopName(s, &name))
        return;
    
    printf("op_BMC /%s\n", name);
}
static void op_BDC (CGPDFScannerRef s, void *info)
{
    const char *name;
    
    if (!CGPDFScannerPopName(s, &name))
        return;
    
    printf("op_BDC /%s\n", name);
}
static void op_EMC (CGPDFScannerRef s, void *info)
{
    const char *name;
    
    if (!CGPDFScannerPopName(s, &name))
        return;
    
    printf("op_EMC /%s\n", name);
}
@end
