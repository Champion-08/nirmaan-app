import '../models/customer_model.dart';
import '../mock/mock_data.dart';
import '../supabase_service.dart';
import 'store_and_auth_repository.dart';

class CustomerRepository {
  final List<CustomerModel> _localCustomers = List.from(MockData.customers);
  final StoreRepository _storeRepo = StoreRepository();

  Future<List<CustomerModel>> getCustomers() async {
    if (SupabaseService.isDemoMode) {
      return List.unmodifiable(_localCustomers);
    }

    final client = SupabaseService.requireAuthClient();
    final store = await _storeRepo.getStore();
    if (store == null || store.id.isEmpty) return [];

    final res = await client
        .from('customers')
        .select()
        .eq('store_id', store.id)
        .order('total_spent', ascending: false);
    return (res as List).map((c) => CustomerModel.fromJson(c)).toList();
  }

  Future<void> addCustomer(CustomerModel customer) async {
    if (SupabaseService.isDemoMode) {
      _localCustomers.insert(0, customer);
      return;
    }

    final client = SupabaseService.requireAuthClient();
    final storeId = await _storeRepo.getRequiredStoreId();

    final payload = customer.toJson();
    payload['store_id'] = storeId;
    if (customer.id.isEmpty || customer.id.startsWith('cust-') || customer.id.startsWith('demo-')) {
      payload.remove('id');
    }

    await client.from('customers').insert(payload);
  }

  Future<void> updateCustomer(CustomerModel customer) async {
    if (SupabaseService.isDemoMode) {
      final index = _localCustomers.indexWhere((c) => c.id == customer.id);
      if (index != -1) _localCustomers[index] = customer;
      return;
    }

    final client = SupabaseService.requireAuthClient();
    final storeId = await _storeRepo.getRequiredStoreId();

    final payload = customer.toJson();
    payload['store_id'] = storeId;

    await client
        .from('customers')
        .update(payload)
        .eq('id', customer.id)
        .eq('store_id', storeId);
  }
}
