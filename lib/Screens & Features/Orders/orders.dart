import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Data/checkout_services.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _userId;

  final List<String> _orderTypes = [
    'Pending Orders',
    'Completed Orders',
    'Canceled Orders'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _orderTypes.length, vsync: this);
    _initUserId();
  }

  Future<void> _initUserId() async {
    _userId = await CheckOutServices().getDeviceId();
    setState(() {});
  }

  Stream<QuerySnapshot> _fetchOrders(String type) {
    return FirebaseFirestore.instance
        .collection('Orders')
        .doc(_userId)
        .collection(type)
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<List<Map<String, dynamic>>> _fetchOrderItems(
      String type, String orderId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Orders')
        .doc(_userId)
        .collection(type)
        .doc(orderId)
        .collection('orderLists')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<Map<String, dynamic>?> _fetchProductDetails(
      String productId, String variantId) async {
    try {
      final productDoc = await FirebaseFirestore.instance
          .collection('Products')
          .doc(productId)
          .get();

      final variantDoc = await FirebaseFirestore.instance
          .collection('Products')
          .doc(productId)
          .collection('Variations')
          .doc(variantId)
          .get();

      if (productDoc.exists && variantDoc.exists) {
        final data = productDoc.data()!..addAll({
          'images': variantDoc.data()?['images'] ?? [],
        });
        return data;
      }
    } catch (e) {
      debugPrint('Error fetching product: $e');
    }
    return null;
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchProductDetails(item['productId'], item['variant']),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: LinearProgressIndicator(),
          );
        }

        final product = snapshot.data!;
        final imageUrl = (product['images'] as List).isNotEmpty
            ? product['images'][0]
            : null;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          leading: imageUrl != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          )
              : const Icon(Icons.image_not_supported),
          title: Text(product['title'] ?? 'No Title'),
          subtitle: Text(
              'Qty: ${item['quantity']} | Size: ${item['selectedSize']} | Variant: ${item['variant']}'),
        );
      },
    );
  }

  Widget _buildOrderCard(DocumentSnapshot orderDoc, String type) {
    final data = orderDoc.data() as Map<String, dynamic>;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchOrderItems(type, orderDoc.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final orderItems = snapshot.data!;

        return LayoutBuilder(
          builder: (context, constraints) {

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${data['name']}',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 20,
                          runSpacing: 4,
                          children: [
                            Text('Phone: ${data['phoneNumber']}'),
                            Text('Location: ${data['deliveryLocation']}'),
                            Text('Total: Tk ${data['total']}'),
                            Text('Time: ${data['time'].toDate()}'),
                            if (data['usedCoin'] != null)
                              Text('Used Coins: ${data['usedCoin']}'),
                            if (data['usedPromoCode'] != null)
                              Text('Promo Code: ${data['usedPromoCode']}'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text('Items:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ...orderItems.map(_buildOrderItem),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_userId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _orderTypes.map((type) => Tab(text: type)).toList(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return TabBarView(
            controller: _tabController,
            children: _orderTypes.map((type) {
              return StreamBuilder<QuerySnapshot>(
                stream: _fetchOrders(type),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No orders found.'));
                  }
                  return ListView(
                    padding: const EdgeInsets.all(8),
                    children: snapshot.data!.docs
                        .map((doc) => _buildOrderCard(doc, type))
                        .toList(),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}