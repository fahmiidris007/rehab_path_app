import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../features/profile/domain/usecases/get_profile_use_case.dart';
import 'sos_state.dart';

@injectable
class SosCubit extends Cubit<SosState> {
  final GetProfileUseCase _getProfileUseCase;

  SosCubit(this._getProfileUseCase) : super(const SosState.loading());

  Future<void> loadContacts(String userId) async {
    emit(const SosState.loading());
    final result = await _getProfileUseCase(GetProfileParams(userId: userId));
    result.fold(
      (failure) => emit(SosState.error(failure.when(
        server: (msg, _) => msg,
        cache: (msg) => msg,
        validation: (msg, _) => msg,
        unexpected: (msg) => msg,
      ))),
      (user) => emit(SosState.loaded(user.emergencyContacts)),
    );
  }

  Future<void> callContact(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      emit(const SosState.callNotSupported());
    }
  }
}
