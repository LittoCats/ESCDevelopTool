//
//  main.m
//  image resizer
//
//  Created by 程巍巍 on 12/31/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <CoreGraphics/CoreGraphics.h>

static NSString *kcfgstr = @"{\"readme\":[\"image-resizer [imagePath] [options] options\",\"example: image-resizer appicon.png -u icon -o ~/Desktop/appicon\",\"options\",\"\\t-h\\tshow this message\",\"\\t-o\\toutput dictionary, use current directory by default\",\"\\t-s\\tsize of the resized image. You can set more than size option divided by space .\",\"\\t-cfg\\tcustom config file path. A json file and must contain key named \'images\' with value typed array with object that contain key named size with value like 128*128 or 128 .\",\"\\t-u\\tuse of the resized images . This option can be \'icon\' or \'lanuchimage (ingore case). If set this option, option -s and -cfg will be ingored .\",\"Discussion : \\n\\tThe output image file has same name with the source image but append it\'s size pixel and type named png .\"],\"options\":{\"-o\":\"output\",\"-s\":\"size\",\"-cfg\":\"config_file\",\"-u\":\"use_type\"}}";
static NSMutableDictionary *kcfg;

static void showReadMe()
{
    for (NSString *readme in kcfg[@"readme"]) {
        printf("%s\n",[readme cStringUsingEncoding:NSUTF8StringEncoding]);
    }
}

static BOOL analyse_argv(int argc, const char * argv[], NSMutableDictionary *__autoreleasing* optionsPointer)
{
    if (argc < 2) {
        printf("need more argument .\n");
        
#ifdef DEBUG
        const char *argv_debug[] = {"image-resizer","test.png","-s","128*128","256"};
        argv = argv_debug;
        argc = 5;
#else
        exit(0);
#endif
    }
    
    NSMutableDictionary *options = *optionsPointer;
    NSString *key = @"image";
    options[key] = [NSMutableArray new];
    for (int i = 1; i < argc; i ++) {
        if (!strcmp(argv[i], "-h")) {
            showReadMe();
            return NO;
        }else if(argv[i][0] == '-'){
            key = kcfg[@"options"][[NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding]];
            if (key && !options[key]) {
                options[key] = [NSMutableArray new];
            }
            continue;
        }
        
        NSString *option = [NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding];
        [options[key] addObject:option];
    }
    
    return YES;
}

static BOOL analyse_source_image(NSMutableDictionary *__autoreleasing* optionsPointer){
    NSMutableDictionary *options = *optionsPointer;
    NSString *imagePath = [[options[@"image"] firstObject] stringByResolvingSymlinksInPath];
    if (!imagePath) return NO;
    NSBitmapImageRep *image = [NSBitmapImageRep imageRepWithContentsOfFile:imagePath];
    if (!image) return NO;
    
    options[@"image_name"] = [[imagePath lastPathComponent] stringByDeletingPathExtension];
    options[@"imageRep"] = image;
    
    return YES;
}

static void analyse_output_dir(NSMutableDictionary *__autoreleasing* optionsPointer){
    NSMutableDictionary *options = *optionsPointer;
    NSString *output_dir = [options[@"output"] stringByResolvingSymlinksInPath];
    if (!output_dir) output_dir = [NSString stringWithFormat:@"%s",getcwd(NULL, 0)];
    options[@"output_dir"] = output_dir;
}

static void analyse_config_size(NSMutableDictionary *__autoreleasing* optionsPointer){
    NSMutableDictionary *options = *optionsPointer;
    NSMutableArray *config = options[@"config"];
    if (!config) options[@"config"] = [NSMutableArray new];
    NSArray *size_config = options[@"size"];
    for (NSString *sizeStr in size_config) {
        NSMutableDictionary *config_item = [@{@"size":sizeStr} mutableCopy];
        [options[@"config"] addObject:config_item];
    }
}

static void analyse_config_file(NSMutableDictionary *__autoreleasing* optionsPointer){
    NSMutableDictionary *options = *optionsPointer;
    NSString *config_file_path = [options[@"config_file"] stringByResolvingSymlinksInPath];
    if (!config_file_path) return;
    
    NSData *config_file_data = [[NSData alloc] initWithContentsOfFile:config_file_path];
    NSError *error;
    NSDictionary *config = [NSJSONSerialization JSONObjectWithData:config_file_data options:NSJSONReadingMutableContainers error:&error];
    
    if (!config || error) return;
    options[@"full_config"] = config;
    config = config[@"images"];
    if (!config || ![config isKindOfClass:NSMutableArray.class]) return;
    
    options[@"config"] = config;
}

static void analyse_user_type(NSMutableDictionary *__autoreleasing* optionsPointer){
    NSMutableDictionary *options = *optionsPointer;
    NSString *useType = options[@"use_type"];
    NSDictionary *config = kcfg[useType];
    if (!config) return;
    options[@"config"] = config;
}

static CGSize size_from_str(NSString *sizeStr){
    NSArray *size_a = [[sizeStr stringByReplacingOccurrencesOfString:@"*" withString:@"x"] componentsSeparatedByString:@"x"];
    CGSize size = CGSizeZero;
    if (size_a.count > 0) size.width = [size_a[0] floatValue];
    if (size_a.count > 1) size.height = [size_a[1] floatValue]; else size.height = size.width;
    return size;
}

static NSData *resized_image_data(NSBitmapImageRep *imageRep, CGSize size){
    if (size.width < 2.0 || size.height < 2.0) return nil;
    
    CGRect rect = (CGRect){0,0,size.width/2, size.height/2};
    NSImage *output = [[NSImage alloc] initWithSize:rect.size];
    [output setPrefersColorMatch:YES];
    [output setUsesEPSOnResolutionMismatch:YES];
    
    [output lockFocus];
    [imageRep drawInRect:rect];
    [output unlockFocus];
    
    imageRep = [NSBitmapImageRep imageRepWithData:[output TIFFRepresentation]];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:@(YES) forKey:NSImageInterlaced];
    return [imageRep representationUsingType:NSPNGFileType properties:imageProps];
}

static void save_image_data(NSData *imageData, CGSize size, NSDictionary *options){
    NSString *image_file = [NSString stringWithFormat:@"%@/%@_%i_%i.png",options[@"output_dir"],options[@"image_name"],(int)size.width,(int)size.height];

    printf("resized image < %s > %s .\n",[[image_file lastPathComponent] cStringUsingEncoding:NSUTF8StringEncoding],
           [imageData writeToFile:image_file atomically:YES] ? "success" : "fail");
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        kcfg = [NSJSONSerialization JSONObjectWithData:[kcfgstr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableDictionary *options = [NSMutableDictionary new];
        if (analyse_argv(argc, argv, &options)) 
            if (analyse_source_image(&options)){
                analyse_output_dir(&options);
                analyse_config_size(&options);
                analyse_config_file(&options);
                analyse_user_type(&options);
                
                NSArray *resize_configs = options[@"config"];
                for (NSMutableDictionary *resize_cofnig in resize_configs) {
                    CGSize size = size_from_str(resize_cofnig[@"size"]);
                    NSData *imageData = resized_image_data(options[@"imageRep"], size);
                    if (imageData) save_image_data(imageData, size, options);
                }
            }
    }
    return 0;
}
