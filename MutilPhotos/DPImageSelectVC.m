//
//  DPImageSelectVC.m
//  MutilPhotos
//
//  Created by Ray on 15/12/3.
//  Copyright © 2015年 Ray. All rights reserved.
//

#import "DPImageSelectVC.h"
#import "DPSelectImgView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

#define kScreenWidth        (CGRectGetWidth(UIScreen.mainScreen.bounds))
#define kScreenHeight       (CGRectGetHeight(UIScreen.mainScreen.bounds)


/**
 *  第一个相机的Cell
 */
@interface DPCameraCell : UICollectionViewCell
@property(nonatomic,strong) UIImageView *cameraImage ;

@end

@implementation DPCameraCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor] ;
        self.cameraImage.frame = frame ;
        [self.contentView addSubview:self.cameraImage] ;
    }
    return self;
}

-(UIImageView *)cameraImage{
    
    if (_cameraImage == nil) {
        _cameraImage = [[UIImageView alloc]init];
        _cameraImage.image = [UIImage imageNamed:@"communityImage1.png"] ;
        _cameraImage.contentMode = UIViewContentModeCenter ;
    }
    
    return _cameraImage ;
}


@end

@interface DPCollectionCell : UICollectionViewCell

/**
 * 选择标记View
 */
@property(nonatomic,strong) DPSelectImgView *selectView ;

@property(nonatomic,strong)ALAsset *asset ;


@end

@implementation DPCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.selectView];
        self.backgroundColor = [UIColor greenColor] ;
        
        
    }
    return self;
}


-(void)setAsset:(ALAsset *)asset{
    _asset = asset ;
    
    self.selectView.asset = asset ;
}


-(DPSelectImgView*)selectView{
    
    if (_selectView == nil) {
        _selectView = [[DPSelectImgView alloc]initWithFrame:self.bounds];
    }
    
    return _selectView ;
}

@end



@interface DPImageSelectVC  ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    
    UICollectionView *_collectionView ;
}
@property (nonatomic, strong) NSMutableArray *assets;

@property(nonatomic,strong) NSMutableSet *selectedIndexSet ;

@end

static NSString *const kCellIdentifier = @"Cell";
static NSString *const kCameraCellIdentifier = @"CameraCellIdentifier";

@implementation DPImageSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.selectedIndexSet = [[NSMutableSet alloc]init];
    self.view.backgroundColor = [UIColor whiteColor] ;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((kScreenWidth-20)/3.0, (kScreenWidth-20)/3.0);
    layout.minimumLineSpacing = 5 ;
    layout.minimumInteritemSpacing = 5 ;
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate =self ;
    _collectionView.dataSource = self ;
    [_collectionView registerClass:[DPCollectionCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [_collectionView registerClass:[DPCameraCell class] forCellWithReuseIdentifier:kCameraCellIdentifier];
    
    _collectionView.backgroundColor = [UIColor whiteColor] ;
    [self.view addSubview:_collectionView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)] ;
    self.navigationItem.rightBarButtonItem = rightItem ;
    
}

#pragma mark -点击完成
- (void)done:(id)sender
{
    
    
    if (self.selectedIndexSet.count > 9) {
        [[[UIAlertView alloc] initWithTitle:@"Sorry 抱歉" message:@"图片最多只能选9张" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    NSSortDescriptor *descrip = [NSSortDescriptor sortDescriptorWithKey:@"row" ascending:YES] ;
    
    NSArray *selectedArr = [self.selectedIndexSet sortedArrayUsingDescriptors:@[descrip]] ;
    
    NSMutableArray *array = [NSMutableArray array];
    
    for(NSIndexPath *indexPath in selectedArr){
        [array addObject:self.assets[indexPath.row-1 ]];
    }
    
    if(self.finishHandle)
    {
        self.finishHandle(array);
    }
    
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assets.count+1 ;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        DPCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCameraCellIdentifier forIndexPath:indexPath] ;
        
        return cell ;
    }
    
    
    DPCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath] ;
    cell.asset = [self.assets objectAtIndex:indexPath.row-1];
    cell.selectView.isSelected = [self.selectedIndexSet containsObject:indexPath];
    
    return cell ;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.row == 0){
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted)
            {
                [[[UIAlertView alloc] initWithTitle:nil message:@"本应用无访问相机的权限，如需访问，可在设置中修改" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
                return;
            }
        }else{
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied)
            {
                [[[UIAlertView alloc] initWithTitle:nil message:@"本应用无访问相机的权限，如需访问，可在设置中修改" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
                return;
            }
        }
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:^{
                
            }];
        }
        
        
        return ;
    }
    
    DPCollectionCell *cell = (DPCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath] ;
    cell.selectView.isSelected = !cell.selectView.isSelected ;
    
    if ([self.selectedIndexSet containsObject:indexPath]) {
        [self.selectedIndexSet removeObject:indexPath];
    }else{
        [self.selectedIndexSet addObject:indexPath];
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *selectImage = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *tempImage = nil;
    if (selectImage.imageOrientation != UIImageOrientationUp) {
        UIGraphicsBeginImageContext(selectImage.size);
        [selectImage drawInRect:CGRectMake(0, 0, selectImage.size.width, selectImage.size.height)];
        tempImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else{
        tempImage = selectImage;
    }
    
    if (self.cameraFinish) {
        self.cameraFinish(tempImage) ;
    }
    
}


#pragma mark - 传输数据
- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    
    // Set title
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    // Set assets filter
    [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    
    // Load assets
    NSMutableArray *assets = [NSMutableArray array];
    
    [self.assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            
            NSString *type = [result valueForProperty:ALAssetPropertyType];
            
            if ([type isEqualToString:ALAssetTypePhoto])
            {
                [assets addObject:result];
            }
        }
    }];
    
    self.assets = assets;
    
    
    
    [_collectionView reloadData];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
