//
//  ViewController.m
//  PaintPalette
//
//  Created by LQL on 2019/8/1.
//  Copyright © 2019 com.lal. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+FloodFill.h"
#import "PPImageView.h"
#import "ColorCollectionViewCell.h"
#import <Photos/Photos.h>
#import <SVProgressHUD/SVProgressHUD.h>
#define KSCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define KSCREENHEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,PPImageViewDelegate>{
    NSInteger imageIndex;
     NSInteger currentIndex;
}
@property (weak, nonatomic) IBOutlet UICollectionView *colloView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageRatioConstraint;
@property(nonatomic,strong)NSMutableArray<UIColor *> *colors;//颜色数组
@property(nonatomic,strong)NSMutableArray *images;
//底部srollView
@property (nonatomic, strong) UIScrollView  *imgScroll;
//显示图片
@property (nonatomic, strong) PPImageView  *myImageView;
@property(nonatomic,strong)UIImage *oldeImg;//保留上次的img
@property (nonatomic, strong) UIColor *color;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colloView.delegate = self;
    self.colloView.dataSource = self;
    [self.colloView registerClass:[ColorCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.imgScroll];
    self.imgScroll.center = self.view.center;
    self.color = self.colors.firstObject;
    currentIndex = 0;
}
//清除
- (IBAction)clearClick:(id)sender {
     [self setImageViewImge];
}
//切换图片
- (IBAction)nextImgClick:(id)sender {
    ++imageIndex;
    imageIndex %= self.images.count;
    [self setImageViewImge];
}
//撤销
- (IBAction)repealClick:(id)sender {
    self.myImageView.image = self.oldeImg;
}
- (IBAction)saveClick:(id)sender {
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:self.myImageView.image];
    } error:&error];
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
    }
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.colors.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ColorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.bgView.backgroundColor = self.colors[indexPath.item];
    [cell.flgImageView setHidden:(indexPath.item == currentIndex) ? NO : YES];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.color = self.colors[indexPath.item];
    currentIndex = indexPath.item;
    [self.colloView reloadData];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(30, 30);
}
//颜色
- (NSMutableArray<UIColor *> *)colors{
    if (!_colors) {
        _colors = [NSMutableArray arrayWithObjects:[UIColor blackColor],[UIColor whiteColor],[UIColor redColor],[UIColor blueColor],[UIColor yellowColor],[UIColor greenColor],[UIColor purpleColor],[UIColor brownColor],[UIColor cyanColor],[UIColor magentaColor],[UIColor orangeColor], nil];
    }
    return _colors;
}
-(NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
        for (int i = 1; i<45; i++) {
            [_images addObject:[NSString stringWithFormat:@"%d.png",i]];
        }
    }
    return _images;
}
-(UIScrollView *)imgScroll {
    if (!_imgScroll) {
        _imgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, KSCREENWIDTH,KSCREENWIDTH)];
        _imgScroll.delegate = self;
        //底部不要透明，否则图片缩小的时候会看到被遮住的界面
        _imgScroll.backgroundColor = [UIColor whiteColor];
        //最大级别
        _imgScroll.maximumZoomScale = 10;
        //初始化缩放级别
        self.imgScroll.zoomScale = 1;
        _imgScroll.userInteractionEnabled = YES;
//        [self.view addSubview:_imgScroll];
    }
    return _imgScroll;
}
-(PPImageView *)myImageView {
    if (!_myImageView) {
        _myImageView = [[PPImageView alloc] initWithFrame:self.imgScroll.bounds];
        _myImageView.backgroundColor = [UIColor clearColor];
        _myImageView.contentMode = UIViewContentModeScaleAspectFit;
        _myImageView.image = [UIImage imageNamed:@"1.png"];
        _myImageView.userInteractionEnabled = YES;
        _myImageView.delegate = self;
        [self.imgScroll addSubview:_myImageView];
    }
    return _myImageView;
}

// 设置UIScrollView中要缩放的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.myImageView;
}
// 让UIImageView在UIScrollView缩放后居中显示
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.myImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                          scrollView.contentSize.height * 0.5 + offsetY);
}


- (void)covertImageToBitmapWithPoint: (CGPoint)point {
    self.oldeImg = self.myImageView.image;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [self.oldeImg floodFillImageFromStartPoint:point newColor:self.color tolerance:10 useAntialias:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.myImageView.image = image;
        });
    });
}
-(void)setImageViewImge{
    self.myImageView.image = [UIImage imageNamed:self.images[imageIndex]];
}
-(void)touches:(CGPoint)point{
 
    point.x = roundf(self.myImageView.image.size.width / self.myImageView.bounds.size.width * point.x);
    point.y = roundf(self.myImageView.image.size.height / self.myImageView.bounds.size.height * point.y);
    [self covertImageToBitmapWithPoint:point];
}
@end
