# UMD Format Spec: 統一マークダウン形式標準仕様書

## 諸元

- 名称(和): 統一マークダウン形式
- 名称(英): Universal MarkDown Format
- 略称: UMD Format, UMD形式, UMD
- 拡張子: `.md`, `.umd`
  - 原則として前者を使用するが、UMDであることを明示する場合、或いは拡張標準仕様に従って実装される機能を用いる場合は後者を使用する。
- 沿革: (以下全て日時はJST)
  - 2021/6/8: 旧UMDL(Universal MarkDown Language)及び旧ChesMD(Ches MarkDown)が合同して成立
  - 2021/6/9: 標準仕様書第一次草稿の上梓(当時デファクト実装MD形式に依拠)
- 仕様は、その性格によって基本標準仕様、追加標準仕様、拡張標準仕様の三種に区分される。
  - 基本標準仕様: デファクト仕様の継続。どのベンダも同様に実装しなければならない共通標準仕様である。
  - 追加標準仕様: デジュリ仕様における追加仕様。どのベンダも同様に実装しなければならない共通標準仕様である。
  - 拡張標準仕様: デジュリ仕様における追加仕様。公式実装は標準で実装するものとするが、サードパーティーベンダによる実装は任意である。
- 公式実装のほか、仕様を満たすと判断した実装は認定される(下記の区分は時代経過によって変更されることがある)
  - Dart/Fantom/Ruby/Rustは認定とする
  - Go/Haskell/LISPは準認定とする
  - その他は認定しない

## 実装計画(公式)

- 取り敢えずDart/Fantom実装 for web-render/app-render/trans-html
- ぼちぼちRuby/Rust実装 for desk-render/trans-pdf

## 基本標準仕様

Discord及びVSCodeの実装するものを採用する。

## 追加標準仕様


- アンカーを生まないheaderを追加

  ```umd
  #| noanc as h1
  ##| noanc as h2
  ```

- 目次(doctoc)・脚注(footnote)・文献(biblio)機能標準装備

  ```umd
  $makedoctoc

  $footnote[the note]

  {bib}
  $biblio{|
    bibitem[bib1]{auth:,doc:,book?:,pub?:,date?:,.url?:},
    bibitem[bib2]{auth:,doc:,book?:,pub?:,date?:,.url?:},
  |}
  ```

- html/pdf変換機能標準装備
  - `umdc`: umd compile
- 画像の幅等を設定できるように

  ```umd
  ![alt](url){width:,height:}
  ```

- 数式・コードブロックの標準装備
- 上付き・下付き文字
- フォントサイズ・色

  ```umd
  $style[alt]{color:, size:}
  ```

- 改行・スペース調整
- 表の強化
- 文字列補間

  ```umd
  ${補間}
  ```

- マージン・パディング
- ブロック・段落

  ```umd
  $block{}{|
  |}

  $para{}{|
  |}
  ```

- 任意箇所にアンカー

  ```umd
  :{to-ancs}
  $anc[alt]{to-ancs}
  ```

## 拡張標準仕様

- スキーマ(`.mdsch`)・スタイル(`.mdsty`)・メタファイル(`.mdcn`)・スクリプト(`.mdps`)の読み込み

  ```umd
  --- .mdcn
  use: doctoc
  use: somefn from somepkg.mdps
  ```

  ```umd
  $class[] for .mdsch
  $pair{}  for .mdsty
  $meta[] for .mdcn
  ```

  ```sh
  title.mdsty
  stdutl.mdps
  doctoc.mdps
  ```

- パッケージシステム(`.mdpkg`/`mpkgr`)

  ```sh
  file samplepkg.mdpkg
  mdpkgr install samplepkg
  ```

- スクリプトの実行(`mdps`)

  ```sh
  file stdutl.mdps
  mdps run stdutl main.umd
  ```
