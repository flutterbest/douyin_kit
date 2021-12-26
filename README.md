# douyin_kit

flutter版抖音SDK
## docs

* [抖音开放平台](https://open.douyin.com/platform)

## android

```
# 不需要做任何额外接入工作
# 混淆已打入 Library，随 Library 引用，自动添加到 apk 打包混淆
```

## ios

```
在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所注册的应用程序id

URL Types
douyin: identifier=douyin schemes=${clientKey}
```

```
iOS 9系统策略更新，限制了http协议的访问，此外应用需要在“Info.plist”中将要使用的URL Schemes列为白名单，才可正常检查其他应用是否安装。

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>douyinopensdk</string>
    <string>douyinsharesdk</string>
    <string>snssdk1128</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

```
分享的图片通过相册进行跨进程共享手段，如需使用分享功能，还需要填相册访问权限，在 info 标签栏中添加 Privacy - Photo Library Usage Description。

<key>NSPhotoLibraryUsageDescription</key>
<string>分享的图片通过相册进行跨进程共享</string>
```

## flutter

* snapshot

```
dependencies:
  douyin_kit:
    git:
      url: https://github.com/flutterbest/douyin_kit.git
```
