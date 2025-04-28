import 'package:flutter_lovexa_ecommerce/interface/repo_interface.dart';

abstract class FeaturedDealRepositoryInterface implements RepositoryInterface{

  Future<dynamic> getFeaturedDeal();
}