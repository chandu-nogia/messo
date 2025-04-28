import 'package:flutter_lovexa_ecommerce/features/order/domain/repositories/order_repository_interface.dart';
import 'package:flutter_lovexa_ecommerce/features/order/domain/services/order_service_interface.dart';

class OrderService implements OrderServiceInterface{
  OrderRepositoryInterface orderRepositoryInterface;
  OrderService({required this.orderRepositoryInterface});

  @override
  Future cancelOrder(int? orderId,String?reason) async{
    return await orderRepositoryInterface.cancelOrder(orderId, reason);
  }



  @override
  Future<void> getOrderList(int offset, String status, {String? type}) async {
    return await orderRepositoryInterface.getOrderList(offset, status);
  }

  @override
  Future getTrackingInfo(String orderID)  async{
    return await orderRepositoryInterface.getTrackingInfo(orderID);
  }


}