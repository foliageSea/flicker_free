import 'package:objectbox/objectbox.dart';

@Entity()
class Star {
  @Id()
  int id = 0;
  String? url;
}
