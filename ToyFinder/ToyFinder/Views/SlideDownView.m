//
//  SlideDownView.m
//  ToyFinder
//
//  Created by Wang Shuguang on 13-5-31.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "SlideDownView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SlideDownView
@synthesize delegate;

- (void) dealloc{
    [dataArray release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        dataArray = [[NSArray alloc] initWithObjects:@"人气",@"销量",@"信用",@"    价格↓",@"    价格↑", nil];
        self.clipsToBounds = YES;
        
        // 头
        titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.backgroundColor = [UIColor clearColor];
        titleBtn.frame = CGRectMake(0, 0, frame.size.width, 44);
        titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:titleBtn];
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleBtn setTitle:[dataArray objectAtIndex:0] forState:UIControlStateNormal];
        
        // 选项列表
        sortList = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, frame.size.width, 150) style:UITableViewStylePlain];
        sortList.delegate = self;
        sortList.rowHeight = 30;
        sortList.dataSource = self;
        sortList.backgroundColor = RGBACOLOR(254, 246, 236, 1);
        [self addSubview:sortList];
        [sortList release];
        sortList.layer.borderWidth = 1.0f;
        sortList.layer.borderColor = RGBACOLOR(255,154,0,1).CGColor;
        sortList.separatorColor = RGBACOLOR(255,154,0,1);
        [sortList selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        sortList.scrollEnabled = NO;
    }
    return self;
}

- (void) titleBtnClick:(id)sender{
    if (self.frame.size.height < 100) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 150 + 44);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 44);
        }];
    }

}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"SortCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.backgroundColor = RGBACOLOR(254, 246, 236, 1);
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        UIView *seleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        seleBgView.backgroundColor = RGBACOLOR(245,124,0,1);
        cell.selectedBackgroundView = seleBgView;
        [seleBgView release];
        cell.textLabel.highlightedTextColor = RGBACOLOR(255, 255, 255, 1);
        cell.textLabel.textColor = RGBACOLOR(221, 70, 0, 1);
    }
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [titleBtn setTitle:[dataArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    if ([delegate respondsToSelector:@selector(slideDownView:didSelectedAtIndex:)]) {
        [delegate slideDownView:self didSelectedAtIndex:indexPath.row];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 44);
    }];
}


@end
