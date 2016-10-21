//
//  MainVC.m
//  ShowAllFonts
//
//  Created by caisenchuan on 14-8-3.
//  Copyright (c) 2014年 caisenchuan. All rights reserved.
//

#import "MainVC.h"

//屏幕属性
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

@interface MainVC () <UIAlertViewDelegate>
{
    UITableView *mTableView;
    
    NSArray *mFontFamilyNames;
    NSString *mShowText;
}

@end

@implementation MainVC
#pragma mark - System Functions
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Test
    [self showAllFonts];
    
    //Nav
    self.title = @"All Fonts";
    UIBarButtonItem *navButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit Text"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(onRightNavButtonClick)];
    self.navigationItem.rightBarButtonItem = navButton;
    
    //Datas
    mShowText = @"Hello World 中文样式 0123456789";
    NSArray *arrTemp = [UIFont familyNames];
    mFontFamilyNames = [arrTemp sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    //Views
    mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                             style:UITableViewStyleGrouped];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    [self.view addSubview:mTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 生成索引标题数组

 @param dataArray 源数组

 @return 索引标题数组
 */
- (NSArray<NSString *> *)sectionIndexTitlesWithDataArray:(NSArray<NSString *> *)dataArray {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSString *string in dataArray) {
        BOOL flag = NO;
        for (NSString *existString in arr) {
            if ([existString isEqualToString:string]) {
                flag = YES;
            }
        }
        if (!flag) {
            [arr addObject:[string substringToIndex:1]];
        }
    }
    return arr;
}

#pragma mark - UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return mFontFamilyNames.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [self fontNamesOfSection:section];
    if (arr) {
        return arr.count;
    } else {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSString *fontName = [self fontNameOfIndexPath:indexPath];
    if (mShowText == nil || mShowText.length == 0) {
        cell.textLabel.text = @"Hello World 中文样式";
    } else {
        cell.textLabel.text = mShowText;
    }
    cell.textLabel.font = [UIFont fontWithName:fontName size:15];
    
    cell.detailTextLabel.text = fontName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [mFontFamilyNames objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fontName = [mFontFamilyNames objectAtIndex:indexPath.section];
    if (fontName && [fontName isEqualToString:@"Zapfino"]) {
        return 80;
    } else {
        return 50;
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self sectionIndexTitlesWithDataArray:mFontFamilyNames];
}

#pragma mark - AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        mShowText = [alertView textFieldAtIndex:0].text;
        [mTableView reloadData];
    }
}

#pragma mark - Our Functions
-(NSArray *)fontNamesOfSection:(NSInteger)section
{
    NSArray *ret;
    
    if (mFontFamilyNames && section < mFontFamilyNames.count) {
        NSString *familyName = [mFontFamilyNames objectAtIndex:section];
        ret = [UIFont fontNamesForFamilyName:familyName];
    }
    
    return ret;
}

-(NSString *)fontNameOfIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = [self fontNamesOfSection:indexPath.section];
    if (arr && indexPath.row < arr.count) {
        return [arr objectAtIndex:indexPath.row];
    } else {
        return nil;
    }
}

-(void)showAllFonts
{
    NSArray *familyNames = [UIFont familyNames];
    for(NSString *familyName in familyNames) {
        printf("Family: %s \n",[familyName UTF8String]);
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for(NSString *fontName in fontNames) {
            printf("\tFont: %s \n",[fontName UTF8String]);
        }
    }
}

-(void)onRightNavButtonClick
{
    UIAlertView *dialog = [[UIAlertView alloc]
                           initWithTitle:@"Please input text"
                           message:nil
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           otherButtonTitles:@"OK", nil];
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    [dialog textFieldAtIndex:0].text = mShowText;
    [dialog show];
}

@end
