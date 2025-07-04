import 'package:flicker_free/db/mapper/base_mapper.dart';
import 'package:objectbox/objectbox.dart';

import '../entity/star.dart';

class StarMapper extends BaseMapper {
  late Box<Star> starBox;

  StarMapper(super.db) {
    starBox = db.box<Star>();
  }

  Future<void> add(Star star) async {
    await starBox.putAsync(star);
  }

  Future<List<Star>> list() {
    return starBox.getAllAsync();
  }

  Future<void> remove(int id) async {
    final star = await starBox.getAsync(id);
    if (star != null) {
      await starBox.removeAsync(id);
    }
  }

  Future<void> update(Star star) async {
    await starBox.putAsync(star);
  }
}
