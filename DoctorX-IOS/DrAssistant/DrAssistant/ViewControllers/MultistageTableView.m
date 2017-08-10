//
//  MultistageTableView.m
//  MultistageTableVIewTest


#import "MultistageTableView.h"

#define DEFAULT_HEADER_HEIGHT   44.0f

@implementation MultistageTableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.currentOpenedIndexPaths = [NSMutableArray array];
        
        self.tableView = [[UITableView alloc] initWithFrame:frame];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        [self addSubview:self.tableView];
    }
    return self;
}

#pragma mark - public methods

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    return [self.tableView dequeueReusableCellWithIdentifier:identifier];
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (id)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier {
    return [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)beginUpdates{
    [self.tableView beginUpdates];
}
- (void)endUpdates{
    [self.tableView endUpdates];
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];

}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self.tableView reloadSections:sections withRowAnimation:animation];
}
- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    [self.tableView moveSection:section toSection:newSection];
}
- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath{
    [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}



#pragma mark - private methods

/**
 *  为view添加一个tap手势，其行为为action
 *
 *  @param action 要添加的手势含有的行为
 *  @param view   要添加手势的视图
 */
- (void)addTapGestureRecognizerAction:(SEL)action toView:(UIView *)view {
    if (view) {
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
        [view addGestureRecognizer:tapGR];
    }
}

/**
 *  为view移除一个tap手势
 *
 *  @param view 要移除手势的view
 */
- (void)removeTapGestureRecognizerInView:(UIView *)view {
    if (view) {
        NSArray *gestures = view.gestureRecognizers;
        for (UIGestureRecognizer *gr in gestures) {
            if ([gr.view isEqual:view]) {
                [view removeGestureRecognizer:gr];
            }
        }
    }
}

#pragma mark - private methods for open or close header

/**
 *  展开一个header所新增加的行
 *
 *  @param section 待展开的一组数据所在的section
 *
 *  @return 该section内所有indexPath信息
 */
- (NSMutableArray *)indexPathsForOpenHeaderInSection:(NSInteger)section {
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    //询问数据源行数
    NSInteger rowCount = [self get_numberOfRowsInSection:section];
    
    //调用代理
    if ([self.delegate respondsToSelector:@selector(m_TableView:willOpenHeaderAtSection:)]) {
        [self.delegate m_TableView:self willOpenHeaderAtSection:section];
    }
    
    //打开了第section个子列表
    [self.currentOpenedIndexPaths addObject:[NSIndexPath indexPathForRow:-1 inSection:section]];
    
    //在当期列表中添加rowCount行数据
    for (int i = 0; i < rowCount; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    return indexPaths;
}

- (NSMutableArray *)indexPathsForCloseHeaderInSection:(NSInteger)section {
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    //询问数据源行数
    NSInteger rowCount = [self get_numberOfRowsInSection:section];
    
    //调用代理
    if ([self.delegate respondsToSelector:@selector(m_TableView:willCloseHeaderAtSection:)]) {
        [self.delegate m_TableView:self willCloseHeaderAtSection:section];
    }
    
    //关闭第section个子列表
    [self.currentOpenedIndexPaths removeObject:[NSIndexPath indexPathForRow:-1 inSection:section]];
    
    for (int i = 0; i < rowCount; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    return indexPaths;
}

- (void)openOrCloseHeaderWithSection:(NSInteger)section {
    
    NSMutableArray *openedIndexPaths = [NSMutableArray array];
    NSMutableArray *deleteIndexPaths = [NSMutableArray array];
    
    //如果当前没有任何子列表被打开
    if (self.currentOpenedIndexPaths.count == 0) {
        openedIndexPaths = [self indexPathsForOpenHeaderInSection:section];
    } else {
        BOOL found = NO;
        
        for (NSIndexPath *ip in self.currentOpenedIndexPaths) {
            //如果是关闭当前已经打开的子列表
            if (ip.section == section) {
                found = YES;
                deleteIndexPaths = [self indexPathsForCloseHeaderInSection:section];
                break;
            }
        }
        
        //打开新的子列表
        if (!found) {
            openedIndexPaths = [self indexPathsForOpenHeaderInSection:section];
        }
    }
    
    [self.tableView beginUpdates];
    if (openedIndexPaths.count > 0) {
        [self.tableView insertRowsAtIndexPaths:openedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if (deleteIndexPaths.count > 0) {
        [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self.tableView endUpdates];
    
}

#pragma mark - Touch Selector

/**
 *  添加在header中的点击手势的方法
 *
 *  @param gesture 点击手势
 */
- (void)tableViewHeaderTouchUpInside:(UITapGestureRecognizer *)gesture {
    NSInteger section = gesture.view.tag;
    
    [self openOrCloseHeaderWithSection:section];
    
    if (self.block) {
        self.block(section);
    }
}

#pragma mrak - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self get_heightForRowAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [self get_viewForHeaderInSection:section];
    if (header) {
        CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
        header.frame = CGRectMake(0, 0, self.tableView.frame.size.width, height);
        header.tag = section;
        
        [self addTapGestureRecognizerAction:@selector(tableViewHeaderTouchUpInside:) toView:header];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInMTableView:)]) {
        height = [self get_heightForHeaderInSection:section];
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self get_didSelectRowAtIndexPath:indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self get_editingStyleForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:
         @selector(m_tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [self.delegate m_tableView:self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //查找有没有打开该section
    BOOL found = NO;
    for (NSIndexPath *ip in self.currentOpenedIndexPaths) {
        if (section == ip.section) {
            found = YES;
            break;
        }
    }
    //如果没有打开，则返回0
    if (!found) {
        return 0;
    } else {
        //如果打开了，则计算该section原本应该有多少row
        return [self get_numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self get_cellForRowAtIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self get_numberOfSection];
}

#pragma mark - MultistageTableViewDataSource

- (NSInteger)get_numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    if ([self.dataSource respondsToSelector:@selector(m_tableView:numberOfRowsInSection:)]) {
        row = [self.dataSource m_tableView:self numberOfRowsInSection:section];
    }
    return row;
}

- (CGFloat)get_heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = DEFAULT_HEADER_HEIGHT;
    if ([self.delegate respondsToSelector:@selector(m_tableView:heightForRowAtIndexPath:)]) {
        height = [self.delegate m_tableView:self heightForRowAtIndexPath:indexPath];
    }
    return height;
}

- (UIView*)get_viewForHeaderInSection:(NSInteger)section {
    UIView *view = nil;
    if ([self.delegate respondsToSelector:@selector(m_tableView:viewForHeaderInSection:)]) {
        view = [self.delegate m_tableView:self viewForHeaderInSection:section];
    }
    return view;
}

- (CGFloat)get_heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0f;
    if ([self.delegate respondsToSelector:@selector(m_tableView:heightForHeaderInSection:)]) {
        height = [self.delegate m_tableView:self heightForHeaderInSection:section];
    }
    return height;
}

- (void)get_didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(m_TableView:didSelectRowAtIndexPath:)]) {
        [self.delegate m_TableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)get_cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if ([self.dataSource respondsToSelector:@selector(m_tableView:cellForRowAtIndexPath:)]) {
        cell = [self.dataSource m_tableView:self cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

- (NSInteger)get_numberOfSection {
    NSInteger number = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInMTableView:)]) {
        number = [self.dataSource numberOfSectionsInMTableView:self];
    }
    return number;
}

- (UITableViewCellEditingStyle)get_editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
    if ([self.delegate respondsToSelector:@selector(m_tableView:editingStyleForRowAtIndexPath:)]) {
        style = [self.delegate m_tableView:self editingStyleForRowAtIndexPath:indexPath];
    }
    return style;
}

@end
