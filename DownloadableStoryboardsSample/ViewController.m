//
//  ViewController.m
//  DownloadableStoryboardsSample
//
//  Created by yuta-tokoro on 11/12/13.
//  Copyright (c) 2013 cookpad. All rights reserved.
//

#import "ViewController.h"
#import "SSZipArchive.h"

@interface ViewController () <SSZipArchiveDelegate>
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)startDownload
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSURLSession* session = [NSURLSession sharedSession];
    NSURL* url = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/10351676/storyboards.bundle.zip"];

    NSURLSessionTask* task;
    task = [session dataTaskWithURL:url
                  completionHandler:^(NSData* data, NSURLResponse* response, NSError* error)
    {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSString* zipFileName = [self writeZipToFileWithData:data];
            [self unzipBundleWithZipFileName:zipFileName];
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [task resume];
}

- (NSString*)writeZipToFileWithData:(NSData*)data
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:@"storyboards.zip"];
    [data writeToFile:path atomically:YES]; 
    return path;
}

- (NSString*)unzipBundleWithZipFileName:(NSString*)zipFileName
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:@""];
    [SSZipArchive unzipFileAtPath:zipFileName toDestination:path delegate:self];
    return path;
}

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString*)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString*)unzippedPath
{
    NSLog(@"unzipped: %@", unzippedPath);
    NSString* bundlePath = [unzippedPath stringByAppendingPathComponent:@"storyboards.bundle"];
    NSLog(@"bundlePath: %@", bundlePath);

    NSURL* url = [NSURL fileURLWithPath:bundlePath];
    NSBundle* bundle = [NSBundle bundleWithURL:url];

    NSLog(@"bundle: %@", bundle);

    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Downloadable" bundle:bundle];
    NSLog(@"storyboard: %@", storyboard);
    UIViewController* viewController = [storyboard instantiateInitialViewController];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:viewController animated:YES completion:nil];
    });
}
@end
