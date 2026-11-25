import '../models/customer_model.dart';
import '../mock/mock_data.dart';
import '../supabase_service.dart';

class CustomerRepository {
  final List<CustomerModel> _localCustomers = List.from(MockData.customers);

  Future<List<CustomerModel>> getCustomers() async {
    if (SupabaseService.isDemoMode) {
      return List.unmodifiable(_localCustomers);
    }

    try {
      final res = await SupabaseService.client!
          .from('customers')
          .select()
          .order('total_spent', ascending: false);
      return (res as List).map((c) => CustomerModel.fromJson(c)).toList();
    } catch (_) {
      return List.unmodifiable(_localCustomers);
    }
  }

  Future<void> addCustomer(CustomerModel customer) async {
    if (SupabaseService.isDemoMode) {
      _localCustomers.insert(0, customer);
      return;
    }

    await SupabaseService.client!.from('customers').insert(customer.toJson());
  }

  Future<void> updateCustomer(CustomerModel customer) async {
    if (SupabaseService.isDemoMode) {
      final index = _localCustomers.indexWhere((c) => c.id == customer.id);
      if (index != -1) _localCustomers[index] = customer;
      return;
    }

    await SupabaseService.client!
        .from('customers')
        .update(customer.toJson())
        .eq('id', customer.id);
  }
}
