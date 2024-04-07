import 'package:dvmx/dvmx.dart';
import 'package:dvmx/src/app/app_commnad.dart';
import 'package:dvmx/src/app/app_container.dart';
import 'package:dvmx/src/app/command_services/doctor_command_service.dart';

final class DoctorCommand extends AppCommand {
  DoctorCommand();

  @override
  final name = 'doctor';

  @override
  final description =
      "Provides a comprehensive overview of the tool's version, "
      'configuration settings, and any potential issues with the setup.';

  @override
  Future<ExitStatus> run() async {
    final doctorCommandService =
        appContainer.read(doctorCommandServiceProvider);

    return doctorCommandService.call();
  }
}
