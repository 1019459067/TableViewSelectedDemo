//
//  ViewController.m
//  TableViewSelectedDemo
//
//  Created by HN on 2020/2/27.
//  Copyright © 2020 HN. All rights reserved.
//

#import "ViewController.h"
#import "BusinessInvitationCell.h"
#import "MJRefresh.h"
#import "BusinessInvitationToolBar.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, BusinessInvitationToolBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *toolBarContentBg;
@property (weak, nonatomic) IBOutlet UIView *toolBarContent;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarContentBgConstraintH;

@property (nonatomic, strong) BusinessInvitationToolBar *toolBar;

@property (nonatomic, strong) UIBarButtonItem *itemMgr;
@property (nonatomic, strong) UIBarButtonItem *itemDone;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL bManaged;
@property (nonatomic, assign) BOOL bSelectedAll;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNav];

    [self settingUI];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataArray removeAllObjects];
        [weakSelf requestListData];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestListData];
    }];

    self.toolBarContentBgConstraintH.constant = 0;
}

- (void)setupNav
{
    self.navigationItem.title = @"列表的单选、多选及删除";
    self.itemMgr = [[UIBarButtonItem alloc] initWithTitle:@"管理"
                                                    style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:@selector(mgrActionHandler)];
    
    self.itemDone = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(doneActionHandler)];
    self.navigationItem.rightBarButtonItem = self.itemMgr;
}

- (void)settingUI
{
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self registerReuseCell];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.toolBar = [BusinessInvitationToolBar contentViewWithDelegate:self];
    self.toolBar.delegate = self;
    [self.toolBarContent addSubview:self.toolBar];
}

- (void)registerReuseCell
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BusinessInvitationCell class])
                                               bundle:nil]
         forCellReuseIdentifier:NSStringFromClass(BusinessInvitationCell.class)];
}

#pragma mark - other
- (void)refreshUI
{
    [self updateToolbar];
    [self.tableView reloadData];
}

- (void)updateViewWithManaged:(BOOL)bManaged
{
    // 处理数据
    for (BusinessInvitation *model in self.dataArray) {
        model.bManaged = bManaged;
        model.bSelected = NO;
    }
    
    self.bManaged = bManaged;

    self.toolBarContent.hidden = bManaged ? NO : YES;
    // SCREEN_SAFE_AREA_MARGIN_BOTTOM iphoneX 以上设备判断
    self.toolBarContentBgConstraintH.constant = bManaged ? 54 : 0;

    [self refreshUI];
}

- (void)updateToolbar
{
    NSMutableArray *selecetedArray = [NSMutableArray array];
    for (BusinessInvitation *model in self.dataArray) {
        if (model.bSelected) {
            [selecetedArray addObject:model];
        }
    }
    
    NSInteger num = selecetedArray.count;
    self.toolBar.number = num;
    if (num) {
        self.toolBar.selectedButton.selected = num == self.dataArray.count ? YES:NO;
        self.bSelectedAll = num == self.dataArray.count ? YES:NO;
    } else {
        self.toolBar.selectedButton.selected = NO;
        self.bSelectedAll = NO;
    }
}

#pragma mark - ActionHandler
- (void)doneActionHandler
{
    self.navigationItem.rightBarButtonItem = self.itemMgr;
    [self updateViewWithManaged:NO];
}

- (void)mgrActionHandler
{
    self.navigationItem.rightBarButtonItem = self.itemDone;
    [self updateViewWithManaged:YES];
}

#pragma mark - BusinessInvitationToolBarDelegate
- (void)businessInvitationToolBar:(BusinessInvitationToolBar *)contentView didDelete:(UIButton *)sender
{
    // to do
    sender.enabled = NO;
    
    NSMutableArray *selecetedArray = [NSMutableArray array];
    for (BusinessInvitation *model in self.dataArray) {
        if (model.bSelected) {
            [selecetedArray addObject:model];
        }
    }
    
    [self.dataArray removeObjectsInArray:selecetedArray];
    [self refreshUI];

}

- (void)businessInvitationToolBar:(BusinessInvitationToolBar *)contentView didSelect:(UIButton *)sender
{
    self.bSelectedAll = sender.selected;
    
    for (BusinessInvitation *model in self.dataArray) {
        model.bManaged = YES;
        model.bSelected = self.bSelectedAll;
    }
    
    [self refreshUI];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessInvitationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(BusinessInvitationCell.class)];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [BusinessInvitationCell heightWithModel:self.dataArray[indexPath.row]];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bManaged) {
        // 刷新某一行cell
        BusinessInvitation *modelSelected = self.dataArray[indexPath.row];
        for (BusinessInvitation *model in self.dataArray) {
            if (model == modelSelected) {
                model.bSelected = !model.bSelected;
            }
        }
        
        [self updateToolbar];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - Getter or setter
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [self.dataArray addObjectsFromArray:[self getSimulatorData:5]];
    }
    return _dataArray;
}

- (void)requestListData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [self.dataArray addObjectsFromArray:[self getSimulatorData:5]];
        
        [self refreshUI];
    });
}

- (NSMutableArray *)getSimulatorData:(NSInteger)number
{
    NSString *text = @"据印度媒体报道，自今年1月中旬以来，印度古吉拉特邦和拉贾斯坦邦遭受严重蝗灾袭击，受灾面积超过20万公顷，近三成农作物受损，数十万农民生产生活受到影响。2月17日，印度农业部门组织工作组赴灾区调研，评估此次蝗灾的影响。\n印度农业专家德拉克·夏尔玛表示，此次蝗灾对印度本土的农业生产和经济影响较大，如果无法得到有效控制，可能将进一步影响南亚其他国家。夏尔玛认为，此次蝗灾主要在南亚、西亚、东非等地暴发。尽管粮农组织事先对此进行了预警，但对印巴而言仍显得有些准备不足。他表示，在印巴两国肆虐的蝗虫属于沙漠蝗虫，考虑到该地区的地形条件，蝗虫经印度或巴基斯坦向中国境内迁入的可能性很小。\n此前，中国农科院植物保护研究所研究员张泽华表示，沙漠蝗直接迁飞进入我国内陆地区可能性极小，但如果境外沙漠蝗得不到控制，夏季进入我国境内的概率将升高。";
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < number; i++) {
        BusinessInvitation *model = [[BusinessInvitation alloc]init];
        // 获取一个随机数范围在：[1,220]，包括20，包括220
        int num = 1 +  (arc4random() % 201);
        model.title = [text substringToIndex:num];
        // 根据状态初始化数据
        model.bSelected = self.bSelectedAll;
        model.bManaged = self.bManaged;
        [array addObject:model];
    }
    return array;
}
@end
