import 'package:flicker_free/db/database.dart';
import 'package:flicker_free/db/mapper/star_mapper.dart';

import '../entity/star.dart';

part 'impl/star_service_impl.dart';

abstract class StarService {
  Future add(Star star);

  Future<List<Star>> list();

  Future remove(int id);

  Future update(Star star);
}
