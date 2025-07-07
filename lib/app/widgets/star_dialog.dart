import 'package:core/core.dart';
import 'package:flicker_free/app/common/global.dart';
import 'package:flicker_free/app/widgets/tag.dart';
import 'package:flicker_free/db/entity/star.dart';
import 'package:flicker_free/db/services/star_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StarDialog extends StatefulWidget {
  final Star current;

  const StarDialog({super.key, required this.current});

  @override
  State<StarDialog> createState() => _StarDialogState();
}

class _StarDialogState extends State<StarDialog> with AppMessageMixin {
  RxList<Star> stars = <Star>[].obs;
  var starService = Global.getIt<StarService>();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    var list = await starService.list();
    stars.value = list;
    stars.refresh();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.6;
    var height = MediaQuery.of(context).size.height * 0.6;

    return AlertDialog(
      title: const Text('收藏'),
      content: SizedBox(
        width: width,
        height: height,
        child: Obx(
          () => CustomListView(
            itemCount: stars.length,
            itemBuilder: (BuildContext context, int index) {
              var star = stars[index];
              return ListTile(
                leading: Tag('${star.id}'),
                title: Text(
                  star.title ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${star.url}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    var id = widget.current.id;
                    if (id == star.id) {
                      await showToast('当前收藏被占用');
                      return;
                    }

                    await starService.remove(star.id);
                    await loadData();
                    await showToast('删除成功');
                  },
                ),
                onTap: () {
                  Get.back(result: star);
                },
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('关闭')),
      ],
    );
  }
}
