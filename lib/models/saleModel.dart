class Sale {
  int _itemid;
  int saleid;
  double quantity;
  String doc;
  double sellingprice;
  

  Sale(this.quantity, this.doc, this.sellingprice,this._itemid);

  Sale.map(dynamic obj) {
    this._itemid = obj["_itemid"];
    this.quantity = obj["quantity"];
    this.doc = obj["doc"];
    this.sellingprice = obj["sellingprice"];
 
    this.saleid = obj["saleid"];
  }

  

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["quantity"] = quantity;
    map["doc"] = doc;
    map['sellingprice'] = sellingprice;
   
    if (_itemid != null) {
      map['_itemid'] = _itemid;
    }
    if (saleid != null) {
      map['saleid'] = saleid;
    }

    return map;
  }

  Sale.fromMap(Map<String,dynamic> map)
  {
    this.quantity = map["quantity"];
    this.doc = map["doc"];
    this.sellingprice = map["sellingprice"];
    this.saleid = map["saleid"];
    this._itemid = map["_itemid"];
  }
}
