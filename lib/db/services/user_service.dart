import 'package:flicker_free/db/mapper/user_mapper.dart';

import '../database.dart';
import '../entity/user.dart';

part 'impl/user_service_impl.dart';

abstract class UserService {
  Future add(User user);
  Future<List<User>> list();
}
