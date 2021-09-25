import "package:UMD_Documenter/bases.dart";
import "package:UMD_Documenter/styles.dart";


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

mixin LinkAnchor{
  static MDElm refer();
}
mixin Notifier{}
class PageNavigator{
  PageNavigator.navigate(){}

}

mixin ManagedURI{
  bool _validate=false;
  String _pathStr;
  Map<String> _uriSet = <String>{};
  void setURI(String uri){
    if(this.isValidURI(uri)){
      this._validate = true;
      this._uriSet = URI(uri);
    }
    this._pathStr = uri;
  }
  bool isValidURI(String uri){}
  String get getFullURI => this._pathStr;
  void _onUnvalid(String where, String byOn){
    throw FormatException("不正なURI | $where の取得に失敗",　byOn);
  }
}
mixin MDElmHolder{
  List<MDElm> _mdl;
  MDElm add(MDElm content){

  }
  MDElm getNthElmKind(int ind, MDElmKind kind){
    if(this._mdl.length == 0){
      throw RangeError("指定されたインデックスに該当する要素がない: 要素数が0");
    }else{
      List<MDElm> deg = this._mdl.where((MDElm elm){
        if(kind==MDElmKind.List){
          return (elm.kind == MDElmKind.List)||(elm.kind == MDElmKind.OrdList)||(elm.kind == MDElmKind.UnOrdList);
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
  bool isNthElmTheKind(int ind, MDElmKind kind){
    return this.getNthElmKind(int ind)==kind;
  }
  MDElm getNthElm(int ind){
    if(this._mdl.length == 0 || this._mdl.length <= ind){
      throw RangeError("指定されたインデックスに該当する要素がない: 要素数が0または引数で指定された要素数未満");
    }else{
      return this._mdl[ind];
    }
  }
  MDElmKind getNthElmKind(int ind){
    if(this._mdl.length == 0 || this._mdl.length <= ind){
      throw RangeError("指定されたインデックスに該当する要素がない: 要素数が0または引数で指定された要素数未満");
    }else{
      return this._mdl[ind].kind;
    }
  }
  @override
  String toMDString(){
    String main = this._mdl.map((MDElm elm)=>elm.calalFase().toMDString()).join("\n");
    List<String> ends = this.finalyMDString();
    return [ends[0],main,ends[1]].join("\n");
  }
  @override
  String toHTMLString(){
    String main = this._mdl.map((MDElm elm)=>elm.calalFase().toHTMLString()).join("\n");
    List<String> ends = this.finalyHTMLString();
    return [ends[0],main,ends[1]].join("\n");
  }

  bool isIncludable(MDElmKind kind){
    Map<MDElmKind,List<MDElmKind>> notIncludable = MarkDown.notIncludable;
    if(notIncludable.containsKey(this.kind)){
      return !(notIncludable[this.kind].contains(kind));
    }
    return false;
  }
}
class LinkingSource{}
class MDVoidElm extends MDElm{
  MDVoidElm(){
    this._kind = MDElmKind.Void;
  }
  @override
  String toMDString(){
    return "";
  }
}
class MDDoc extends MDElm with MDElmHolder{
  MDDoc.fromList(List<MDElm> mdList){
    this._mdl = mdList;
  }
  MDDoc(){
    this._mdl = <MDElm>[];
  }
  MDDoc makeTOC(){}
  MDDoc makeBiblio(){}
  MDDoc makeFoots(){}
  File write([String path,File file]){
    String content = this.toMDString();
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
    String content = this.toMDString();
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
class MDGroup extends MDElm with MDElmHolder{
  MDGroup(){
    this._mdl = <MDElm>[];
  }
}
class MDColumns extends MDElm with MDElmHolder{
  MDGroup(){
    this._mdl = <MDElm>[];
  }
}
class MDPage extends MDElm with MDElmHolder{
  List<MDFootNoteData> _foots;
  MDPage(){
    this._mdl = <MDElm>[];
  }
  MDPage addFoots(){}
  MDPage makeFoots(){}
}
class MDHeadIdentifier extends MDElm{
}
class MDFlowList extends MDElm{
  bool _hasHead;
  String? _head;
  List<String> _listElms;
}
class MDHeader extends MDElm{
  int _level;
  String _line;
}
class MDNoAncHeader extends MDElm{
  int _level;
  String _line;
}
class MDBlankPage extends MDElm{
  MDPage _page;
  MDBlankPage();
}

class MDTable extends MDElm{
  Caption _title;
  bool _needBorder;
  List<String>? _header;
  List<List<String>> _body;
  MDTable({@require Caption title,List<String> header,@require List<List<String>> body,bool needBorder: false}){}
}
class MDList extends MDElm{}
class MDOrdList extends MDList{}
class MDUnOrdList extends MDList{}
class MDBr extends MDElm{}
class MDHr extends MDElm{}
class MDLink extends MDElm{}
class MDImg extends MDElm{}
class MDFootNoteLabel extends MDElm{}
class MDFootNoteArea extends MDElm{}
class MDFootNoteData{}
class MDBiblioLabel extends MDElm{}
class MDBiblioArea extends MDElm{}
class MDBiblioData{}
class MDTOC extends MDElm{}
class MDAnchorPoint extends MDElm{}
class MDQuate extends MDElm{}
class MDCode extends MDElm{}
class MDExpr extends MDElm{}
class MDArticle extends MDElm{}
class MDSmallLetter extends MDElm{
  SmallLetterKind _slk;
  int _corLines;
  String _letter;
}
class MDBigLetter extends MDElm{
  int _corLines;
  String _letter;
}
class MDTextDefine extends MDElm{
  String _key;
  String _str;
}
class MDInterpole extends MDElm{
  MDElm _intent;
  List<MDElm> _poler;
  MDInterpole(MDElm intent){
    this._intent = intent;
    this._poler = <MDElm>[];
  }
  MDInterpole poler(List<MDElm> route){
    this._poler.addAll(route);
    return this
  }
  @override
  MDInterpole calalFase(){
    if(this._poler.length > 0){
      this._poler.forEach((MDElm elm)=>elm.dispacher(this._intent));
    }
    return this;
  }
}
class MDStdText extends MDElm{
  String _text;
  MDStdText(String text){
    this._text = text;
  }
  @override
  String toHTMLString(){
    return this._text;
  }
}
