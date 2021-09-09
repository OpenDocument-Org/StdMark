import "package:UMD_Documenter/stdLib.dart";
import "package:matrix2d/matrix2d.dart";

//ある程度おちついたら、「TextaileDocumenter」
enum Location{
  Top,
  Bottom,
  None,
}
enum NumStyle{
  Normal,
}
enum SmallLetterKind{
  Super,
  Sub,
  Wari,
}
class FigureNum{
  NumStyle _ns;
  String _prefix;
  String _suffix;
  FigureNum.setStyle(String prefix, String suffix, NumStyle ns){
    this._ns = ns;
    this._prefix = prefix;
    this._suffix = suffix;
  }
  String getFigureNum(int number){
    if(this._ns == NumStyle.Normal){
      return this._prefix + number.toString() + this._suffix;
    }else{
      return "";
    }
  }
}
class OrdCfg{
  NumStyle _sty;
  List<int> _resetRule;
  FigureNum.setStyle(List<int> isReset, NumStyle ns){
    this._sty = ns;
    this._isReset = isReset;
  }
  OrdCfg addResetRule(int forLevel, int byLevel);
}
abstract class Configure{}
class StdConfigure extends Configure with TextCfg, Padding, Border, Margin{}
mixin TextCfg{}
mixin Padding{}
mixin Border{}
mixin Margin{}
class Caption{
  int _index;
  FigureNum _fn;
  Location _captLocs;
  List<String> _captStrs;
  Caption(FigureNum fn, Location loc){
    this._index = 0;
    this._fn = fn;
    this._captLocs = loc;
    this._captStrs = <String>[];
  }
  Location get location => this._captLocs;
  Caption add(String title){
    this._captStrs.add(title);
  }
  String getCaptionString(){
    this._index++;
    return this._fn.getFigureNum(this._index) + "\t" + this._captStrs[this._index-1];
  }
  bool isLocNone(){
    return this._captLocs == Location.None;
  }
  bool isntEmpty(){
    return this._captStrs.length - this._index > 0;
  }
  bool isEmpty(){
    return !(this.isntEmpty());
  }
}
extension TableMDS on List<List<String>>{
  String toTableString(Caption title,[bool needBorder = false]){
    //各列の最大文字数
    List<List<int>> tblTrand = this.map((List<String> elm)=>elm.map((String elm2)=>elm2.length).toList()).toList().transpose;
    List<int> maxLen = tblTrand.map((List<int> elm)=>elm.reduce((int curr, int next){
      if(curr > next){
        return curr;
      }else{
        return next;
      }
    })).toList();
    int lineLen = maxLen.reduce((int curr, int next) => curr + next) + 3*maxLen.length + 4;
    String delimLine = List.filled(lineLen,"-").join("");
    String tableString = this.map((List<String> elm)=>elm.indexedMap((int ind,String elm2)=>elm2.padRight(maxLen[ind])).join("   ")).join("\n$delimLine\n");
    String bordered;
    if(needBorder){
      bordered = "$delimLine\n$tableString\n$delimLine";
    }else{
      bordered = tableString;
    }
    if(title.isLocNone() || title.isEmpty()){
      return bordered;
    }else{
      String returning;
      String capt = title.getCaptionString();
      Location loc = title.location;
      if(loc == Location.Top){
        if(needBorder){
          returning = capt + "\n" + bordered;
        }else{
          returning = capt + "\n\n" + bordered;
        }
      }else if(loc == Location.Bottom){
        if(needBorder){
          returning = bordered + "\n" + capt;
        }else{
          returning = bordered + "\n\n" + capt;
        }
      }else{
        returning = "";
      }
      return returning;
    }
  }
  MarkDownTable toMarkDown(Caption title,[bool needBorder = false]){
    return MarkDownTable(title: title,body: this,needBorder: needBorder);
  }
}
mixin LinkAnchor{
  static MarkDownElm refer();
}
mixin Notifier{}
class PageNavigator{
  PageNavigator.navigate(){}

}
class MarkDown{
  Map<MarkDownElmKind,List<MarkDownElmKind>> _list={};
  static String elmKindToString(MarkDownElmKind kind){
    String className = kind.toString().split('.')[1];
  }
  static bool hasParentElmKind(){}
  static List<MarkDownElmKind> getParentElmKind(){
    
  }
  static render(PageNavigator nav){}
}
mixin MarkDownElmHolder{
  List<MarkDownElm> _mdl;
  MarkDownElm add(MarkDownElm content){

  }
  MarkDownElm getNthElmKind(int ind, MarkDownElmKind kind){
    if(this._mdl.length == 0){
      throw RangeError("指定されたインデックスに該当する要素がない: 要素数が0");
    }else{
      List<MarkDownElm> deg = this._mdl.where((MarkDownElm elm){
        if(kind==MarkDownElmKind.List){
          return (elm.kind == MarkDownElmKind.List)||(elm.kind == MarkDownElmKind.OrdList)||(elm.kind == MarkDownElmKind.UnOrdList);
        }else{
          return elm.kind == kind;
        }
      }).toList();
      if(deg.length == 0){
        throw NoSuchAsElmException("",kind);
      }else if(deg.length <= ind){
        throw RangeError("指定されたインデックスに該当する要素がない: 引数で指定された要素数未満");
      }else{
        return deg[ind];
      }
    }
  }
  bool isNthElmTheKind(int ind, MarkDownElmKind kind){
    return this.getNthElmKind(int ind)==kind;
  }
  MarkDownElm getNthElm(int ind){
    if(this._mdl.length == 0 || this._mdl.length <= ind){
      throw RangeError("指定されたインデックスに該当する要素がない: 要素数が0または引数で指定された要素数未満");
    }else{
      return this._mdl[ind];
    }
  }
  MarkDownElmKind getNthElmKind(int ind){
    if(this._mdl.length == 0 || this._mdl.length <= ind){
      throw RangeError("指定されたインデックスに該当する要素がない: 要素数が0または引数で指定された要素数未満");
    }else{
      return this._mdl[ind].kind;
    }
  }
  @override
  String toMarkDownString(){
    String main = this._mdl.map((MarkDownElm elm)=>elm.calalFase().toMarkDownString()).join("\n");
    List<String> ends = this.finalyMarkDownString();
    return [ends[0],main,ends[1]].join("\n");
  }
  @override
  String toHTMLString(){
    String main = this._mdl.map((MarkDownElm elm)=>elm.calalFase().toHTMLString()).join("\n");
    List<String> ends = this.finalyHTMLString();
    return [ends[0],main,ends[1]].join("\n");
  }

  bool isIncludable(MarkDownElmKind kind){
    Map<MarkDownElmKind,List<MarkDownElmKind>> notIncludable{
      MarkDownElmKind.Doc: [MarkDownElmKind.Doc],
      MarkDownElmKind.Page: [MarkDownElmKind.Page,MarkDownElmKind.BlankPage,MarkDownElmKind.Doc],
      MarkDownElmKind.Group: [MarkDownElmKind.Page,MarkDownElmKind.BlankPage,MarkDownElmKind.Doc],
      MarkDownElmKind.Columns: [MarkDownElmKind.Group,MarkDownElmKind.Page,MarkDownElmKind.BlankPage,MarkDownElmKind.Doc]
    }
    if(notIncludable.containsKey(this.kind)){
      return !(notIncludable[this.kind].contains(kind));
    }
    return false;
  }
}
enum MarkDownElmKind{
  Void,
  Header,
  Table,
  OrdList,
  UnOrdList,
}
class LinkingSource{}
class MarkDownElm{
  MarkDownElmKind _kind;
  StdConfigure? _cfgs;
  MarkDownElm(MarkDownElmKind kind){
    this._kind = kind;
  }
  MarkDownElm setCfg(Configure cfgs){
    this._cfgs=cfgs;
    return this;
  }
  String toMarkDownString() => "";
  String toHTMLString() => "";
  String finalyMarkDownString() => "";
  String finalyHTMLString() => "";
  MarkDownElm calalFase() => this;
  MarkDownElmKind get kind => this._kind;
  MarkDownElm dispacher(MarkDownElm intent) => this;
  MarkDownElm linker(LinkingSource link) => this;
  MarkDownElm? cow();
}
class MarkDownVoidElm extends MarkDownElm{
  MarkDownVoidElm(){
    this._kind = MarkDownElmKind.Void;
  }
  @override
  String toMarkDownString(){
    return "";
  }
}
class MarkDownDoc extends MarkDownElm with MarkDownElmHolder{
  MarkDownDoc.fromList(List<MarkDownElm> mdList){
    this._mdl = mdList;
  }
  MarkDownDoc(){
    this._mdl = <MarkDownElm>[];
  }
  MarkDownDoc makeTOC(){}
  MarkDownDoc makeBiblio(){}
  MarkDownDoc makeFoots(){}
  File write([String path,File file]){
    String content = this.toMarkDownString();
    if(path==null&&file!=null){
      path = file.path;
    }else if(path!=null&&file==null){
      file = File(path);
    }else{
      throw ArgumentError("引数pathまたは引数fileのいずれか1つのみ指定してください");
    }
    file.writeAsStringSync(content);
    return file;
  }
  Future<File> writeAsync([String path,File file]){
    String content = this.toMarkDownString();
    if(path==null&&file!=null){
      path = file.path;
    }else if(path!=null&&file==null){
      file = File(path);
    }else{
      throw ArgumentError("引数pathまたは引数fileのいずれか1つのみ指定してください");
    }
    return file.writeAsString(content);
  }
}
class MarkDownGroup extends MarkDownElm with MarkDownElmHolder{
  MarkDownGroup(){
    this._mdl = <MarkDownElm>[];
  }
}
class MarkDownColumns extends MarkDownElm with MarkDownElmHolder{
  MarkDownGroup(){
    this._mdl = <MarkDownElm>[];
  }
}
class MarkDownPage extends MarkDownElm with MarkDownElmHolder{
  List<MarkDownFootNoteData> _foots;
  MarkDownPage(){
    this._mdl = <MarkDownElm>[];
  }
  MarkDownPage addFoots(){}
  MarkDownPage makeFoots(){}}
class MarkDownHeader extends MarkDownElm{
  int _level;
  String _line;
}
class MarkDownNoAncHeader extends MarkDownElm{
  int _level;
  String _line;
}
class MarkDownBlankPage extends MarkDownElm{
  MarkDownPage _page;
  MarkDownBlankPage();
}

class MarkDownTable extends MarkDownElm{
  Caption _title;
  bool _needBorder;
  List<String>? _header;
  List<List<String>> _body;
  MarkDownTable({@require Caption title,List<String> header,@require List<List<String>> body,bool needBorder: false}){}
}
class MarkDownList extends MarkDownElm{}
class MarkDownOrdList extends MarkDownList{}
class MarkDownUnOrdList extends MarkDownList{}
class MarkDownBr extends MarkDownElm{}
class MarkDownHr extends MarkDownElm{}
class MarkDownLink extends MarkDownElm{}
class MarkDownImg extends MarkDownElm{}
class MarkDownFootNoteLabel extends MarkDownElm{}
class MarkDownFootNoteArea extends MarkDownElm{}
class MarkDownFootNoteData{}
class MarkDownBiblioLabel extends MarkDownElm{}
class MarkDownBiblioArea extends MarkDownElm{}
class MarkDownBiblioData{}
class MarkDownTOC extends MarkDownElm{}
class MarkDownAnchorPoint extends MarkDownElm{}
class MarkDownQuate extends MarkDownElm{}
class MarkDownCode extends MarkDownElm{}
class MarkDownExpr extends MarkDownElm{}
class MarkDownArticle extends MarkDownElm{}
class MarkDownSmallLetter extends MarkDownElm{
  SmallLetterKind _slk;
  int _corLines;
  String _letter;
}
class MarkDownBigLetter extends MarkDownElm{
  int _corLines;
  String _letter;
}
class MarkDownTextDefine extends MarkDownElm{
  String _key;
  String _str;
}
class MarkDownInterpole extends MarkDownElm{
  MarkDownElm _intent;
  List<MarkDownElm> _poler;
  MarkDownInterpole(MarkDownElm intent){
    this._intent = intent;
    this._poler = <MarkDownElm>[];
  }
  MarkDownInterpole poler(List<MarkDownElm> route){
    this._poler.addAll(route);
    return this
  }
  @override
  MarkDownInterpole calalFase(){
    if(this._poler.length > 0){
      this._poler.forEach((MarkDownElm elm)=>elm.dispacher(this._intent));
    }
    return this;
  }
}
class MarkDownStdText extends MarkDownElm{
  String _text;
  MarkDownStdText(String text){
    this._text = text;
  }
  @override
  String toHTMLString(){
    return this._text;
  }
}

class NoSuchAsElmException extends Exception{
  final String message;
  final MarkDownElmKind kind;
  NoSuchAsElmException([this.message="", this.kind=MarkDownVoidElm()]){}
}