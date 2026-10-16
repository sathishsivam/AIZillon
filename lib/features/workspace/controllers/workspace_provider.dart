import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'workspace_controller.dart';
import 'workspace_state.dart';

final workspaceControllerProvider =
    NotifierProvider<WorkspaceController, WorkspaceState>(
      WorkspaceController.new,
    );
