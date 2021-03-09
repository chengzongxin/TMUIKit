

| 关键策略（S）                             | 衡量标签（M）                        | 关键任务                                                     | 任务当前状态 | 任务进展 | 责任人         | 预计开始时间 | 预计完成时间 |
| ----------------------------------------- | ------------------------------------ | ------------------------------------------------------------ | ------------ | -------- | -------------- | ------------ | ------------ |
|                                           |                                      | 整理工程内当前一些第三方category, 并输出对应支持的功能点，哪些需要整合，哪些是重复要清理的，哪张是无用的，哪些是可以更优化的，并输出相关说明文档 | 未开始       | 0%       | 王春林、程宗鑫 | 2021/1/25    | 2021/2/28    |
| S3：TMUIKit库中category子功能库的持续完善 | M3：集成一些常用的第三方category功能 | 针对上述整理的文档清单，按TMUIKit的规范将相关功能点代码类重新封装集成到TMUIKit库，且需要输出相关自测Demo | 未开始       | 0%       | 王春林、程宗鑫 | 2021/3/1     | 2021/3/31    |
|                                           |                                      | 以TMUIKit库中的新方法替换原工程里的相关旧方法，并移除工程里对应修改后无用的第三方category类文件 | 未开始       | 0%       | 王春林、程宗鑫 | 2021/4/1     | 2021/4/30    |



```
1. 删除文件

NSDate+THKCalendarLogic.h => NSDate+TMUI.h
NSDate+Extension.h => NSDate+TMUI.h

UIImage+Compression.h => UIIMage+TMUI.h
UIImage+Scale => UIIMage+TMUI.h

NSAttributedString+TSize.h => NSAttributedString+TMUI.h

UILabel+TCategory.h => UILable+TMUI.h

NSDictionary+TCategory.h => UIColor+TMUI.h

UIColor+HexString.h => UIColor+TMUI.h

UIView+TCategory => UIView+TMIUI.h
UIView+TNib => UIView+TMIUI.h

NSURL+TCategory.h => NSURL+TMUI.h

NSArray+TCategory.h => NSArray+TMUI.h


UITableView+TCategory.h => UITableView+TMUI.h
UITableView+TNib.h => UITableView+TMUI.h
UITableView+TRegisterCell.h => UITableView+TMUI.h

UICollectionView+TNib.h => UICollectionView+TMUI.h

NSObject+TCategory => NSObject+TMUI


2. 改动待验证

TNormalDiaryListBaseVC 删除了[super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];需要测试
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];

```

