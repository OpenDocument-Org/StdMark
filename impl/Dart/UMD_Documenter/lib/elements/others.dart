import "package:umd_documenter/bases.dart";
import "package:umd_documenter/styles.dart";


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

mixin Notifier{}
class PageNavigator{
  PageNavigator.navigate(){}

}

class MDVoidElm extends MDElm{
  MDVoidElm(){
    this._kind = MDElmKind.Void;
  }
  @override
  String toMDString(){
    return "";
  }
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
class MDImg extends MDElm{}
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
