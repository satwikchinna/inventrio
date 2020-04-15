class Item {
  int _itemid;
  String _itemname;
  double _itemstock;
  int _uom;
  double _sellingprice;
  double _costprice;

  Item(this._itemname, this._itemstock, this._uom, this._sellingprice,
      this._costprice);

  Item.map(dynamic obj) {
    this._itemname = obj["itemname"];
    this._itemstock = obj["itemstock"];
    this._uom = obj["uom"];
    this._sellingprice = obj["sellingprice"];
    this._costprice = obj["costprice"];
    this._itemid = obj["itemid"];
  }

  String get itemname => _itemname;

  double get itemstock => _itemstock;

  int get uom => _uom;
  double get sellingprice => _sellingprice;
  double get costprice => _costprice;
  int get itemid => _itemid;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["itemname"] = _itemname;
    map["itemstock"] = _itemstock;
    map["uom"] = _uom;
    map['sellingprice'] = _sellingprice;
    map['costprice'] = _costprice;
    if (itemid != null) {
      map['itemid'] = _itemid;
    }

    return map;
  }

  Item.fromMap(Map<String,dynamic> map)
  {
this._itemname = map["itemname"];
    this._itemstock = map["itemstock"];
    this._uom = map["uom"];
    this._sellingprice = map["sellingprice"];
    this._costprice = map["costprice"];
    this._itemid = map["itemid"];
  }
}
