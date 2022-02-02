import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;

class NoData extends StatelessWidget {
  const NoData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 250,
        width: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wb_cloudy_outlined,
              size: 54,
              color: Colors.grey,
            ),
            Text(context.i18n.noDataLabel,
                style: const TextStyle(
                  color: Colors.grey,
                )),
          ],
        ),
      );
}
