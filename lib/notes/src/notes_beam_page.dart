import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:provider/provider.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'notes_controller.dart';

class NotesBeamPage<T extends pb.Object> extends BeamPage {
  NotesBeamPage({
    required String id,
    required String title,
    required Widget child,
  }) : super(
          key: ValueKey(id),
          title: title,
          child: child,
          onPopPage: (
            BuildContext context,
            BeamerDelegate delegate,
            RouteInformationSerializable state,
            BeamPage poppedPage,
          ) {
            final controller = Provider.of<NotesController<T>>(context, listen: false);
            controller.refresh(context);
            return BeamPage.pathSegmentPop(context, delegate, state, poppedPage);
          },
        );
}
