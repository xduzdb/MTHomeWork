//
//  MTSearchMixLayout.m
//  HomeWork
//
//  Created by 张家和 on 2025/7/2.
//

#import "MTSearchMixLayout.h"
#import "SearchModel/SearchModel.h"

// 默认最大列数
static NSInteger const kDefaultMaxColumn = 2;
// 默认置顶层级
static NSInteger const kDefaultSuperStickyZIndex = 1000;
static NSInteger const kDefaultNormalStickyZIndex = 500;

@interface MTSearchMixLayout ()

#pragma mark - 私有属性

/**
 * 布局代理
 */
@property (nonatomic, weak) id<MTSearchMixLayoutDelegate> delegate;

/**
 * 布局属性缓存数组
 * 存储所有item的布局信息，避免重复计算
 */
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *itemAttributesCache;

/**
 * 每列的当前Y坐标记录
 * 用于瀑布流布局的高度计算
 */
@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnYPositions;

/**
 * 内容总高度
 */
@property (nonatomic, assign) CGFloat contentHeight;

/**
 * 布局是否需要重新计算
 */
@property (nonatomic, assign) BOOL needsLayoutUpdate;

/**
 * 布局统计信息
 */
@property (nonatomic, strong) NSMutableDictionary *statisticsInfo;

@end

@implementation MTSearchMixLayout

#pragma mark - 初始化方法

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

/**
 * 设置默认配置值
 */
- (void)setupDefaultValues {
    // 基础配置
    self.minimumLineSpacing = 8.0f;
    self.minimumInteritemSpacing = 16.0f;
    self.contentInsets = UIEdgeInsetsZero;
    self.maxColumnCount = kDefaultMaxColumn;
    
    // 置顶功能配置
    self.enableStickyFeature = YES;
    self.superStickyZIndex = kDefaultSuperStickyZIndex;
    self.normalStickyZIndex = kDefaultNormalStickyZIndex;
    
    // 调试和性能配置
    self.enableDebugMode = NO;
    self.enableLayoutCache = YES;
    
    // 初始化缓存和统计
    self.itemAttributesCache = [[NSMutableArray alloc] init];
    self.columnYPositions = [[NSMutableArray alloc] init];
    self.statisticsInfo = [[NSMutableDictionary alloc] init];
    self.needsLayoutUpdate = YES;
}

#pragma mark - UICollectionViewLayout 核心方法

/**
 * 准备布局
 * 这是布局计算的核心方法，会在以下情况被调用：
 * 1. 首次显示
 * 2. 数据源改变
 * 3. 布局失效时
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    if (self.enableDebugMode) {
        NSLog(@"🔧 [MTSearchMixLayout] prepareLayout 开始");
    }
    
    // 检查是否需要重新计算布局
    if (!self.needsLayoutUpdate && self.enableLayoutCache && self.itemAttributesCache.count > 0) {
        if (self.enableDebugMode) {
            NSLog(@"📦 [MTSearchMixLayout] 使用缓存布局，跳过计算");
        }
        return;
    }
    
    // 获取代理
    self.delegate = (id<MTSearchMixLayoutDelegate>)self.collectionView.delegate;
    if (!self.delegate) {
        NSLog(@"⚠️ [MTSearchMixLayout] 警告：未设置代理");
        return;
    }
    
    // 清理缓存
    [self clearLayoutCache];
    
    // 计算布局
    [self calculateLayout];
    
    // 标记布局已更新
    self.needsLayoutUpdate = NO;
    
    // 通知代理布局准备完成
    if ([self.delegate respondsToSelector:@selector(mixLayoutDidPrepareLayout:)]) {
        [self.delegate mixLayoutDidPrepareLayout:self];
    }
    
    if (self.enableDebugMode) {
        NSLog(@"✅ [MTSearchMixLayout] prepareLayout 完成，总计 %ld 个item", (long)self.itemAttributesCache.count);
        NSLog(@"📊 [MTSearchMixLayout] 布局统计：%@", [self layoutStatistics]);
    }
}

/**
 * 计算所有item的布局
 */
- (void)calculateLayout {
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    CGFloat usableWidth = collectionViewWidth - self.contentInsets.left - self.contentInsets.right;
    
    // 计算双列布局的单列宽度
    CGFloat doubleColumnWidth = (usableWidth - self.minimumInteritemSpacing) / self.maxColumnCount;
    
    // 初始化列Y坐标
    [self.columnYPositions removeAllObjects];
    for (NSInteger i = 0; i < self.maxColumnCount; i++) {
        [self.columnYPositions addObject:@(self.contentInsets.top)];
    }
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    NSInteger currentDoubleColumnIndex = 0; // 当前双列布局的列索引
    
    // 统计信息
    NSInteger singleItemCount = 0;
    NSInteger doubleItemCount = 0;
    NSInteger stickyItemCount = 0;
    NSInteger superStickyItemCount = 0;
    
    // 遍历所有item计算布局
    for (NSInteger item = 0; item < itemCount; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        SearchModel *itemModel = [self.delegate itemModelForLayoutWithIndexPath:indexPath];
        
        if (!itemModel) {
            NSLog(@"⚠️ [MTSearchMixLayout] 警告：item %ld 的数据模型为空", (long)item);
            continue;
        }
        
        // 创建布局属性
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        // 计算布局尺寸和位置
        CGRect itemFrame = [self calculateFrameForItem:itemModel 
                                              atIndex:item
                                        usableWidth:usableWidth
                                   doubleColumnWidth:doubleColumnWidth
                              currentColumnIndex:&currentDoubleColumnIndex];
        
        attributes.frame = itemFrame;
        
        // 添加到缓存
        [self.itemAttributesCache addObject:attributes];
        
        // 统计信息
        if (itemModel.type == MTItemLayoutTypeSingle) {
            singleItemCount++;
        } else {
            doubleItemCount++;
        }
        
        if (itemModel.isSticky) {
            stickyItemCount++;
        }
        if (itemModel.isSuperSticky) {
            superStickyItemCount++;
        }
        
        // 通知代理即将显示item
        if ([self.delegate respondsToSelector:@selector(mixLayout:willDisplayItemAtIndexPath:)]) {
            [self.delegate mixLayout:self willDisplayItemAtIndexPath:indexPath];
        }
    }
    
    // 计算内容总高度
    CGFloat maxY = 0;
    for (NSNumber *yPosition in self.columnYPositions) {
        maxY = MAX(maxY, yPosition.floatValue);
    }
    self.contentHeight = maxY + self.contentInsets.bottom;
    
    // 更新统计信息
    [self.statisticsInfo setObject:@(itemCount) forKey:@"totalItems"];
    [self.statisticsInfo setObject:@(singleItemCount) forKey:@"singleItems"];
    [self.statisticsInfo setObject:@(doubleItemCount) forKey:@"doubleItems"];
    [self.statisticsInfo setObject:@(stickyItemCount) forKey:@"stickyItems"];
    [self.statisticsInfo setObject:@(superStickyItemCount) forKey:@"superStickyItems"];
    [self.statisticsInfo setObject:@(self.contentHeight) forKey:@"contentHeight"];
}

/**
 * 计算单个item的frame
 */
- (CGRect)calculateFrameForItem:(SearchModel *)itemModel 
                        atIndex:(NSInteger)index
                    usableWidth:(CGFloat)usableWidth
               doubleColumnWidth:(CGFloat)doubleColumnWidth
              currentColumnIndex:(NSInteger *)columnIndex {
    
    CGFloat x = self.contentInsets.left;
    CGFloat y = 0;
    CGFloat width = 0;
    CGFloat height = itemModel.height;
    
    // 获取自定义间距（如果代理实现了相关方法）
    CGFloat lineSpacing = self.minimumLineSpacing;
    CGFloat interitemSpacing = self.minimumInteritemSpacing;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    if ([self.delegate respondsToSelector:@selector(mixLayout:lineSpacingForItemAtIndexPath:)]) {
        lineSpacing = [self.delegate mixLayout:self lineSpacingForItemAtIndexPath:indexPath];
    }
    if ([self.delegate respondsToSelector:@selector(mixLayout:interitemSpacingForItemAtIndexPath:)]) {
        interitemSpacing = [self.delegate mixLayout:self interitemSpacingForItemAtIndexPath:indexPath];
    }
    
    if (itemModel.type == MTItemLayoutTypeSingle) {
        // 单列布局：占满整行
        width = usableWidth;
        
        // 找到所有列中最高的Y坐标
        CGFloat maxY = 0;
        for (NSNumber *yPosition in self.columnYPositions) {
            maxY = MAX(maxY, yPosition.floatValue);
        }
        y = maxY;
        
        // 更新所有列的Y坐标
        CGFloat newY = y + height + lineSpacing;
        for (NSInteger i = 0; i < self.columnYPositions.count; i++) {
            [self.columnYPositions replaceObjectAtIndex:i withObject:@(newY)];
        }
        
    } else if (itemModel.type == MTItemLayoutTypeDouble) {
        // 双列布局：选择较短的列
        width = doubleColumnWidth;
        
        // 找到最短的列
        NSInteger shortestColumnIndex = 0;
        CGFloat shortestY = [self.columnYPositions[0] floatValue];
        
        for (NSInteger i = 1; i < self.columnYPositions.count; i++) {
            CGFloat currentY = [self.columnYPositions[i] floatValue];
            if (currentY < shortestY) {
                shortestY = currentY;
                shortestColumnIndex = i;
            }
        }
        
        // 计算X坐标
        x = self.contentInsets.left + shortestColumnIndex * (doubleColumnWidth + interitemSpacing);
        y = shortestY;
        
        // 更新该列的Y坐标
        CGFloat newY = y + height + lineSpacing;
        [self.columnYPositions replaceObjectAtIndex:shortestColumnIndex withObject:@(newY)];
        
        *columnIndex = shortestColumnIndex;
    }
    
    return CGRectMake(x, y, width, height);
}

/**
 * 返回指定矩形区域内的所有布局属性
 * 这个方法决定了哪些cell需要显示，是性能的关键
 */
- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    if (self.enableDebugMode) {
        NSLog(@"👀 [MTSearchMixLayout] layoutAttributesForElementsInRect: %@", NSStringFromCGRect(rect));
    }
    
    NSMutableArray<UICollectionViewLayoutAttributes *> *visibleAttributes = [[NSMutableArray alloc] init];
    
    // 遍历所有缓存的布局属性
    for (UICollectionViewLayoutAttributes *attributes in self.itemAttributesCache) {
        NSIndexPath *indexPath = attributes.indexPath;
        SearchModel *itemModel = [self.delegate itemModelForLayoutWithIndexPath:indexPath];
        
        // 判断是否在可见区域内，或者是置顶元素
        BOOL isIntersecting = CGRectIntersectsRect(attributes.frame, rect);
        BOOL isSticky = self.enableStickyFeature && (itemModel.isSuperSticky || itemModel.isSticky);
        
        if (isIntersecting || isSticky) {
            // 创建副本以避免修改原始缓存
            UICollectionViewLayoutAttributes *displayAttributes = [attributes copy];
            [visibleAttributes addObject:displayAttributes];
        }
    }
    
    // 处理置顶逻辑
    if (self.enableStickyFeature) {
        [self applyStickyBehaviorToAttributes:visibleAttributes];
    }
    
    if (self.enableDebugMode) {
        NSLog(@"📱 [MTSearchMixLayout] 返回 %ld 个可见item", (long)visibleAttributes.count);
    }
    
    return visibleAttributes;
}

/**
 * 应用置顶行为到布局属性
 */
- (void)applyStickyBehaviorToAttributes:(NSMutableArray<UICollectionViewLayoutAttributes *> *)attributes {
    CGFloat currentStickyY = self.collectionView.contentInset.top + self.collectionView.contentOffset.y;
    
    // 分离超级置顶和普通置顶元素
    NSMutableArray *superStickyItems = [[NSMutableArray alloc] init];
    NSMutableArray *normalStickyItems = [[NSMutableArray alloc] init];
    
    for (UICollectionViewLayoutAttributes *itemAttributes in attributes) {
        SearchModel *itemModel = [self.delegate itemModelForLayoutWithIndexPath:itemAttributes.indexPath];
        
        if (itemModel.isSuperSticky) {
            [superStickyItems addObject:itemAttributes];
        } else if (itemModel.isSticky) {
            [normalStickyItems addObject:itemAttributes];
        }
    }
    
    // 按原始Y坐标排序
    [superStickyItems sortUsingComparator:^NSComparisonResult(UICollectionViewLayoutAttributes *obj1, UICollectionViewLayoutAttributes *obj2) {
        return [@(obj1.frame.origin.y) compare:@(obj2.frame.origin.y)];
    }];
    
    [normalStickyItems sortUsingComparator:^NSComparisonResult(UICollectionViewLayoutAttributes *obj1, UICollectionViewLayoutAttributes *obj2) {
        return [@(obj1.frame.origin.y) compare:@(obj2.frame.origin.y)];
    }];
    
    // 处理超级置顶元素
    for (UICollectionViewLayoutAttributes *attributes in superStickyItems) {
        CGRect frame = attributes.frame;
        frame.origin.y = MAX(frame.origin.y, currentStickyY);
        attributes.frame = frame;
        attributes.zIndex = self.superStickyZIndex;
        
        currentStickyY += frame.size.height;
    }
    
    // 处理普通置顶元素
    for (UICollectionViewLayoutAttributes *attributes in normalStickyItems) {
        CGRect frame = attributes.frame;
        frame.origin.y = MAX(frame.origin.y, currentStickyY);
        attributes.frame = frame;
        attributes.zIndex = self.normalStickyZIndex;
        
        // 普通置顶元素之间不叠加
    }
}

/**
 * 返回指定IndexPath的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.itemAttributesCache.count) {
        return [self.itemAttributesCache objectAtIndex:indexPath.item];
    }
    
    if (self.enableDebugMode) {
        NSLog(@"⚠️ [MTSearchMixLayout] 警告：请求的IndexPath超出范围 %@", indexPath);
    }
    
    return nil;
}

/**
 * 返回CollectionView的内容大小
 */
- (CGSize)collectionViewContentSize {
    CGSize contentSize = CGSizeMake(self.collectionView.bounds.size.width, self.contentHeight);
    
    if (self.enableDebugMode) {
        NSLog(@"📏 [MTSearchMixLayout] contentSize: %@", NSStringFromCGSize(contentSize));
    }
    
    return contentSize;
}

/**
 * 判断是否需要重新布局
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    // 如果开启了置顶功能，需要在滚动时重新计算布局
    if (self.enableStickyFeature) {
        return YES;
    }
    
    // 如果宽度发生变化，需要重新布局
    CGRect oldBounds = self.collectionView.bounds;
    if (oldBounds.size.width != newBounds.size.width) {
        self.needsLayoutUpdate = YES;
        return YES;
    }
    
    return NO;
}

/**
 * 当布局失效时调用
 */
- (void)invalidateLayout {
    [super invalidateLayout];
    self.needsLayoutUpdate = YES;
    
    if (self.enableDebugMode) {
        NSLog(@"🔄 [MTSearchMixLayout] 布局已失效，将重新计算");
    }
}

/**
 * 当布局失效时调用（带上下文）
 */
- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context {
    [super invalidateLayoutWithContext:context];
    
    if (context.invalidateEverything || context.invalidateDataSourceCounts) {
        self.needsLayoutUpdate = YES;
        [self clearLayoutCache];
    }
    
    if (self.enableDebugMode) {
        NSLog(@"🔄 [MTSearchMixLayout] 布局已失效（带上下文），invalidateEverything: %@", @(context.invalidateEverything));
    }
}

#pragma mark - 公共方法

/**
 * 清理布局缓存
 */
- (void)clearLayoutCache {
    [self.itemAttributesCache removeAllObjects];
    [self.columnYPositions removeAllObjects];
    [self.statisticsInfo removeAllObjects];
    self.contentHeight = 0;
}

/**
 * 刷新布局缓存
 */
- (void)invalidateLayoutCache {
    self.needsLayoutUpdate = YES;
    [self clearLayoutCache];
    [self invalidateLayout];
    
    if (self.enableDebugMode) {
        NSLog(@"🗑️ [MTSearchMixLayout] 布局缓存已清理");
    }
}

/**
 * 获取缓存的布局属性
 */
- (nullable UICollectionViewLayoutAttributes *)cachedLayoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.itemAttributesCache.count) {
        return self.itemAttributesCache[indexPath.item];
    }
    return nil;
}

/**
 * 获取布局统计信息
 */
- (NSDictionary *)layoutStatistics {
    NSMutableDictionary *stats = [self.statisticsInfo mutableCopy];
    [stats setObject:@(self.itemAttributesCache.count) forKey:@"cachedItems"];
    [stats setObject:@(self.needsLayoutUpdate) forKey:@"needsUpdate"];
    [stats setObject:@(self.enableLayoutCache) forKey:@"cacheEnabled"];
    [stats setObject:@(self.enableStickyFeature) forKey:@"stickyEnabled"];
    return [stats copy];
}

#pragma mark - 调试方法

/**
 * 打印布局信息（调试用）
 */
- (void)debugPrintLayoutInfo {
    if (!self.enableDebugMode) return;
    
    NSLog(@"\n========== MTSearchMixLayout 调试信息 ==========");
    NSLog(@"📦 缓存item数量: %ld", (long)self.itemAttributesCache.count);
    NSLog(@"📏 内容尺寸: %@", NSStringFromCGSize([self collectionViewContentSize]));
    NSLog(@"🔧 配置信息:");
    NSLog(@"   - 行间距: %.1f", self.minimumLineSpacing);
    NSLog(@"   - 列间距: %.1f", self.minimumInteritemSpacing);
    NSLog(@"   - 最大列数: %ld", (long)self.maxColumnCount);
    NSLog(@"   - 置顶功能: %@", self.enableStickyFeature ? @"开启" : @"关闭");
    NSLog(@"   - 布局缓存: %@", self.enableLayoutCache ? @"开启" : @"关闭");
    NSLog(@"📊 统计信息: %@", [self layoutStatistics]);
    NSLog(@"===============================================\n");
}

@end
