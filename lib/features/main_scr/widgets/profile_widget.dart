import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import './logout_button.dart';
import './CustomDropout.dart';
import '../../../controllers/auth_controler/auth_controller.dart';

class ProfileWidget extends StatelessWidget {
  ProfileWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Image.asset('assets/profile.png'),
              ),
            ),
            SizedBox(width: 40),
            Text('Никнейм'),
          ],
        ),
        SizedBox(height: 100, width: 200, child: LogoutButton()),
      ],
    );
  }
}
