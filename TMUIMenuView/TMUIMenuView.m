//
//  TMUIFloatMenuView.m
//  TMUIKit_Example
//
//  Created by 熊熙 on 2022/4/25.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import "TMUIMenuView.h"

static const CGFloat TMUITopToView = 10.0f;
static const CGFloat TMUILeftToView = 10.0f;
#define CellLineEdgeInsets UIEdgeInsetsMake(0, 10, 0, 10)
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight        [UIScreen mainScreen].bounds.size.height


@implementation TMUIMenuItemModel

@end

@implementation TMUIMenuViewConfig

@end


@implementation TMUIMenuView
{
    NSArray *_titleArray;
    NSArray *_imageArray;
    NSArray *_menuItems;
    TMUIMenuViewConfig *_config;
    TMUITriangleDirection _direct;
    NSArray<TMUIMenuItemModel*>  *_items;
    UITableView *_tableView;
}


+ (void)popupMenuOnView:(UIView *)view {
    
}

- (id)initWithMenuItems:(NSArray<TMUIMenuItemModel *> *)items MenuConfig:(TMUIMenuViewConfig *)config {
    if (self = [super init]) {
        _items = [items copy];
        _config = [config copy];
    }
    return self;
}

- (id)initWithTitleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray origin:(CGPoint)origin width:(CGFloat)width rowHeight:(CGFloat)rowHeight Direct:(TMUITriangleDirection)triDirect
{
    if (self = [super init]) {
        _titleArray = [titleArray copy];
        _imageArray = [imageArray copy];
        
        if (_config == nil) {
            _config = [[TMUIMenuViewConfig alloc] init];
            _config.menuOrigin = origin;
            _config.menuWidth = width;
            _config.triDirect = triDirect;
        }
        
        [self configMenuView:_config];
    }
    return self;
}

- (void)configMenuView:(TMUIMenuViewConfig *)config {
    CGFloat height = _config.rowHeight < 44 ? 44 : _config.rowHeight;
    
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor clearColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(TMUILeftToView + _config.menuOrigin.x, TMUITopToView + _config.menuOrigin.y, _config.menuWidth, _items.count*height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
    _tableView.layer.cornerRadius = 5;
    _tableView.bounces = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ide"];
    
    //设置cell举例table的距离
    _tableView.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5);
    
    //分割线位置
    _tableView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    [self addSubview:_tableView];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ide"];
    cell.backgroundColor = [UIColor clearColor];
    
    //设置cell的选中状态
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = [UIColor blackColor];
    
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    [cell.textLabel sizeToFit];
    
    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(MenuItemDidSelected:indexPath:)]) {
        [self.delegate MenuItemDidSelected:tableView indexPath:indexPath];
    }
    if (self.selectedBlock) {
        self.selectedBlock(indexPath.row);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissMenuView:nil];
}

- (void)dismissMenuView:(dismissCompletion)completion
{
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.alpha = 0;
        if (_direct == TMUILeftTriangle) {
            _tableView.frame = CGRectMake(TMUILeftToView + _config.menuOrigin.x, TMUITopToView + _config.menuOrigin.y, 0, 0);
        }
        else
        {
            _tableView.frame = CGRectMake(TMUILeftToView + _tableView.frame.size.width + 5, TMUITopToView + _config.menuOrigin.y, 0, 0);
        }
        _tableView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

- (void)drawRect:(CGRect)rect
{
    //拿到当前视图准备好的画板
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    
    CGContextBeginPath(context);//标记
    
    if (_direct == TMUILeftTriangle)
    {
        CGContextMoveToPoint(context,
                             (_config.menuOrigin.x + TMUILeftToView) + 10, (_config.menuOrigin.y + TMUITopToView) - 5);//设置起点
        
        CGContextAddLineToPoint(context,
                                (_config.menuOrigin.x + TMUILeftToView) + 5, (_config.menuOrigin.y + TMUITopToView));
        
        CGContextAddLineToPoint(context,
                                (_config.menuOrigin.x + TMUILeftToView) + 15, (_config.menuOrigin.y + TMUITopToView));
    }
    else
    {
        CGContextMoveToPoint(context,
                             (TMUILeftToView +  _tableView.frame.size.width) + 0, (_config.menuOrigin.y + TMUITopToView) - 5);//设置起点
        
        CGContextAddLineToPoint(context,
                                (TMUILeftToView + _tableView.frame.size.width) - 5, (_config.menuOrigin.y + TMUITopToView));
        
        CGContextAddLineToPoint(context,
                                (TMUILeftToView + _tableView.frame.size.width) + 5, (_config.menuOrigin.y + TMUITopToView));
    }
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
//    [self.tableView.backgroundColor setFill]; //设置填充色
//
//    [self.tableView.backgroundColor setStroke]; //设置边框颜色
    
    CGContextDrawPath(context,
                      kCGPathFillStroke);//绘制路径path

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissMenuView:^{
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
