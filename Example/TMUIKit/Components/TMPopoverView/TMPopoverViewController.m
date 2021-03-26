//
//  TMPopoverViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/25.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMPopoverViewController.h"
#import "TMMyPopoverViewController.h"

@interface TMPopoverViewController ()

@property (nonatomic, strong) UIButton *b1;

@end

@implementation TMPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(@"#FFFFFF");
    
//    UIView *myView = View.bgColor(@"green").addTo(self.view).makeCons(^{
//        make.top.left.width.height.constants(100,20,100,100);
//    });
//
//    UIView *v2 = View.bgColor(@"red").addTo(self.view).makeCons(^{
//        make.top.equal.view(myView).bottom.constants(20);
//        make.left.width.height.constants(20,100,100);
//    });
    
    id l1 = Label.str(@"提供类似系统UIPopoverController的显示效果的视图类").styles(body);
    
    id b1 = Button.str(@"TMPopoverView").styles(button).fixWH(300,44).onClick(SEL_STRING(showTMPopoverView));
    
    VerStack(l1,b1,CUISpring).embedIn(self.view, NavigationContentTop + 20,20,20).gap(15);
    
    _b1 = b1;
}



- (void)showTMPopoverView{
    CUIStaticTableView *gouptv =
    GroupTV(
            Section(
                    Row.str(@"TMPageViewController").fnt(18).detailStr(@"简单代理实现滑动吸顶header，动态tab子VC").subtitleStyle.cellHeightAuto.onClick(^{
                            
                        }),
                    
                    Row.str(@"TMUITableView").fnt(18).detailStr(@"多样式UITableView").subtitleStyle.cellHeightAuto.onClick(^{
                        }),
                    )
            ).header(@0.01).footer(@0.01);
    TMPopoverView *popView = [TMPopoverView popoverViewWithContentView:gouptv contentSize:CGSizeMake(300, 100)];
    CGRect fromFrame = [_b1 tmui_convertRect:_b1.frame toViewOrWindow:self.view];
    [popView showFromRect:fromFrame inView:self.view arrowDirection:TMPopoverArrowDirectionUp];
}



- (void)tapView:(UIView *)myView{
    
    // Present the view controller using the popover style.

    TMMyPopoverViewController *myPopoverViewController = TMMyPopoverViewController.new;
   myPopoverViewController.modalPresentationStyle =UIModalPresentationPopover;
   [self presentViewController:myPopoverViewController animated:YES completion:nil];

   // Get the popover presentation controller and configure it.
   UIPopoverPresentationController*presentationController = [myPopoverViewController popoverPresentationController];

   presentationController.permittedArrowDirections =UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight;

   presentationController.sourceView = myView;
   presentationController.sourceRect = myView.frame;
}

@end
