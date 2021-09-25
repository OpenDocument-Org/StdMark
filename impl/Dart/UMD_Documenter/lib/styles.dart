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
