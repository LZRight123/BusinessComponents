
## 鹿管定位组件

1. 依赖[高德定位](https://lbs.amap.com/api/ios-location-sdk/guide/create-project/foundation-sdk)
2. 依赖[高德地图](https://lbs.amap.com/api/ios-sdk/guide/create-project/cocoapods)
3. 搜索功能[AMapSearch-NO-IDFA]


### 逻辑
1. 由于导航到地图只传有地址，先用地址进行地理位置编码得到经纬度。Geo
2. 地图拿到待导航经纬度，设置成中心点
