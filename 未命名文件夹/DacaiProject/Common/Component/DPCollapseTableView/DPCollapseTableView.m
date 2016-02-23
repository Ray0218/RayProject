//
//  DPCollapseTableView.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPCollapseTableView.h"

@interface DPCollapseTableModel : NSObject {
@private
    NSMutableDictionary *_expandDic;
}

- (NSIndexPath *)tableIndexFromModelIndex:(NSIndexPath *)modelIndex expand:(in BOOL)expand;
- (NSIndexPath *)modelIndexFromTableIndex:(NSIndexPath *)tableIndex expand:(out BOOL *)expand;
- (NSMutableArray *)expandArrayOfSection:(NSInteger)section;
- (BOOL)isExpandAtModelIndex:(NSIndexPath *)modelIndex;
- (BOOL)isExpandAtTableIndex:(NSIndexPath *)tableIndex;

- (void)insertExpandModelIndex:(NSIndexPath *)modelIndex;
- (void)deleteExpandModelIndex:(NSIndexPath *)modelIndex;

- (NSMutableArray *)expandModelIndexs;
- (NSMutableArray *)expandTableIndexs;

- (void)removeAllExpandIndexs;

@end

@implementation DPCollapseTableModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _expandDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - 底层方法

- (NSIndexPath *)tableIndexFromModelIndex:(NSIndexPath *)modelIndex expand:(in BOOL)expand {
    NSMutableArray *expandArray = [self expandArrayOfSection:modelIndex.section];
    NSUInteger count = 0;

    for (int i = 0; i < expandArray.count; i++) {
        if ([[expandArray objectAtIndex:i] intValue] < modelIndex.row) {
            count++;
        }
    }

    return [NSIndexPath indexPathForRow:modelIndex.row + count + (expand ? 1 : 0)inSection:modelIndex.section];
}

- (NSIndexPath *)modelIndexFromTableIndex:(NSIndexPath *)tableIndex expand:(out BOOL *)expand {
    NSMutableArray *expandArray = [self expandArrayOfSection:tableIndex.section];

    if ([expandArray count] == 0) {
        if (expand) *expand = NO;

        return [NSIndexPath indexPathForRow:tableIndex.row inSection:tableIndex.section];
    } else {
        for (int i = 0; i < expandArray.count; i++) {
            int currRow = [[expandArray objectAtIndex:i] intValue] + i;

            if (tableIndex.row < currRow) {
                assert(i == 0);

                if (expand) *expand = NO;

                return [NSIndexPath indexPathForRow:tableIndex.row inSection:tableIndex.section];
            } else if (tableIndex.row == currRow) {
                if (expand) *expand = NO;

                return [NSIndexPath indexPathForRow:[[expandArray objectAtIndex:i] intValue] inSection:tableIndex.section];
            } else if (tableIndex.row == currRow + 1) {
                if (expand) *expand = YES;

                return [NSIndexPath indexPathForRow:[[expandArray objectAtIndex:i] intValue] inSection:tableIndex.section];
            } else if (i == expandArray.count - 1 || tableIndex.row < [[expandArray objectAtIndex:(i + 1)] integerValue] + (i + 1)) {
                if (expand) *expand = NO;

                return [NSIndexPath indexPathForRow:tableIndex.row - (i + 1)inSection:tableIndex.section];
            }
        }
    }

    assert(NO);

    return nil;
}

- (NSMutableArray *)expandArrayOfSection:(NSInteger)section {
    return [_expandDic objectForKey:@(section)];
}

- (BOOL)isExpandAtTableIndex:(NSIndexPath *)tableIndex {
    NSMutableArray *expandArray = [self expandArrayOfSection:tableIndex.section];

    for (int i = 0; i < expandArray.count; i++) {
        int currRow = [[expandArray objectAtIndex:i] intValue] + i;

        if (tableIndex.row == currRow + 1) {
            return YES;
        } else if (tableIndex.row < currRow + 1) {
            break;
        }
    }

    return NO;
}

- (BOOL)isExpandAtModelIndex:(NSIndexPath *)modelIndex {
    NSMutableArray *expandArray = [self expandArrayOfSection:modelIndex.section];

    return [expandArray containsObject:@(modelIndex.row)];
}

- (void)insertExpandModelIndex:(NSIndexPath *)modelIndex {
    NSMutableArray *expandArray = [self expandArrayOfSection:modelIndex.section];

    if (expandArray == nil) {
        expandArray = [NSMutableArray array];

        [_expandDic setObject:expandArray forKey:@(modelIndex.section)];
    }

    if (![self isExpandAtModelIndex:modelIndex]) {
        int i = 0;
        for (i = 0; i < expandArray.count; i++) {
            if ([expandArray[i] intValue] > modelIndex.row) {
                break;
            }
        }
        [expandArray insertObject:@(modelIndex.row) atIndex:i];
    }
}

- (void)deleteExpandModelIndex:(NSIndexPath *)modelIndex {
    NSMutableArray *expandArray = [self expandArrayOfSection:modelIndex.section];

    if ([self isExpandAtModelIndex:modelIndex]) {
        [expandArray removeObject:@(modelIndex.row)];
    }
}

- (NSMutableArray *)expandModelIndexs {
    NSMutableArray *expandModelIndexs = [NSMutableArray array];
    for (NSNumber *section in _expandDic.keyEnumerator) {
        NSMutableArray *expandArray = [self expandArrayOfSection:section.intValue];
        for (NSNumber *row in expandArray) {
            [expandModelIndexs addObject:[NSIndexPath indexPathForRow:row.intValue inSection:section.intValue]];
        }
    }
    return expandModelIndexs;
}

- (NSMutableArray *)expandTableIndexs {
    NSMutableArray *expandTableIndexs = [NSMutableArray array];
    NSMutableArray *expandModelIndexs = [self expandModelIndexs];
    for (NSIndexPath *modelIndex in expandModelIndexs) {
        [expandTableIndexs addObject:[self tableIndexFromModelIndex:modelIndex expand:YES]];
    }
    return expandTableIndexs;
}

- (void)removeAllExpandIndexs {
    for (NSNumber *section in _expandDic.keyEnumerator) {
        [[self expandArrayOfSection:section.intValue] removeAllObjects];
    }
}

@end

#pragma mark - 消息转发

@interface DPMethodProxy : NSProxy

@property (nonatomic, assign) id intercept;
@property (nonatomic, assign) id receiver;

- (instancetype)init;

@end

@implementation DPMethodProxy

- (instancetype)init {
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.intercept respondsToSelector:aSelector]) { return self.intercept; }
    if ([self.receiver respondsToSelector:aSelector]) { return self.receiver; }
    return nil;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.intercept respondsToSelector:aSelector]) { return YES; }
    if ([self.receiver respondsToSelector:aSelector]) { return YES; }
    return NO;
}

@end

#pragma mark - 实现
@interface DPCollapseTableView () {
@private
    DPCollapseTableModel *_tableModel;
    DPMethodProxy *_dataSourceProxy;
    DPMethodProxy *_delegateProxy;

    struct {
        unsigned heightForRowAtIndexPath : 1;
        unsigned expandHeightForRowAtIndexPath : 1;
    } _hasDelegateBit;

    struct {
        unsigned numberOfRowsInSection : 1;
        unsigned cellForRowAtIndexPath : 1;
        unsigned expandCellForRowAtIndexPath : 1;

    } _hasDataSourceBit;
}

@end

@implementation DPCollapseTableView
@dynamic dataSource;
@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _tableModel = [[DPCollapseTableModel alloc] init];
        _dataSourceProxy = [[DPMethodProxy alloc] init];
        _delegateProxy = [[DPMethodProxy alloc] init];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    switch (self.zOrder) {
        case DPTableViewZOrderAsec: {
            NSArray *sortedIndexPaths = [[self indexPathsForVisibleRows] sortedArrayUsingSelector:@selector(compare:)];
            for (NSIndexPath *path in sortedIndexPaths.reverseObjectEnumerator) {
                UITableViewCell *cell = [self cellForRowAtIndexPath:path];
                [cell.superview sendSubviewToBack:cell];
            }
        }
            break;
        case DPTableViewZOrderDsec: {
            NSArray *sortedIndexPaths = [[self indexPathsForVisibleRows] sortedArrayUsingSelector:@selector(compare:)];
            for (NSIndexPath *path in sortedIndexPaths) {
                UITableViewCell *cell = [self cellForRowAtIndexPath:path];
                [cell.superview sendSubviewToBack:cell];
            }
        }
            break;
        default:
            break;
    }
}

- (void)setDataSource:(id<DPCollapseTableViewDataSource>)dataSource {
    _dataSourceProxy.intercept = self;
    _dataSourceProxy.receiver = dataSource;

    _hasDataSourceBit.numberOfRowsInSection = [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)];
    _hasDataSourceBit.cellForRowAtIndexPath = [dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)];
    _hasDataSourceBit.expandCellForRowAtIndexPath = [dataSource respondsToSelector:@selector(tableView:expandCellForRowAtIndexPath:)];

    [super setDataSource:nil];
    [super setDataSource:(id<UITableViewDataSource>)_dataSourceProxy];
}

- (void)setDelegate:(id<DPCollapseTableViewDelegate>)delegate {
    _delegateProxy.intercept = self;
    _delegateProxy.receiver = delegate;

    _hasDelegateBit.heightForRowAtIndexPath = [delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)];
    _hasDelegateBit.expandHeightForRowAtIndexPath = [delegate respondsToSelector:@selector(tableView:expandHeightForRowAtIndexPath:)];

    [super setDelegate:nil];
    [super setDelegate:(id<UITableViewDelegate>)_delegateProxy];
}

#pragma mark -

- (NSIndexPath *)modelIndexForCell:(UITableViewCell *)cell {
    return [_tableModel modelIndexFromTableIndex:[super indexPathForCell:cell] expand:nil];
}

- (NSIndexPath *)modelIndexForCell:(UITableViewCell *)cell expand:(out BOOL *)expand {
    return [_tableModel modelIndexFromTableIndex:[super indexPathForCell:cell] expand:expand];
}

- (id)cellForRowAtModelIndex:(NSIndexPath *)modelIndex expand:(in BOOL)expand {
    if ([_tableModel isExpandAtModelIndex:modelIndex]) {
        return [self cellForRowAtIndexPath:[_tableModel tableIndexFromModelIndex:modelIndex expand:expand]];
    }
    return nil;
}

- (void)openCellAtModelIndex:(NSIndexPath *)modelIndex animation:(BOOL)animation {
    if (![_tableModel isExpandAtModelIndex:modelIndex]) {

        if (animation) {
            [self beginUpdates];
        }
        
        // 收起已经展开的
        if (self.expandMutual) {
            NSArray *expandTableIndexs = [_tableModel expandTableIndexs];
           
            if (expandTableIndexs.count) {
                [_tableModel removeAllExpandIndexs];
                if (animation) {
                    [self deleteRowsAtIndexPaths:expandTableIndexs withRowAnimation:UITableViewRowAnimationFade];
                }
            }
        }
        
        // 展开新的
        NSIndexPath *tableIndex = [_tableModel tableIndexFromModelIndex:modelIndex expand:YES];
        [_tableModel insertExpandModelIndex:modelIndex];

        if (animation) {
            [self insertRowsAtIndexPaths:@[ tableIndex ] withRowAnimation:UITableViewRowAnimationFade];
            [self endUpdates];
        } else {
            [self reloadData];
//            [self insertRowsAtIndexPaths:@[tableIndex] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)closeCellAtModelIndex:(NSIndexPath *)modelIndex animation:(BOOL)animation {
    if ([_tableModel isExpandAtModelIndex:modelIndex]) {
        NSIndexPath *tableIndex = [_tableModel tableIndexFromModelIndex:modelIndex expand:YES];
      
        [_tableModel deleteExpandModelIndex:modelIndex];

        if (animation) {
            [self beginUpdates];
            [self deleteRowsAtIndexPaths:@[ tableIndex ] withRowAnimation:UITableViewRowAnimationFade];
            [self endUpdates];
        } else {
//            [self deleteRowsAtIndexPaths:@[ tableIndex ] withRowAnimation:UITableViewRowAnimationNone];
            [self reloadData];
        }
    }
}

- (void)reloadCellAtModelIndex:(NSIndexPath *)modelIndex animation:(BOOL)animation {
    NSIndexPath *tableIndex = [_tableModel tableIndexFromModelIndex:modelIndex expand:NO];

    if (animation) {
        [self beginUpdates];
        if ([_tableModel isExpandAtModelIndex:modelIndex]) {
            [self reloadRowsAtIndexPaths:@[ tableIndex, [NSIndexPath indexPathForRow:tableIndex.row + 1 inSection:tableIndex.section] ] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self reloadRowsAtIndexPaths:@[ tableIndex ] withRowAnimation:UITableViewRowAnimationFade];
        }
        [self endUpdates];
    } else {
        [self reloadData];
    }
}

- (void)toggleCellAtModelIndex:(NSIndexPath *)modelIndex animation:(BOOL)animation {
    if ([_tableModel isExpandAtModelIndex:modelIndex]) {
        [self closeCellAtModelIndex:modelIndex animation:animation];
    } else {
        [self openCellAtModelIndex:modelIndex animation:animation];
    }
}

- (void)openCellAtModelIndex:(NSIndexPath *)indexPath {
    [self openCellAtModelIndex:indexPath animation:NO];
}

- (void)closeCellAtModelIndex:(NSIndexPath *)indexPath {
    
    [self closeCellAtModelIndex:indexPath animation:NO];
}

- (void)reloadCellAtModelIndex:(NSIndexPath *)indexPath {
    [self reloadCellAtModelIndex:indexPath animation:NO];
}

- (void)toggleCellAtModelIndex:(NSIndexPath *)indexPath {
    [self toggleCellAtModelIndex:indexPath animation:NO];
}

- (NSIndexPath *)tableIndexFromModelIndex:(NSIndexPath *)modelIndex expand:(in BOOL)expand {
    return [_tableModel tableIndexFromModelIndex:modelIndex expand:expand];
}

- (NSIndexPath *)modelIndexFromTableIndex:(NSIndexPath *)tableIndex expand:(out BOOL *)expand {
    return [_tableModel modelIndexFromTableIndex:tableIndex expand:expand];
}

- (BOOL)isExpandAtModelIndex:(NSIndexPath *)modelIndex {
    return [_tableModel isExpandAtModelIndex:modelIndex];
}

- (BOOL)isExpandAtTableIndex:(NSIndexPath *)tableIndex {
    return [_tableModel isExpandAtTableIndex:tableIndex];
}

- (void)closeAllCells {
    return [_tableModel removeAllExpandIndexs];
}

- (NSArray *)expandModelIndexs {
    return _tableModel.expandModelIndexs.copy;
}

- (NSArray *)expandTableIndexs {
    return _tableModel.expandTableIndexs.copy;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_hasDataSourceBit.numberOfRowsInSection) {
        NSInteger numberOfRowsInSection = [_dataSourceProxy.receiver tableView:tableView numberOfRowsInSection:section];
        return numberOfRowsInSection == 0 ? 0 : numberOfRowsInSection + [[_tableModel expandArrayOfSection:section] count];
    }

    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil];
}

- (UITableViewCell *)tableView:(DPCollapseTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isExpandCell = NO;
    NSIndexPath *tableIndex = indexPath;
    NSIndexPath *modelIndex = [_tableModel modelIndexFromTableIndex:tableIndex expand:&isExpandCell];

    if (isExpandCell) {
        if (_hasDataSourceBit.expandCellForRowAtIndexPath) {
            return [_dataSourceProxy.receiver tableView:tableView expandCellForRowAtIndexPath:modelIndex];
        }
    } else {
        if (_hasDataSourceBit.cellForRowAtIndexPath) {
            return [_dataSourceProxy.receiver tableView:tableView cellForRowAtIndexPath:modelIndex];
        }
    }

    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(DPCollapseTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isExpandCell = NO;
    NSIndexPath *tableIndex = indexPath;
    NSIndexPath *modelIndex = [_tableModel modelIndexFromTableIndex:tableIndex expand:&isExpandCell];

    if (isExpandCell) {
        if (_hasDelegateBit.expandHeightForRowAtIndexPath) {
            return [_delegateProxy.receiver tableView:tableView expandHeightForRowAtIndexPath:modelIndex];
        }
    } else {
        if (_hasDelegateBit.heightForRowAtIndexPath) {
            return [_delegateProxy.receiver tableView:tableView heightForRowAtIndexPath:modelIndex];
        }
    }

    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil];
}

@end