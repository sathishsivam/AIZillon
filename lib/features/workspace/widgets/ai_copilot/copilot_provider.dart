import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/copilot_view.dart';

class CopilotController extends Notifier<CopilotView> {
  @override
  CopilotView build() {
    return CopilotView.overview;
  }

  void changeView(CopilotView view) {
    state = view;
  }
}

final copilotProvider = NotifierProvider<CopilotController, CopilotView>(
  CopilotController.new,
);
