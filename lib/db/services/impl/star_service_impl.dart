part of '../star_service.dart';

class StarServiceImpl with AppDatabaseMixin implements StarService {
  late StarMapper starMapper;

  StarServiceImpl() {
    starMapper = StarMapper(db);
  }

  @override
  Future add(Star star) async {
    await starMapper.add(star);
  }

  @override
  Future<List<Star>> list() {
    return starMapper.list();
  }

  @override
  Future remove(int id) async {
    await starMapper.remove(id);
  }

  @override
  Future update(Star star) async {
    await starMapper.update(star);
  }
}
