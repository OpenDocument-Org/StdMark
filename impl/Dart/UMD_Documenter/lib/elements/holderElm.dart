import "package:umd_documenter/bases.dart";
import "package:umd_documenter/styles.dart";
import "package:umd_documenter/elements/others.dart";

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
