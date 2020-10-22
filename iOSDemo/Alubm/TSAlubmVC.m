//
//  TSAlubmVC.m
//  iOSDemo
//
//  Created by 孙同生 on 2020/9/15.
//  Copyright © 2020 孙同生. All rights reserved.
//

#import "TSAlubmVC.h"
#import <Photos/Photos.h>
#import "PreviewUrlView.h"
#import "UIViewController+Present.h"

@interface TSAlubmVC ()
@property(nonatomic) PHFetchResult * assetsFetchResults;
@end

@implementation TSAlubmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.assetsFetchResults = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
}

//相册相关api测试
-(void)test{
        PHAuthorizationStatus photoStatus = [PHPhotoLibrary authorizationStatus];
    
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            NSLog(@"%s status:%ld",__func__,(long)status);
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (status) {
                    case PHAuthorizationStatusAuthorized: //已获取权限
                        [self setupVideo];
                        break;
    
                    case PHAuthorizationStatusDenied: //用户已经明确否认了这一照片数据的应用程序访问
                        break;
    
                    case PHAuthorizationStatusRestricted://此应用程序没有被授权访问的照片数据。可能是家长控制权限
                        break;
    
                    default://其他。。。
                        break;
                }
            });
        }];
}

//MARK: -

-(void)setupVideo{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
       option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",PHAssetMediaTypeVideo];
       option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
       
       NSMutableArray* phAssets = [NSMutableArray array];
       
       //fetchAssetCollectionsWithType
       PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
       for (PHAssetCollection *collection in smartAlbums) {
           // 有可能是PHCollectionList类的的对象，过滤掉
           if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
           // 过滤空相册
           if (collection.estimatedAssetCount <= 0) continue;
           PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
           [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
               PHAsset *phAsset = (PHAsset *)obj;
               //可通过此PHAsset用下边方法分别获取时常、地址及缩略图
               [phAssets addObject:phAsset];
           }];
       }
       
       PHAsset* videoAsset = nil;
       for (PHAsset* asset in phAssets) {
           if(asset.mediaType == PHAssetMediaTypeVideo){
               videoAsset = asset;
               break;
           }
       }
       
       if(!videoAsset) return;
       [[PHImageManager defaultManager] requestPlayerItemForVideo:videoAsset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
    

           [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
           AVPlayer* player = [AVPlayer playerWithPlayerItem:playerItem];
           AVPlayerLayer* playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
           playerLayer.frame = self.view.bounds;
           [self.view.layer addSublayer:playerLayer];
           [player play];
           
       }];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        AVPlayerItem* item = (AVPlayerItem*)object;
        if ([keyPath isEqualToString:@"status"]) {
            switch (item.status) {
                case AVPlayerItemStatusReadyToPlay:
                    NSLog(@"AVPlayerItemStatusReadyToPlay");
                    break;
                    
                case AVPlayerItemStatusUnknown:
                    NSLog(@"AVPlayerItemStatusUnknown");
                    break;
                    
                case AVPlayerItemStatusFailed:
                    NSLog(@"AVPlayerItemStatusFailed");
                    break;
                    
                default:
                    break;
            }
            
        }     }
}


/**
注册监听示范
 
 监听：
 [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
 
 */
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    
    PHFetchResultChangeDetails* collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
    if(collectionChanges){
        self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
        if(!collectionChanges.hasIncrementalChanges || collectionChanges.hasMoves){
            NSLog(@"%s no hasIncrementalChanges  hasMoves",__func__);
        }
        else{
            if(collectionChanges.removedIndexes.count > 0){
                NSLog(@"%s 删除了 %lu 张图片",__func__,(unsigned long)collectionChanges.removedIndexes.count);
            }
            if(collectionChanges.changedIndexes.count > 0){
                NSLog(@"%s 修改了 %lu 张图片",__func__,(unsigned long)collectionChanges.changedIndexes.count);
            }
            if(collectionChanges.insertedIndexes.count > 0){
                NSLog(@"%s 新增 %lu 张图片",__func__,(unsigned long)collectionChanges.insertedIndexes.count);
                
                PHAsset* newImgPhAsset = [self.assetsFetchResults objectAtIndex:[collectionChanges.insertedIndexes firstIndex]];
                
                
            }
        }
    }
}
@end
