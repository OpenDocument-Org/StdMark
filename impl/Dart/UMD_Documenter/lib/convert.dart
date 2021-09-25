import "package:umd_documenter/bases.dart";
import "package:umd_documenter/elements.dart";
import "package:umd_documenter/commonLib.dart";

import "package:matrix2d/matrix2d.dart";

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
  MDTable toMD(Caption title,[bool needBorder = false]){
    return MDTable(title: title,body: this,needBorder: needBorder);
  }
}
