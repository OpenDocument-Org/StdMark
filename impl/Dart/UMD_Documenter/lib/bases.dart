import "package:UMD_Documenter/styles.dart";


//MarkDown System
class MarkDown{
  //{Parent: [Child,...]}
  static final Map<MDElmKind,List<MDElmKind>> elmKindTree ={
    MDElmKind.Root: [
      MDElmKind.HeadIdentifier,
      MDElmKind.Void,
      MDElmKind.Doc,
      MDElmKind.Page,
      MDElmKind.Group,
      MDElmKind.Header,
      MDElmKind.Table,
      MDElmKind.List
    ]
    MDElmKind.List: [MDElmKind.OrdList,MDElmKind.UnOrdList]
  };
  static final Map<MDElmKind,List<MDElmKind>> notIncludable{
    MDElmKind.Doc: [MDElmKind.Doc],
    MDElmKind.Page: [MDElmKind.Page,MDElmKind.BlankPage,MDElmKind.Doc],
    MDElmKind.Group: [MDElmKind.Page,MDElmKind.BlankPage,MDElmKind.Doc],
    MDElmKind.Columns: [MDElmKind.Group,MDElmKind.Page,MDElmKind.BlankPage,MDElmKind.Doc]
  };
  static List<MDExtenPod> _addedPods = <MDExtenPod>[];
  static final Map<MDElmKind,bool Function(int)> elmLoc = {};
  static void require(MDExtenPod pod){
    this._addedPods.add(pod);
  }
  static String elmKindToString(MDElmKind kind){
    String className = kind.toString().split('.')[1];
  }
  static bool hasParentElmKind(MDElmKind elm){}
  static List<MDElmKind> getParentElmKind(MDElmKind elm){
  }
  static bool hasChildElmKind(MDElmKind elm) => MarkDown.elmKindTree[elm].length != 0;
  static List<MDElmKind> getChildElmKind(MDElmKind elm) => MarkDown.elmKindTree[elm];
  static render(PageNavigator nav){}
}

//MarkDown Extensions System
class MDExtenPod{
  MDExtenPod();
  static void require(){}
}

//MarkDown Elements
enum MDElmKind{
  Void,
  HeadIdentifier
  Doc,
  Page,
  Group,
  Header,
  Table,
  List,
  OrdList,
  UnOrdList,
}

class MDElm{
  MDElmKind _kind;
  StdConfigure? _cfgs;
  MDElm(MDElmKind kind){
    this._kind = kind;
  }
  MDElm setCfg(Configure cfgs){
    this._cfgs=cfgs;
    return this;
  }
  String toMDString() => "";
  String toHTMLString() => "";
  String finalyMDString() => "";
  String finalyHTMLString() => "";
  MDElm calalFase() => this;
  MDElmKind get kind => this._kind;
  MDElm dispacher(MDElm intent) => this;
  MDElm linker(LinkingSource link) => this;
  MDElm? cow();
}

// Errors and Exceptions
class NoSuchAsElmException extends Exception{
  final String message;
  final MDElmKind kind;
  NoSuchAsElmException([this.message="", this.kind=MDVoidElm()]){}
}