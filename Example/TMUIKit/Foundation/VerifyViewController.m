//
//  VerifyViewController.m
//  TMUIKit_Example
//
//  Created by cl w on 2021/2/1.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "VerifyViewController.h"
#import "NSString+Verify.h"
#import "NSFileManager+TMUI.h"
#import "NSString+TMUI.h"

@interface VerifyViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tf;

@end

@implementation VerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSMutableString *mstr = @"".mutableCopy;
    
    NSLog(@"%@",NSHomeDirectory());
    
    NSString *str1 = nil;
    BOOL flag1 = [NSString tmui_isEmpty:str1];
    [mstr appendFormat:@"str1:%@ is empty %d\n\n",str1,flag1];
    
    NSString *obj1 = [NSObject new];
    BOOL flag2 = [NSString tmui_isEmpty:obj1];
    [mstr appendFormat:@"obj1:%@ is empty %d\n\n",obj1,flag2];
    
    NSString *str2 = @"         ";
    BOOL flag3 = [NSString tmui_isEmpty:str2];
    [mstr appendFormat:@"str2:%@ is empty %d\n\n",str2,flag3];
    
    NSString *str3 = @"";
    BOOL flag4 = [NSString tmui_isEmpty:str3];
    [mstr appendFormat:@"str3:%@ is empty %d\n\n",str3,flag4];
    
    NSString *str4 = @"121333";
    BOOL flag5 = [NSString tmui_isEmpty:str4];
    [mstr appendFormat:@"str4:%@ is empty %d\n\n",str4,flag5];
    
    _tf.text = mstr;
    _tf.userInteractionEnabled = NO;
    
    [[NSFileManager defaultManager] tmui_createFileAtSandboxRootDirWithPathComponent:@"123/" isDirectory:NO removeOldFile:YES];
    [[NSFileManager defaultManager] tmui_createFileAtSandboxRootDirWithPathComponent:@"tbt/" isDirectory:YES removeOldFile:YES];
    [[NSFileManager defaultManager] tmui_createFileAtSandboxDocumentsDirWithPathComponent:@"/doc" isDirectory:NO removeOldFile:YES];
    [[NSFileManager defaultManager] tmui_createFileAtSandboxTmpDirWithPathComponent:@"/tmp" isDirectory:YES removeOldFile:YES];
    [[NSFileManager defaultManager] tmui_createFileAtSandboxCachesDirWithPathComponent:@"/xxx.jpg" isDirectory:NO removeOldFile:YES];
    
    NSString *lastPath = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastPath"];
    if (lastPath.length) {
        NSString *newPath = [[NSFileManager defaultManager] tmui_pathByReplacingSandboxDir:lastPath];
        NSLog(@"newPath: %@",newPath);
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@%@",[NSFileManager defaultManager].tmui_sandboxRootDir,@"/123"] forKey:@"lastPath"];
    
    NSLog(@"tmp: %@",[[NSFileManager defaultManager] tmui_sandboxTmpDir]);
    NSLog(@"caches: %@",[[NSFileManager defaultManager] tmui_sandboxCachesDir]);
    NSLog(@"doc: %@",[[NSFileManager defaultManager] tmui_sandboxDocDir]);
    
    NSLog(@"");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
