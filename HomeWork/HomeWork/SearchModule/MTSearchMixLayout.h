//
//  MTSearchMixLayout.h
//  HomeWork
//
//  Created by 张家和 on 2025/7/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SearchModel;

/**
 * MTSearchMixLayout 代理协议
 * 用于获取布局所需的数据和处理布局事件
 */
@protocol MTSearchMixLayoutDelegate <UICollectionViewDelegate>

@required
/**
 * 获取指定IndexPath的数据模型
 * @param indexPath 索引路径
 * @return SearchModel数据模型
 */
- (SearchModel *)itemModelForLayoutWithIndexPath:(NSIndexPath *)indexPath;

@optional
/**
 * 布局准备完成回调
 * @param layout 布局对象
 */
- (void)mixLayoutDidPrepareLayout:(UICollectionViewLayout *)layout;

/**
 * 获取自定义的item间距（可选，默认使用layout的minimumInteritemSpacing）
 * @param layout 布局对象
 * @param indexPath 索引路径
 * @return 间距值
 */
- (CGFloat)mixLayout:(UICollectionViewLayout *)layout interitemSpacingForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 * 获取自定义的行间距（可选，默认使用layout的minimumLineSpacing）
 * @param layout 布局对象
 * @param indexPath 索引路径
 * @return 间距值
 */
- (CGFloat)mixLayout:(UICollectionViewLayout *)layout lineSpacingForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 * 即将显示某个item时的回调
 * @param layout 布局对象
 * @param indexPath 索引路径
 */
- (void)mixLayout:(UICollectionViewLayout *)layout willDisplayItemAtIndexPath:(NSIndexPath *)indexPath;

@end

/**
 * MTSearchMixLayout - 支持瀑布流和置顶功能的自定义布局
 * 
 * 功能特性：
 * 1. 支持单列(MTItemLayoutTypeSingle)和双列(MTItemLayoutTypeDouble)混合布局
 * 2. 支持超级置顶(isSuperSticky)和普通置顶(isSticky)功能
 * 3. 支持自定义间距和配置
 * 4. 高性能的布局缓存机制
 * 
 * 使用方法：
 * MTSearchMixLayout *layout = [[MTSearchMixLayout alloc] init];
 * layout.minimumLineSpacing = 8.0f;
 * layout.minimumInteritemSpacing = 16.0f;
 * layout.enableDebugMode = YES; // 开启调试模式
 * collectionView.collectionViewLayout = layout;
 */
@interface MTSearchMixLayout : UICollectionViewLayout

#pragma mark - 基础配置属性

/**
 * 行间距（垂直间距）
 * 默认值：8.0f
 */
@property (nonatomic, assign) CGFloat minimumLineSpacing;

/**
 * 列间距（水平间距）
 * 默认值：16.0f
 */
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

/**
 * 内容边距
 * 默认值：UIEdgeInsetsZero
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;

/**
 * 双列布局时的列数
 * 默认值：2
 */
@property (nonatomic, assign) NSInteger maxColumnCount;

#pragma mark - 置顶功能配置

/**
 * 是否启用置顶功能
 * 默认值：YES
 */
@property (nonatomic, assign) BOOL enableStickyFeature;

/**
 * 置顶元素的z轴层级
 * 默认值：超级置顶1000，普通置顶500
 */
@property (nonatomic, assign) NSInteger superStickyZIndex;
@property (nonatomic, assign) NSInteger normalStickyZIndex;

#pragma mark - 调试和性能配置

/**
 * 是否启用调试模式
 * 开启后会在控制台输出布局信息
 * 默认值：NO
 */
@property (nonatomic, assign) BOOL enableDebugMode;

/**
 * 是否启用布局缓存
 * 默认值：YES
 */
@property (nonatomic, assign) BOOL enableLayoutCache;

#pragma mark - 公共方法

/**
 * 刷新布局缓存
 * 当数据源发生变化时调用
 */
- (void)invalidateLayoutCache;

/**
 * 获取指定IndexPath的布局属性
 * @param indexPath 索引路径
 * @return 布局属性
 */
- (nullable UICollectionViewLayoutAttributes *)cachedLayoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 * 获取当前布局的统计信息
 * @return 包含布局统计信息的字典
 */
- (NSDictionary *)layoutStatistics;

@end

NS_ASSUME_NONNULL_END
