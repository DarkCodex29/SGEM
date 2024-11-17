import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';

part 'custom_table_controller.dart';

class CustomTable<T> extends StatelessWidget {
  const CustomTable({
    required this.headers,
    required this.data,
    required this.builder,
    this.actions,
    super.key,
  });

  final List<String> headers;
  final List<T> data;
  final List<Widget> Function(T) builder;
  final List<Widget> Function(T)? actions;

  static const _boldTextStyle = TextStyle(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(CustomTableController(data: data));

    return Obx(
      () {
        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    titleTextStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    pinned: true,
                    title: Row(
                      children: [
                        ...headers.map(
                          (header) => Expanded(
                            child: Text(
                              header,
                              style: _boldTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        if (actions != null)
                          const Expanded(
                            child: Text(
                              'Acción',
                              style: _boldTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    sliver: SliverList.separated(
                      itemCount: ctr.data.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: AppTheme.primaryBackground,
                      ),
                      itemBuilder: (context, index) {
                        final item = ctr.data[index];
                        return Row(
                          children: [
                            ...builder(item).map((e) => Expanded(child: e)),
                            if (actions != null)
                              Expanded(
                                child: Row(
                                  children: actions!(item),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Items por página:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Obx(
                  () {
                    return DropdownButton<int>(
                      value: ctr.rowsPerPage.value,
                      iconSize: 12,
                      style: const TextStyle(fontSize: 12),
                      items: const [5, 10, 20, 50]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e.toString(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) ctr.changeRowsPerPage(value);
                      },
                    );
                  },
                ),
                const SizedBox(width: 8),
                Obx(
                  () {
                    return Text(
                      '${ctr.infLimit} - ${ctr.supLimit} de ${ctr.totalRecords}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
                // first page
                const SizedBox(width: 24),
                Obx(
                  () {
                    return Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.first_page),
                          onPressed: ctr.currentPage.value == 1
                              ? null
                              : () => ctr.currentPage.value = 1,
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: ctr.currentPage.value == 1
                              ? null
                              : () => ctr.currentPage.value--,
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: ctr.currentPage.value == ctr.totalPages
                              ? null
                              : () => ctr.currentPage.value++,
                        ),
                        IconButton(
                          icon: const Icon(Icons.last_page),
                          onPressed: ctr.currentPage.value == ctr.totalPages
                              ? null
                              : () => ctr.currentPage.value = ctr.totalPages,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
