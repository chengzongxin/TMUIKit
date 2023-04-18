//
//  VerifyViewController.m
//  TMUIKit_Example
//
//  Created by cl w on 2021/2/1.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "VerifyViewController.h"
//#import "NSString+Verify.h"
#import "NSFileManager+TMUI.h"
#import "NSString+TMUI.h"
#import <NSArray+TMUI.h>
#import <objc/runtime.h>
#import <NSDictionary+TMUI.h>
#import <NSMutableDictionary+TMUI.h>

@interface VerifyViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tf;
@property (nonatomic, copy) NSMutableArray *mArr;

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
    
    NSString *obj1 = [NSString new];
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
    
    //NSLog(@"");
    
    //NSString *str = [@"" tmui_md5];
    //NSLog(@"");
    
    /** Usages: */
    NSArray *numbers = @[@3,@2,@10];
    id result = [numbers tmui_reduce:^id _Nonnull(NSNumber *obj1, NSNumber *obj2) {
      return @(obj1.intValue + obj2.intValue);
    } initial:@2];
        
    NSLog(@"%@", result);
    
//    NSArray *p = [NSArray alloc];//__NSPlaceholderArray
//    NSArray *o = @[];//__NSArray0
//    NSArray *s = @[@0];//__NSSingleObjectArrayI
//    NSArray *i = @[@2,@3];//__NSArrayI
//    NSMutableArray *m = @[@4,@5].mutableCopy;//__NSArrayM
//
//    Class cls1 = NSClassFromString(@"__NSCFArray"); //super NSMutableArray
//    Class cls2 = NSClassFromString(@"__NSFrozenArrayM");//super NSArray
    
    NSLog(@"");
    [self subClasses:NSClassFromString(@"NSArray")];//30
    [self subClasses:NSClassFromString(@"NSMutableArray")];
    [self subClasses:NSClassFromString(@"NSString")];//22
    /*_UITextAttributeDictionary,
     WebElementDictionary,
     FigFlatToNSDictionaryWrapper,
     CTFeatureSetting,
     CNWrappedDictionary,
     _PASLPDictionary,
     _PFResultObject,
     NSOwnedDictionaryProxy,
     NSDistributedObjectsStatistics,
     NSSimpleAttributeDictionary,
     NSFileAttributes,
     NSAttributeDictionary,
     NSKeyValueChangeDictionary,
     __NSSingleEntryDictionaryI,
     __NSFrozenDictionaryM,
     __NSDictionaryI,
     _NSConstantDictionary,
     NSMutableDictionary,
     NSConstantDictionary,
     __NSDictionary0*/
    [self subClasses:NSClassFromString(@"NSDictionary")];//20
    /*MLProbabilityDictionary,
     NSKnownKeysDictionary,
     NSDirInfo,
     NSRTFD,
     NSSharedKeyDictionary,
     _UITextAttributeDictionaryImplI,
     _UIMutableTextAttributeDictionary,
     _NSNestedDictionary,
     __NSDictionaryM,
     __NSCFDictionary,
     __NSPlaceholderDictionary*/
    [self subClasses:NSClassFromString(@"NSMutableDictionary")];
    
    NSObject *obj = nil;
    NSDictionary *dict = @{@"1":@1,@"2":@2,@"3":obj};
    NSLog(@"");
    
    NSMutableDictionary *mDict = @{}.mutableCopy;
    [mDict setObject:@"1" forKey:@"222"];
    [mDict setObject:nil forKey:@"222"];
    [mDict setObject:@"1" forKey:nil];
    
    [mDict setObject:@"v" forKeyedSubscript:@"1"];
    [mDict setObject:nil forKeyedSubscript:@"1"];
    [mDict setObject:@"l" forKeyedSubscript:nil];
    
//    [mDict ];
    
    NSLog(@"");
}

- (NSArray <NSString *> *)subClasses:(Class)superClass
{
    int numClasses;
    Class *classes = NULL;
    numClasses = objc_getClassList(NULL,0);
    NSMutableArray *lst = @[].mutableCopy;
    if (numClasses >0 )
    {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i++) {
            if (class_getSuperclass(classes[i]) == superClass){
                NSLog(@"%@", NSStringFromClass(classes[i]));
                [lst addObject:NSStringFromClass(classes[i])];
            }
        }
        free(classes);
    }
    return lst;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.chun
}
*/

@end
