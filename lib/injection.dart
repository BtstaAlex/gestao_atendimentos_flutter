import 'package:get_it/get_it.dart';
import 'data/datasources/database_helper.dart';
import 'data/repositories/atendimento_repository.dart';
import 'presentation/cubits/atendimento_cubit.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerSingleton<DatabaseHelper>(DatabaseHelper.instance);

  getIt.registerLazySingleton<AtendimentoRepository>(
    () => AtendimentoRepository(getIt<DatabaseHelper>()),
  );

  getIt.registerFactory<AtendimentoCubit>(
    () => AtendimentoCubit(getIt<AtendimentoRepository>()),
  );
}
