//
//  ESCImageGallery+Private.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/12/14.
//	Copyright (c) 12/12/14 Littocats. All rights reserved.
//

#import "ESCImageGallery+Private.h"

@implementation ESCImageGallery (Private)

- (NSDictionary *)__imageWithInfo:(id)info
{
    NSMutableDictionary *imageInfo = [NSMutableDictionary dictionaryWithObject:info forKey:@"source"];
    UIImage *image = [self.delegate respondsToSelector:@selector(imageGallery:imageWithInfo:)] ? [self.delegate imageGallery:self imageWithInfo:imageInfo] : nil;
    
    if (!image) {
        if ([info isKindOfClass:UIImage.class]) {
            // 如果 info 是 UIImage
            [imageInfo setObject:info forKey:@"image"];
        }else if ([info isKindOfClass:NSString.class]){
            // 如果是 imageFilePath
            image = [UIImage imageWithContentsOfFile:info];
            if (image) [imageInfo setObject:image forKey:@"image"];
        }else if ([info isKindOfClass:NSURL.class]){
            // 如果是 url 则异步下载
            [imageInfo setObject:info forKey:@"url"];
        }
    }else{
        [imageInfo setObject:image forKey:@"image"];
    }
    
    UIImage *imageHolder = [self.delegate respondsToSelector:@selector(imageGallery:imageHolderWithInfo:)] ? [self.delegate imageGallery:self imageHolderWithInfo:info] : nil;
    if (imageHolder)[imageInfo setObject:imageHolder forKey:@"imageHolder"];
    
    return imageInfo;
}

void kESCImageGalleryDownloader(NSMutableDictionary * imageInfo){
    if (!imageInfo) return ;
    NSURL *url = [imageInfo objectForKey:@"url"]; if (!url) return;
    
    //如果正在下载，则不在下载
    if ([[imageInfo objectForKey:@"loading"] boolValue]) return;
    [imageInfo setObject:@(YES) forKey:@"loading"];
    
    __ESCImageView *imageView = [imageInfo objectForKey:@"imageView"];
    if (imageView) [imageView __showLoading];
    
    __weak typeof(imageInfo) weakImageInfo = imageInfo;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLResponse *response;
        NSError *error;
        NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        __strong typeof(weakImageInfo) strongImageInfo = weakImageInfo; if (!strongImageInfo) return ;
        [strongImageInfo removeObjectForKey:@"loading"];
        if (error) {
            [strongImageInfo setObject:error forKey:@"error"];
        }else{
            UIImage *image = [UIImage imageWithData:imageData];
            if (!image) {
                [strongImageInfo setObject:response.MIMEType forKey:@"error"];
            }else{
                [strongImageInfo setObject:image forKey:@"image"];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakImageInfo) strongImageInfo = weakImageInfo; if (!strongImageInfo) return ;
            __ESCImageView *imageView = [strongImageInfo objectForKey:@"imageView"];
            if (imageView){
                [imageView __updateImage];
            }
        });
    });
};
@end
