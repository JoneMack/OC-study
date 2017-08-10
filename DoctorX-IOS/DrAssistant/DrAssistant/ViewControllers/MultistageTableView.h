//
//  MultistageTableView.h
//  MultistageTableVIewTest
//
//

#import <UIKit/UIKit.h>

@class MultistageTableView;
typedef void(^HeaderAction)(NSInteger cuSection);

@protocol MultistageTableViewDataSource , MultistageTableViewDelegate;

@interface MultistageTableView : UIView <UITableViewDataSource, UITableViewDelegate>

/**
 *  主表格
 */
@property (strong, nonatomic) UITableView *tableView;
/**
 *  当前展开的所有cell的indexPath的数组
 */
@property (strong, nonatomic) NSMutableArray *currentOpenedIndexPaths;
/**
 *  数据源
 */
@property (weak, nonatomic) id<MultistageTableViewDataSource> dataSource;
/**
 *  协议
 */
@property (weak, nonatomic)id<MultistageTableViewDelegate> delegate;

@property (copy, nonatomic)HeaderAction block;

/**
 *  根据标识符取出重用cell
 *
 *  @param identifier 重用标识符
 *
 *  @return 可重用的cell，或者nil（如果没有可重用的）
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (id)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier;

/**
 *  取消对cell的选中状态
 *
 *  @param indexPath 选中的cell的indexPath
 *  @param animated  是否使用动画
 */
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation NS_AVAILABLE_IOS(3_0);
- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection NS_AVAILABLE_IOS(5_0);
- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath NS_AVAILABLE_IOS(5_0);
- (void)beginUpdates;
- (void)endUpdates;

/**
 *  重新加载数据
 */
- (void)reloadData;

@end

@protocol MultistageTableViewDataSource <NSObject>

@required

- (NSInteger)m_tableView:(MultistageTableView *)mtableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)m_tableView:(MultistageTableView *)mtableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfSectionsInMTableView:(MultistageTableView *)mtableView;


@end

@protocol MultistageTableViewDelegate <NSObject>

@optional

- (CGFloat)m_tableView:(MultistageTableView *)mtableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)m_tableView:(MultistageTableView *)mtableView heightForHeaderInSection:(NSInteger)section;

- (UIView *)m_tableView:(MultistageTableView *)mtableView viewForHeaderInSection:(NSInteger)section;

- (void)m_TableView:(MultistageTableView *)mTableView willOpenHeaderAtSection:(NSInteger)section;
- (void)m_TableView:(MultistageTableView *)mTableView willCloseHeaderAtSection:(NSInteger)section;
- (void)m_TableView:(MultistageTableView *)mTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCellEditingStyle)m_tableView:(MultistageTableView *)mtableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)m_tableView:(MultistageTableView *)mtableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;


@end