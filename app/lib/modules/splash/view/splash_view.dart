import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:encointer_wallet/service/init_web_api/init_web_api.dart';
import 'package:encointer_wallet/config/biometiric_auth_state.dart';
import 'package:encointer_wallet/service/auth/local_auth_service.dart';
import 'package:encointer_wallet/utils/repository_provider.dart';
import 'package:encointer_wallet/modules/modules.dart';
import 'package:encointer_wallet/gen/assets.gen.dart';
import 'package:encointer_wallet/common/components/logo/encointer_logo.dart';
import 'package:encointer_wallet/store/app.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  static const route = '/';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Future<void> _initPage() async {
    final store = context.read<AppStore>();
    await store.init(Localizations.localeOf(context).toString());

    // initialize it **after** the store was initialized.
    await initWebApi(context, store);

    // must be set after api is initialized.
    store.dataUpdate.setupUpdateReaction(() async {
      await store.encointer.updateState();
    });

    store.setApiReady(true);

    final appSettings = context.read<AppSettings>();
    if (appSettings.getBiometricAuthState == null) {
      final isDeviceSupported = await RepositoryProvider.of<LocalAuthService>(context).isDeviceSupported();
      if (!isDeviceSupported) await appSettings.setBiometricAuthState(BiometricAuthState.deviceNotSupported);
    }
    if (store.account.accountList.isNotEmpty) {
      await Navigator.pushNamedAndRemoveUntil(context, LoginView.route, (route) => false);
    } else {
      await Navigator.pushNamedAndRemoveUntil(context, CreateAccountEntryView.route, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('splashview'),
      body: FutureBuilder(
        future: _initPage(),
        builder: (context, s) {
          return DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(image: Assets.images.assets.mosaicBackground.provider(), fit: BoxFit.cover),
            ),
            child: const EncointerLogo(),
          );
        },
      ),
    );
  }
}
