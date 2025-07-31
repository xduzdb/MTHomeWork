# MTSearchMixLayout 使用说明

## 概述
MTSearchMixLayout 是一个功能强大的自定义 UICollectionViewLayout，专为搜索结果展示设计，支持瀑布流布局和置顶功能。

## 核心功能

### 1. 混合布局支持
- **单列布局 (MTItemLayoutTypeSingle)**: item占满整行宽度
- **双列布局 (MTItemLayoutTypeDouble)**: item以瀑布流形式排列，自动选择较短的列

### 2. 置顶功能
- **超级置顶 (isSuperSticky)**: 始终固定在顶部，多个超级置顶元素会依次叠加
- **普通置顶 (isSticky)**: 在超级置顶元素下方置顶显示

### 3. 高性能缓存
- 智能布局缓存机制，避免重复计算
- 可配置是否启用缓存功能

### 4. 灵活配置
- 自定义间距、边距
- 调试模式支持
- 丰富的代理回调

## 基本使用

### 1. 创建布局实例
```objc
MTSearchMixLayout *layout = [[MTSearchMixLayout alloc] init];

// 基础配置
layout.minimumLineSpacing = 8.0f;           // 行间距
layout.minimumInteritemSpacing = 16.0f;     // 列间距
layout.contentInsets = UIEdgeInsetsMake(10, 15, 10, 15);  // 内容边距
layout.maxColumnCount = 2;                  // 最大列数

// 置顶功能配置
layout.enableStickyFeature = YES;           // 开启置顶功能
layout.superStickyZIndex = 1000;            // 超级置顶层级
layout.normalStickyZIndex = 500;            // 普通置顶层级

// 调试配置
layout.enableDebugMode = YES;               // 开启调试日志
layout.enableLayoutCache = YES;             // 开启布局缓存

// 应用到CollectionView
collectionView.collectionViewLayout = layout;
```

### 2. 实现代理方法
```objc
@interface ViewController () <MTSearchMixLayoutDelegate>
@property (nonatomic, strong) NSArray<SearchModel *> *dataSource;
@end

@implementation ViewController

#pragma mark - MTSearchMixLayoutDelegate

// 必须实现：返回数据模型
- (SearchModel *)itemModelForLayoutWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataSource.count) {
        return self.dataSource[indexPath.item];
    }
    return nil;
}

// 可选：布局准备完成回调
- (void)mixLayoutDidPrepareLayout:(UICollectionViewLayout *)layout {
    NSLog(@"🎯 布局准备完成");
}

// 可选：自定义行间距
- (CGFloat)mixLayout:(UICollectionViewLayout *)layout lineSpacingForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 例如：置顶元素间距更小
    SearchModel *model = [self itemModelForLayoutWithIndexPath:indexPath];
    return model.isSticky ? 4.0f : 8.0f;
}

// 可选：自定义列间距
- (CGFloat)mixLayout:(UICollectionViewLayout *)layout interitemSpacingForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 16.0f;
}

// 可选：即将显示item时的回调
- (void)mixLayout:(UICollectionViewLayout *)layout willDisplayItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"📱 即将显示 item: %@", indexPath);
}

@end
```

### 3. 创建数据模型
```objc
// 创建单列普通item
SearchModel *singleItem = [[SearchModel alloc] initWithTitle:@"搜索结果1"
                                             backgroundColor:[UIColor lightGrayColor]
                                                     isStick:NO
                                                isSuperStick:NO
                                                      height:80
                                                        type:MTItemLayoutTypeSingle
                                                        data:nil];

// 创建双列item
SearchModel *doubleItem = [[SearchModel alloc] initWithTitle:@"商品1"
                                             backgroundColor:[UIColor blueColor]
                                                     isStick:NO
                                                isSuperStick:NO
                                                      height:120
                                                        type:MTItemLayoutTypeDouble
                                                        data:nil];

// 创建超级置顶item
SearchModel *superStickyItem = [[SearchModel alloc] initWithTitle:@"热门推荐"
                                                  backgroundColor:[UIColor redColor]
                                                          isStick:NO
                                                     isSuperStick:YES
                                                           height:60
                                                             type:MTItemLayoutTypeSingle
                                                             data:nil];

// 创建普通置顶item
SearchModel *stickyItem = [[SearchModel alloc] initWithTitle:@"分类筛选"
                                             backgroundColor:[UIColor orangeColor]
                                                     isStick:YES
                                                isSuperStick:NO
                                                      height:50
                                                        type:MTItemLayoutTypeSingle
                                                        data:nil];

self.dataSource = @[superStickyItem, stickyItem, singleItem, doubleItem, ...];
```

## 高级使用

### 1. 动态更新数据
```objc
// 添加新数据
NSMutableArray *newDataSource = [self.dataSource mutableCopy];
[newDataSource addObject:newItem];
self.dataSource = [newDataSource copy];

// 刷新布局缓存
MTSearchMixLayout *layout = (MTSearchMixLayout *)self.collectionView.collectionViewLayout;
[layout invalidateLayoutCache];

// 重新加载数据
[self.collectionView reloadData];
```

### 2. 获取布局统计信息
```objc
MTSearchMixLayout *layout = (MTSearchMixLayout *)self.collectionView.collectionViewLayout;
NSDictionary *stats = [layout layoutStatistics];
NSLog(@"📊 布局统计: %@", stats);

/*
输出示例:
{
    totalItems = 20;
    singleItems = 8;
    doubleItems = 12;
    stickyItems = 2;
    superStickyItems = 1;
    contentHeight = 1500.5;
    cachedItems = 20;
    needsUpdate = 0;
    cacheEnabled = 1;
    stickyEnabled = 1;
}
*/
```

### 3. 调试功能
```objc
// 开启调试模式
layout.enableDebugMode = YES;

// 手动打印调试信息
[layout debugPrintLayoutInfo];
```

### 4. 性能优化
```objc
// 关闭置顶功能以提升性能（如不需要）
layout.enableStickyFeature = NO;

// 关闭布局缓存（调试时）
layout.enableLayoutCache = NO;

// 获取缓存的布局属性
UICollectionViewLayoutAttributes *attrs = [layout cachedLayoutAttributesForItemAtIndexPath:indexPath];
```

## 布局效果说明

### 视觉效果
```
┌─────────────────────────────────────┐
│     超级置顶1 (红色，始终在顶部)        │ ← 超级置顶
├─────────────────────────────────────┤
│     超级置顶2 (红色，叠加显示)          │ ← 超级置顶
├─────────────────────────────────────┤
│     普通置顶 (橙色，在超级置顶下方)      │ ← 普通置顶
├─────────────────────────────────────┤
│              单列内容                │ ← 单列布局
├─────────────────────────────────────┤
│   双列内容1    │    双列内容2         │ ← 双列布局
│              │                     │
├──────────────┼─────────────────────┤
│   双列内容3    │    双列内容4         │
│              │                     │
└──────────────┴─────────────────────┘
```

### 滚动时置顶效果
- **超级置顶元素**: 始终固定在屏幕顶部，不随滚动移动
- **普通置顶元素**: 在超级置顶元素下方固定显示
- **普通元素**: 正常滚动显示

## 常见问题

### Q: 如何实现不同高度的瀑布流？
A: 在创建SearchModel时设置不同的height值：
```objc
SearchModel *tallItem = [[SearchModel alloc] initWithTitle:@"高内容"
                                           backgroundColor:[UIColor blueColor]
                                                   isStick:NO
                                              isSuperStick:NO
                                                    height:200  // 高度较大
                                                      type:MTItemLayoutTypeDouble
                                                      data:nil];

SearchModel *shortItem = [[SearchModel alloc] initWithTitle:@"矮内容"
                                            backgroundColor:[UIColor greenColor]
                                                    isStick:NO
                                               isSuperStick:NO
                                                     height:100  // 高度较小
                                                       type:MTItemLayoutTypeDouble
                                                       data:nil];
```

### Q: 如何禁用置顶功能？
A: 设置enableStickyFeature为NO：
```objc
layout.enableStickyFeature = NO;
```

### Q: 如何调整列数？
A: 修改maxColumnCount属性：
```objc
layout.maxColumnCount = 3;  // 改为3列
```

### Q: 如何监听布局变化？
A: 实现代理方法：
```objc
- (void)mixLayoutDidPrepareLayout:(UICollectionViewLayout *)layout {
    // 布局准备完成后的处理
    [self updateUI];
}
```

### Q: 性能优化建议？
A: 
1. 开启布局缓存：`layout.enableLayoutCache = YES`
2. 合理使用置顶功能，避免过多置顶元素
3. 在数据变化时及时调用`invalidateLayoutCache`
4. 避免频繁的数据更新

## 调试技巧

### 1. 开启调试日志
```objc
layout.enableDebugMode = YES;
```
将会输出详细的布局计算过程：
```
🔧 [MTSearchMixLayout] prepareLayout 开始
✅ [MTSearchMixLayout] prepareLayout 完成，总计 20 个item
📊 [MTSearchMixLayout] 布局统计：{...}
👀 [MTSearchMixLayout] layoutAttributesForElementsInRect: {{0, 0}, {375, 667}}
📱 [MTSearchMixLayout] 返回 8 个可见item
```

### 2. 查看布局统计
```objc
NSDictionary *stats = [layout layoutStatistics];
NSLog(@"布局统计: %@", stats);
```

### 3. 手动打印调试信息
```objc
[layout debugPrintLayoutInfo];
```

这个自定义布局让您可以轻松实现复杂的搜索结果展示界面，结合了瀑布流的美观和置顶功能的实用性，非常适合电商、内容类应用的搜索页面。 