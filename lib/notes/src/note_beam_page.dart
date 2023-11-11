import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:libcli/net/net.dart' as net;

class NotesBeamPage<T extends net.Object> extends BeamPage {
  NotesBeamPage({
    required String id,
    required String super.title,
    required super.child,
  }) : super(
          key: ValueKey(id),
          onPopPage: (
            BuildContext context,
            BeamerDelegate delegate,
            RouteInformationSerializable state,
            BeamPage poppedPage,
          ) {
            // no need to refresh
            //            final controller = Provider.of<NotesController<T>>(context, listen: false);
            //          controller.refresh(context);
            return BeamPage.pathSegmentPop(context, delegate, state, poppedPage);
          },
        );
}
