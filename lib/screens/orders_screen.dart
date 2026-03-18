import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_order.dart';
import '../providers/orders_provider.dart';
import '../utils/formatters.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Đơn mua',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            padding: EdgeInsets.only(left: 16),
            labelPadding: EdgeInsets.only(right: 22),
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontSize: 16),
            tabs: [
              Tab(text: 'Chờ xác nhận'),
              Tab(text: 'Đang giao'),
              Tab(text: 'Đã giao'),
              Tab(text: 'Đã hủy'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _OrderList(status: OrderStatus.waitingConfirm),
            _OrderList(status: OrderStatus.shipping),
            _OrderList(status: OrderStatus.delivered),
            _OrderList(status: OrderStatus.canceled),
          ],
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersProvider>(
      builder: (context, ordersProvider, _) {
        final orders = ordersProvider.byStatus(status);
        if (orders.isEmpty) {
          return const Center(
            child: Text('Chưa có đơn hàng', style: TextStyle(fontSize: 17)),
          );
        }

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mã đơn: ${order.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Số sản phẩm: ${order.items.length}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      'Thanh toán: ${order.paymentMethod}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      'Tổng: ${formatCurrency(order.total)}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
