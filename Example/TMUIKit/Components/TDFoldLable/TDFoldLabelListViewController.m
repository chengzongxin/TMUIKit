//
//  TDFoldLabelListViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2022/3/25.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import "TDFoldLabelListViewController.h"

static UIEdgeInsets const kLabelInset = {15,10,15,10};

#define kLabelMaxW (TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(kLabelInset))

@interface TDFoldAdapter : NSObject

@property (nonatomic, assign) TMUIFoldLabelType labelShowType;

@property (nonatomic, assign) BOOL isFold;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGFloat cellMaxWidth;

@property (nonatomic, assign) NSInteger maxLine;

@property (nonatomic, strong) NSAttributedString *attr;

@end

@implementation TDFoldAdapter

@end

@interface TDFoldLabelCell : UITableViewCell

@property (nonatomic, strong) TMUIFoldLabel *label;


@end

@implementation TDFoldLabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        TMUIFoldLabel *label = [[TMUIFoldLabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(kLabelInset);
        }];
        self.label = label;
    }
    return self;
}

@end

@interface TDFoldLabelListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <TDFoldAdapter *>* adapter;

@end

@implementation TDFoldLabelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _adapter = [NSMutableArray array];
    NSArray *contents = [self contents];
    for (int i = 0; i< contents.count; i++) {
        TDFoldAdapter *a = [TDFoldAdapter new];
//        a.labelShowType = TMUIFoldLabelType_ShowFoldAndUnfold; // 展开收起模式需要新增一开始是需要收起的情况
        a.maxLine = 3;
        a.cellMaxWidth = kLabelMaxW;
        a.attr = [self attrStr:contents[i]];
        a.cellHeight = [TMUIFoldLabel sizeForAttr:a.attr line:a.maxLine width:a.cellMaxWidth].height + UIEdgeInsetsGetVerticalValue(kLabelInset);
        [_adapter addObject:a];
    }
    
    [self.view addSubview:self.tableView];
}


#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.adapter.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDFoldLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TDFoldLabelCell.class) forIndexPath:indexPath];
    
    TDFoldAdapter *a = _adapter[indexPath.row];
    cell.label.type = a.labelShowType;
    cell.label.numberOfLines = a.maxLine;
    cell.label.maxWidth = a.cellMaxWidth;
    cell.label.attributedText = a.attr;
    @TMUI_weakify(a);
    cell.label.clickFold = ^(BOOL isFold, TMUIFoldLabel * _Nonnull label) {
        dispatch_block_t updateModelBlock = ^{
            @TMUI_strongify(a);
            a.maxLine = isFold ? 3 : 0;
            a.isFold = isFold;
            a.cellHeight = [label sizeForFits].height + UIEdgeInsetsGetVerticalValue(kLabelInset);
        };
        
//        if (@available(iOS 11.0, *)) {
//            [tableView performBatchUpdates:updateModelBlock completion:nil];
//        } else {
            updateModelBlock();
            [tableView reloadData];
//        }
        
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.adapter[indexPath.row].cellHeight;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:TDFoldLabelCell.class forCellReuseIdentifier:NSStringFromClass(TDFoldLabelCell.class)];
    }
    return _tableView;
}


- (NSAttributedString *)attrStr:(NSString *)str{
    NSParagraphStyle *style = [NSMutableParagraphStyle tmui_paragraphStyleWithLineSpacing:10 lineBreakMode:NSLineBreakByWordWrapping];
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:UIColor.tmui_randomColor,NSFontAttributeName:UIFont(18),NSParagraphStyleAttributeName:style}];
    return attr;
}


- (NSArray *)contents{
    return @[
      @"#装修小指南#    8张设计师手绘图详解全屋装修开关插座布局很实用的，可以参考一下噢",
      @"打造一间环保安全、用色大胆、创意有趣的儿童房，对孩子的成长有重要意义！??那装修完工的你，家里的儿童房是如何布局设计的？?#装修#全屋定制#好设计#",
      @"【小知识指南】全屋装修布局，常用人体工程学尺寸，超级有用! ????666",
      @"这套地中海风格的两居室装修效果图能够让你想象出一幅画面，浪涛拍岸，闲步的海鸟在沙滩上留下细小足迹，堤岸旁灯塔在艳阳下闪耀亮白光芒，日光晕眩中，彷似在海天一线处，看到哥伦布搭乘风帆的远飏，奔向自在未知的未来。",
      @"98平轻奢风装修案例 ??整体空间硬装以简洁大方为主，搭配现代舒适的家居，营造出一种闲适优雅的空间气质。",
      @"家有baby的生活方式????一间舒适、美观的儿童房，对孩子来说非常重要。??那是他们的小领地，里面有他们小小的秘密，许多的幻想，以及慢慢成长的痕迹。所以为了给孩子一个完美的独立空间，美好的童年，从儿童房开始…………#昆明装修#装修#儿童房#设计#维意#全屋定制#空间#",
      @"精装房时代的一站式家装，空间定制，省钱省事",
      @"??客厅的采光不好，卧室的墙壁也是可以拆除的，可以考虑在卧室的墙上装一扇窗户；白天的时候可以打开窗户，增加客厅的采光度，晚上关好窗户又保持了卧室的隐私性。",
      @"#昆明装修#家庭装修有没有做衣帽间?衣帽间应该怎么布局才能实用又漂亮衣帽间不只是满足女主人的化妆打扮需求，也可以起到全家收纳的作用，在装修时候可以考虑布局规划衣帽间??#维意#全屋定制#昆明装修#装修#好设计#",
      @"现代风，??空间以现代简约的装修基调，搭配上时尚自然的设计与元素??，整体透露出雅致舒适，给人以轻松自然的朴素感。??",
      @"??现在的孩子，几乎每天晚上回到家后，都是要在家写作业的，写作业就自然少不了一个书桌位置了，大家都想要给孩子提供一个舒心的环境，就来看看一些儿童房摆书桌的设计，赶紧给孩子们看看吧。---#装修#空间#书房设计#",
      @"#昆明装修#??90平米的简约美式风格两居，色彩上，以浅色为主，如浅灰、浅蓝、淡粉，营造出明亮、淡雅、柔和的空间感。简约素净的硬装，搭配精致优美的软装，恰到好处的华丽与浪漫，赋予了空间令人心动的美。",
      @"【装修设计】120㎡贵气十足的现代风格家居装修，金属质感搭配精致软装充分展现了主人对美好生活的追求与向往! ???",
      @"安宁楸木园量完房后，每一次与各户的沟通都会有不一样的收获，每一次的被肯定都是最有价值的成果。方案对接结束，回公司加班画图?? ??#昆明装修##设计#全屋定制#硬装软装#金马装饰#",
      @"面积78平米的简约风小户型三居室案例，原本是二房的户型，设计师为了满足屋主一家的居住需求，把餐厅改成了卧室，客餐厅结合起来，构造出了这样一个紧凑而又实用的小窝。#设计#全屋定制#",
      @"【昆明装修小知识分享】阳台，作为室内观景的活动空间，我们一般都习惯在阳台一侧打一个储物柜。但是现在的户型厨卫尺寸普遍偏小，那么我们又有洗衣机又有烘干机的情况下，可以考虑在阳台一侧做一个洗衣机柜。很多朋友说我不知道该怎么去设计这个位置，那么下面为您附上详细的图解，你的家也可以做的这样美美的。",
      @"效果图参考138平米的房子，以时尚大方的现代简约风格作为装修基础，在宽松的空间下，轻松自然的格局显得格外的舒适惬意。",
      @"装修之前如果没有做好准备，那么入住之后就会出现各种后悔的地方出现。今天就来说一说那些容易出现后悔的地方，提前预想一下，可以把这些地方提前做好。装修前要先知道自己家到底需要什么，喜欢什么，毕竟房子是自己家住的。没有特殊情况发生，一般都要住上十年以上吧。所以不管是从装修风格还是整体布局设计，大方向还是要有的，这样装修才能胸有成竹。都确认之后，在装修交底的时候也可以和设计师或者施工人员多沟通。他们的经验会比自己来说要强的太多，所以不妨听听他们的建议，特别是在一些细节的地方。这样也可以让你提前关注到一些可能遗忘或者没有想到的问题。玄关的底部留空至少15厘米的高度，这样就可以收纳常穿的鞋子，不需要开门收拾鞋，也不会让玄关乱糟糟的。常穿的鞋子也不好放在鞋柜里面，味道显然不好闻，还会把柜子弄脏的。玄关空间充足的话，尽可能的把鞋柜做成顶天立地的，不然就会产生卫生死角，打扫起来很不方便。玄关还可以增加不少“必须”的功能，比如换鞋凳、挂衣杆和换衣镜等等。厨房可以做砖夹橱柜，会比木质橱柜要好用太多了，打扫的时候直接用湿抹布直接就行，橱柜内部也可以用湿抹布或者直接用水冲。厨房的水槽要选用台下盆或者台中盆，这样橱柜台面上的水，就可以直接抹到水槽里面。在切菜区和水槽区也用上辅助灯源，这样就算是晚上，也不会担心切到手或者菜洗不干净的问题。不管客厅还是其他的地方，收纳空间还是要多做一点的。这样才能把家里的杂物基本都能塞进去，这样才能保证家里的干净整洁，以后买买买也可以不用太担心了。家里的家具底部最好要留出空间，这样打扫的时候也方便扫把进去，想要“偷懒”的可以用扫地机器人。卫生间用上镜面柜，这样的洗漱台就可以很干净整洁。墙面还可以安装吹风机收纳架、单杆毛巾架和其他的一些黏贴挂钩，足够收纳卫生间常用的物品。家里装修需要注意的细节实在是太多了，在装修之前可以用纸笔把每个空间想要的功能都一一记录下来。整理一下之前住的地方有什么不方便的地方，把这些遇到的“问题”和想要的功能整理一下，基本就是最适合自家的布局和细节了。在装修交底的时候，听听师傅们的建议，合适的就可以采用，让自己的家更“完美”一些。",
      @"#昆明金马装饰#??干湿分离，不再单单只是洗漱和厕所分开，而是怎么做得更加好看舒适！越来做多的人喜欢这样开放式的干湿分区了，你喜欢吗？#好设计#全屋定制#维意定制#",
      @"#昆明金马装饰#??文旅城装修日记细节四，融创文旅城14地块17栋大平层??设计效果图??。#设计#维意#定制全屋#",
      @"#昆明金马装饰#???? 小区地址:俊发城·金盏苑4栋；家居风格:现代简约；客户有一儿一女，女孩?? 10岁喜欢弹钢琴，男孩??3岁喜欢?? ? 玩具，3室的房子没有空间做父母房，所以两个儿童房都做了高低床，男孩房的空间比较紧凑，但睡眠，储衣，储书，学习功能都没有落下。#好设计#维意定制#全屋#儿童房设计#"];
}


@end
