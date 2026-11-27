import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/store_model.dart';
import '../models/product_model.dart';
import '../models/customer_model.dart';
import '../models/order_model.dart';
import '../models/notification_model.dart';
import '../models/ai_brief_model.dart';
import '../repositories/repositories.dart';

// ─── Base Repository Providers ────────────────────────────────────────

final authRepoProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final storeRepoProvider = Provider<StoreRepository>((ref) {
  return StoreRepository();
});

final productRepoProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

final customerRepoProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository();
});

final orderRepoProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});

final notificationRepoProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

final analyticsRepoProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository();
});

// ─── Auth State & Store Providers ─────────────────────────────────────

/// Auth Repository Provider
final authProvider = Provider<AuthRepository>((ref) {
  return ref.watch(authRepoProvider);
});

/// Watches Supabase auth state changes so all user-scoped providers reset on login/logout.
final authStateProvider = StreamProvider<AuthState?>((ref) {
  final auth = ref.watch(authRepoProvider);
  final stream = auth.authStateChanges;
  if (stream == null) return Stream.value(null);
  return stream;
});

/// Current Store Information Provider (watches authStateProvider for per-user isolation)
final currentStoreProvider = FutureProvider<StoreModel?>((ref) async {
  ref.watch(authStateProvider);
  final auth = ref.watch(authRepoProvider);
  if (!auth.isAuthenticated) return null;
  final repo = ref.watch(storeRepoProvider);
  return repo.getStore();
});

/// Alias kept for backwards compatibility across screens.
final storeProvider = currentStoreProvider;

/// Products List Provider
class ProductsNotifier extends StateNotifier<AsyncValue<List<ProductModel>>> {
  ProductsNotifier(this._repo) : super(const AsyncValue.loading()) {
    loadProducts();
  }

  final ProductRepository _repo;

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repo.getProducts();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addProduct(ProductModel product) async {
    await _repo.addProduct(product);
    await loadProducts();
  }

  Future<void> updateStock(String id, int qty) async {
    await _repo.updateStock(id, qty);
    await loadProducts();
  }
}

final productsProvider =
    StateNotifierProvider<ProductsNotifier, AsyncValue<List<ProductModel>>>((ref) {
  ref.watch(authStateProvider);
  final repo = ref.watch(productRepoProvider);
  return ProductsNotifier(repo);
});

/// Orders List Provider
class OrdersNotifier extends StateNotifier<AsyncValue<List<OrderModel>>> {
  OrdersNotifier(this._repo) : super(const AsyncValue.loading()) {
    loadOrders();
  }

  final OrderRepository _repo;

  Future<void> loadOrders() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repo.getOrders();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createOrder(OrderModel order) async {
    await _repo.createOrder(order);
    await loadOrders();
  }
}

final ordersProvider =
    StateNotifierProvider<OrdersNotifier, AsyncValue<List<OrderModel>>>((ref) {
  ref.watch(authStateProvider);
  final repo = ref.watch(orderRepoProvider);
  return OrdersNotifier(repo);
});

/// Customers List Provider
class CustomersNotifier extends StateNotifier<AsyncValue<List<CustomerModel>>> {
  CustomersNotifier(this._repo) : super(const AsyncValue.loading()) {
    loadCustomers();
  }

  final CustomerRepository _repo;

  Future<void> loadCustomers() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repo.getCustomers();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addCustomer(CustomerModel customer) async {
    await _repo.addCustomer(customer);
    await loadCustomers();
  }
}

final customersProvider =
    StateNotifierProvider<CustomersNotifier, AsyncValue<List<CustomerModel>>>((ref) {
  ref.watch(authStateProvider);
  final repo = ref.watch(customerRepoProvider);
  return CustomersNotifier(repo);
});

/// Notifications Provider
class NotificationsNotifier extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  NotificationsNotifier(this._repo) : super(const AsyncValue.loading()) {
    loadNotifications();
  }

  final NotificationRepository _repo;

  Future<void> loadNotifications() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repo.getNotifications();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markAsRead(String id) async {
    await _repo.markAsRead(id);
    await loadNotifications();
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, AsyncValue<List<NotificationModel>>>((ref) {
  ref.watch(authStateProvider);
  final repo = ref.watch(notificationRepoProvider);
  return NotificationsNotifier(repo);
});

/// Analytics & AI Brief Provider
final analyticsProvider = FutureProvider<AiBriefModel?>((ref) async {
  ref.watch(authStateProvider);
  final auth = ref.watch(authRepoProvider);
  if (!auth.isAuthenticated) return null;
  final repo = ref.watch(analyticsRepoProvider);
  return repo.getLatestAiBrief();
});

/// Invalidates all user-scoped Riverpod providers on sign-out or account switch.
void invalidateUserProviders(WidgetRef ref) {
  ref.invalidate(currentStoreProvider);
  ref.invalidate(productsProvider);
  ref.invalidate(ordersProvider);
  ref.invalidate(customersProvider);
  ref.invalidate(notificationsProvider);
  ref.invalidate(analyticsProvider);
}
