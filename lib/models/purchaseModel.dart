class Purchase {
  int itemid;
  int purchaseid;
  String quantity;
  String doc;
  double costprice;
  

  Purchase(this.quantity, this.doc, this.costprice);

  Purchase.map(dynamic obj) {
    this.itemid = obj["itemid"];
    this.quantity = obj["quantity"];
    this.doc = obj["doc"];
    this.costprice = obj["costprice"];
 
    this.purchaseid = obj["purchaseid"];
  }

  

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["quantity"] = quantity;
    map["doc"] = doc;
    map['costprice'] = costprice;
   
    if (itemid != null) {
      map['itemid'] = itemid;
    }
    if (purchaseid != null) {
      map['purchaseid'] = purchaseid;
    }

    return map;
  }

  Purchase.fromMap(Map<String,dynamic> map)
  {
this.itemid = map["itemid"];
    this.quantity = map["quantity"];
    this.doc = map["doc"];
    this.costprice = map["costprice"];
 
    this.itemid = map["itemid"];
  }
}
