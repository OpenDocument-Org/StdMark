import "package:UMD_Documenter/bases.dart";
import "package:UMD_Documenter/styles.dart";
import "package:UMD_Documenter/elements/others.dart";

//URI
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
//Link
mixin LinkAnchor{
  static MDElm refer();
}
class LinkingSource{}
class MDLink extends MDElm{}

//Interpolation
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
class MDTextDefine extends MDElm{
  String _key;
  String _str;
}

