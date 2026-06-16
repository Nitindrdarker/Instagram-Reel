// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:instagram_reel/features/feed/data/datasource/feed_api.dart'
    as _i239;
import 'package:instagram_reel/features/feed/data/datasource/mock_feed_api.dart'
    as _i1065;
import 'package:instagram_reel/features/feed/data/repository/feed_repository_impl.dart'
    as _i907;
import 'package:instagram_reel/features/feed/domain/repository/feed_repository.dart'
    as _i591;
import 'package:instagram_reel/features/feed/presentation/bloc/feed_bloc.dart'
    as _i810;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i239.FeedApi>(() => _i1065.MockFeedApi());
    gh.lazySingleton<_i591.FeedRepository>(
      () => _i907.FeedRepositoryImpl(gh<_i239.FeedApi>()),
    );
    gh.factory<_i810.FeedBloc>(
      () => _i810.FeedBloc(gh<_i591.FeedRepository>()),
    );
    return this;
  }
}
