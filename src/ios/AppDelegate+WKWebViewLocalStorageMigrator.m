#import <objc/runtime.h>
#import "AppDelegate.h"

@implementation AppDelegate (WKWebViewLocalStorageMigrator)

+ (void)load {
    NSFileManager* fileManager = [NSFileManager defaultManager];
     NSString* appLibraryFolder = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* src = [[NSString alloc] initWithString: [appLibraryFolder stringByAppendingPathComponent:@"WebKit/LocalStorage/file__0.localstorage"]];

    if (![fileManager fileExistsAtPath:src isDirectory:false]) {
        src = [[NSString alloc] initWithString: [appLibraryFolder stringByAppendingPathComponent:@"WebKit/Caches/file__0.localstorage"]];
    }
    
    NSError *fileError = nil;
    BOOL isDir;
    if (![fileManager fileExistsAtPath:src isDirectory:&isDir]) return;
    NSLog(@"Migration of local storage invoked...");
    NSString* dest = [[NSString alloc] initWithString: [appLibraryFolder stringByAppendingPathComponent:@"WebKit/WebsiteData/LocalStorage/file__0.localstorage"]];
    NSString* destFolder = [dest stringByDeletingLastPathComponent];
    if (![fileManager fileExistsAtPath:destFolder isDirectory:&isDir]){
        if(![fileManager createDirectoryAtPath:destFolder withIntermediateDirectories:YES attributes:nil error:&fileError]) {
            NSLog(@"Error creating target folder: %@", [fileError localizedDescription]);
            return;
        }
    }
    
    if ([fileManager copyItemAtPath:src toPath:dest error:&fileError]) {
        if (![fileManager removeItemAtPath:src error:&fileError]){
            NSLog(@"Error deleting file: %@", [fileError localizedDescription]);
        }
    }
    else {
        NSLog(@"Error copying file: %@", [fileError localizedDescription]);
    }
}

@end