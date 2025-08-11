大変申し訳ございません。マークダウンのフォーマットに誤りがありました。

-----

## WeightLayout for SwiftUI

**WeightLayout**は、SwiftUIの新しい`Layout`プロトコルを利用し、ビューに\*\*重み（weight）\*\*を割り当てることで、利用可能なスペースを比例配分するライブラリです。

-----

### 使い方

#### 1\. 水平方向のレイアウト (`LayoutHStack`)

`LayoutHStack`を使用し、`.weightH()`モディファイアで各ビューの横幅の比率を指定します。

```swift
LayoutHStack {
    Color.red
        .weightH(1) // 1/3のスペースを占める
    Color.blue
        .weightH(2) // 2/3のスペースを占める
}
.frame(width: 300, height: 100)
```

#### 2\. 垂直方向のレイアウト (`LayoutVStack`)

`LayoutVStack`を使用し、`.weightV()`モディファイアで各ビューの縦幅の比率を指定します。

```swift
LayoutVStack {
    Color.green
        .weightV(1) // 1/3のスペースを占める
    Color.orange
        .weightV(2) // 2/3のスペースを占める
}
.frame(width: 100, height: 300)
```
