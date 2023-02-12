class Categor{
  int? idc;
  String? namec;
  int? colorlbl;

  lblMap() {
    var mapping = Map<String, dynamic>();
    mapping['idlabel'] = idc ?? null;
    mapping['namelabel'] = namec!;
    mapping['colorlabel'] = colorlbl ?? 0xFFFFFFFF;

    return mapping;
  }  }