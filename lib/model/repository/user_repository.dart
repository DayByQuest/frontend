import 'package:flutter_application_1/main.dart';

import '../dataSource/remote_data_source.dart';
import 'package:get_it/get_it.dart';

class UserRpository {
  final RemoteDataSource _RemoteDataSource;
  UserRpository({RemoteDataSource? remoteDataSource})
      : _RemoteDataSource = remoteDataSource ?? getIt.get<RemoteDataSource>();
}
