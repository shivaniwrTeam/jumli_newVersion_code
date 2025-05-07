import 'package:eClassify/data/model/item/item_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemEditGlobal {
  final List<ItemModel> list;

  ItemEditGlobal(this.list);
}

class ItemEditCubit extends Cubit<ItemEditGlobal> {
  ItemEditCubit() : super(ItemEditGlobal([]));

  void add(ItemModel model) {
    var list = state.list;
    int indexOfElement = list.indexWhere((element) => element.id == model.id);
    if (indexOfElement != -1) list.removeAt(indexOfElement);

    list.add(model);
    emit(ItemEditGlobal(list));
  }

  ItemModel get(ItemModel model) {
    return state.list.firstWhere((element) => element.id == model.id,
        orElse: () {
      return model;
    });
  }

  void remove() {}
}
