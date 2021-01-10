# iBadminton 愛羽球   <a href="https://apps.apple.com/us/app/ibadminton-%E6%84%9B%E7%BE%BD%E7%90%83/id1546797864"><img src="https://github.com/Volorf/Badges/blob/master/App%20Store/App%20Store%20Badge.png" alt="iBadminton store link" width="100" align="center" /></a>

<img src="https://github.com/maxkai1303/ProjectAsset/blob/master/cutmypic.png" width="100" align="center" />

*有時候想要打球卻不知道要去哪裡打* <BR>
*有時候隊友請假找不到人來補位子* <BR>
*為了這樣的需求，而生出來的 App* <BR>
*讓羽球資訊可以更開放流通，每個人都可以找到適合的活動，每天有球打 (๑•̀ㅂ•́)و✧*


# Features
### 登入
* **串接**`Sign in with Apple`**加速使用者登入流程**

### 查看活動
* **在首頁可以直接看到目前有招募的活動時間、地點和零打費用**
    - 引用 ` CarLensCollectionViewLayout` 達成首頁與球隊總覽頁面 Swiping Card 效果
* **登入狀態下可以在首頁看到適合的活動直接點擊加入**
* **活動到期或是招募人數已滿會隱藏該活動**
<img src="https://github.com/maxkai1303/ProjectAsset/blob/master/smartmockups_kjrbjb51.png" width="200" align="center" />


### 個人頁面
* **修改暱稱**
* **創建球隊**
    - 創建屬於自己的球隊
* **查看活動歷史紀錄**
    - 引用`Eureka`做成 Segment 與參加球隊表格切換顯示
    - 記錄參加過的活動並計算總參加次數提升球友成就感
* **查看加入的球隊**
    - 可以退出球隊 (唯一管理員無法退出)
    
    <img src="https://github.com/maxkai1303/ProjectAsset/blob/master/smartmockups_kjrbduv2.png" width="200" align="center" />


### 球隊總覽
###### 球隊管理員編輯功能
* **新增活動**
    - 輸入興趣點可以帶出地址
    - 最多可上傳四張活動照片
* **修改球隊資訊**
    - 新增 / 移除管理權限給球隊隊員

###### 一般用戶功能
* **球隊動態**
    - 引用 `ISTimeline`實現球隊動態，包含新增 / 退出隊員、活動、新增或移除管理者訊息
* **查看球隊成員**
* **加入球隊**
    - 可以加入多個球隊



# Libraries
* SwiftLint
* lottie-ios
* IQKeyboardManager
* Eureka
* ImageRow
* LocationRow
* ExpandingMenu
* Firebase/Firestore
* FirebaseFirestoreSwift
* Firebase/Storage
* ISTimeline
* Kingfisher
* Firebase/Auth
* CarLensCollectionViewLayout
* PKHUD
* Firebase/Crashlytics


## Requirement

Version  | iOS   | Xcode   |                Content               |
:--------:|:------:|:---------:|:-------------------------------|
1.1.1     | 12.0+ |  12.2 +  | 置換 App 內元件 icon 圖片|
1.1        | 12.0+ |  12.2 +  | Release                               |
