import 'package:geo_j/models/signin_info.dart';
import 'package:geo_j/providers/active_shipping_count/active_shipping_count_state.dart';
import 'package:geo_j/providers/signin/signin_provider.dart';

class ActiveShippingCountProvider {
  final SigninProvider signinProvider;

  ActiveShippingCountProvider({required this.signinProvider});

  ActiveShippingCountState get state => ActiveShippingCountState(
      activeShippingCount: signinProvider.state.signinInfo.devices
          .where((A10 a10) => a10.transportState != 1)
          .toList()
          .length);
}
