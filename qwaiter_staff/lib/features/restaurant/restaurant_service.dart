import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';

class RestaurantService {
  final Dio _dio = DioClient().dio;
}
