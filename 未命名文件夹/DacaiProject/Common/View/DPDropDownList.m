//
//  DPDropDownList.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-9.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPDropDownList.h"

#define kRowHeight  40

@interface DPDropDownList () <UITableViewDelegate, UITableViewDataSource> {
@private
}


@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong, readonly) UIImageView *backgroundView;
@end

@implementation DPDropDownList

- (instancetype)initWithItems:(NSArray *)items {
    if (self = [self init]) {
        self.items = items;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initialize];
        [self addSubview:self.backgroundView];
        [self addSubview:self.tableView];
        
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_top);
            make.right.equalTo(self);
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(100, kRowHeight * self.items.count);
}

- (void)_initialize {
    _backgroundView = [[UIImageView alloc] initWithImage:dp_CommonImage(@"dropdown_arrow.png")];
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColorFromRGB(0x1f1f1f);
    _tableView.rowHeight = kRowHeight;
    _tableView.separatorColor = UIColorFromRGB(0x5e5e5e);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.scrollEnabled = NO;
    
    if (IOS_VERSION_7_OR_ABOVE) {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = UIColorFromRGB(0xf6f5e3);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont dp_systemFontOfSize:15];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownList:selectedAtIndex:)]) {
        [self.delegate dropDownList:self selectedAtIndex:indexPath.row];
    }
}
@end
