-- ==============================================================================
-- NIRMAAN: Local Development Seed Script
-- File: supabase/seed.sql
-- ==============================================================================

-- If running seed against an existing local database with a test user:
DO $$
DECLARE
    demo_user_id UUID := '00000000-0000-0000-0000-000000000001';
    demo_store_id UUID := '10000000-0000-0000-0000-000000000001';
    p1 UUID := '20000000-0000-0000-0000-000000000001';
    p2 UUID := '20000000-0000-0000-0000-000000000002';
    p3 UUID := '20000000-0000-0000-0000-000000000003';
    p4 UUID := '20000000-0000-0000-0000-000000000004';
    p5 UUID := '20000000-0000-0000-0000-000000000005';
    p6 UUID := '20000000-0000-0000-0000-000000000006';
    c1 UUID := '30000000-0000-0000-0000-000000000001';
    c2 UUID := '30000000-0000-0000-0000-000000000002';
    c3 UUID := '30000000-0000-0000-0000-000000000003';
    c4 UUID := '30000000-0000-0000-0000-000000000004';
    c5 UUID := '30000000-0000-0000-0000-000000000005';
    o1 UUID := '40000000-0000-0000-0000-000000000001';
    o2 UUID := '40000000-0000-0000-0000-000000000002';
    o3 UUID := '40000000-0000-0000-0000-000000000003';
BEGIN
    -- 1. Insert store
    INSERT INTO public.stores (
        id, owner_id, business_name, category, owner_name, phone, email,
        gst_registered, currency, business_hours, kyc_verified
    ) VALUES (
        demo_store_id, demo_user_id, 'Shree Krishna General Store', 'Grocery & Daily Essentials',
        'Rahul Sharma', '+91 98765 43210', 'rahul@shreekrishnagrocery.in',
        true, 'INR', '08:00 AM - 10:00 PM', true
    ) ON CONFLICT (id) DO NOTHING;

    -- 2. Insert products
    INSERT INTO public.products (id, store_id, name, sku, barcode, category, selling_price, purchase_price, unit, stock_qty, low_stock_threshold)
    VALUES
        (p1, demo_store_id, 'Amul Taaza Homogenised Toned Milk 1L', 'DAIRY-AMUL-1L', '8901262010053', 'Dairy', 72.00, 64.00, 'pack', 28, 5),
        (p2, demo_store_id, 'Coca-Cola Original Taste 750ml', 'BEV-COKE-750', '8901764012231', 'Beverages', 45.00, 38.00, 'bottle', 18, 5),
        (p3, demo_store_id, 'Parle-G Gold Biscuits 1kg', 'SNK-PARLE-1K', '8901719101034', 'Snacks', 120.00, 102.00, 'pack', 4, 5),
        (p4, demo_store_id, 'Tata Salt Vacuum Evaporated 1kg', 'GROC-SALT-1K', '8904043901005', 'Staples', 28.00, 23.50, 'pack', 65, 10),
        (p5, demo_store_id, 'Aashirvaad Shudh Chakki Atta 5kg', 'STP-AASH-5K', '8901030383794', 'Staples', 245.00, 218.00, 'bag', 3, 5),
        (p6, demo_store_id, 'Fortune Sunlite Refined Sunflower Oil 1L', 'OIL-FORT-1L', '8906007280237', 'Grocery', 145.00, 128.00, 'bottle', 0, 5)
    ON CONFLICT (id) DO NOTHING;

    -- 3. Insert customers
    INSERT INTO public.customers (id, store_id, name, initials, phone, segment, total_spent, order_count, avg_cycle_days, last_purchase_at, preferred_payment, loyalty_points)
    VALUES
        (c1, demo_store_id, 'Rahul Sharma', 'RS', '+91 98201 22341', 'VIP Regular', 18450.00, 24, 3, now() - INTERVAL '2 hours', 'UPI / Instant', 420),
        (c2, demo_store_id, 'Priya Patel', 'PP', '+91 97123 44556', 'Weekly', 9600.00, 12, 6, now() - INTERVAL '5 hours', 'UPI / Instant', 180),
        (c3, demo_store_id, 'Amit Singh', 'AS', '+91 98450 99887', 'Regular', 3420.00, 3, 12, now() - INTERVAL '1 day', 'Cash', 45),
        (c4, demo_store_id, 'Neha Gupta', 'NG', '+91 99100 11223', 'Regular', 7890.00, 9, 8, now() - INTERVAL '3 days', 'UPI / Instant', 110),
        (c5, demo_store_id, 'Vikram Reddy', 'VR', '+91 96541 77889', 'Regular', 6200.00, 8, 10, now() - INTERVAL '4 days', 'Cash', 90)
    ON CONFLICT (id) DO NOTHING;

    -- 4. Insert orders
    INSERT INTO public.orders (id, store_id, order_number, customer_id, customer_name, customer_initials, items_summary, item_count, total_amount, net_profit, payment_method, status, created_at)
    VALUES
        (o1, demo_store_id, '#1024', c1, 'Rahul Sharma', 'RS', 'Amul Milk 1L (2), Coca-Cola 750ml (1)', 3, 189.00, 29.00, 'UPI Paid', 'Completed', now() - INTERVAL '15 minutes'),
        (o2, demo_store_id, '#1023', c2, 'Priya Patel', 'PP', 'Aashirvaad Atta 5kg (1), Tata Salt 1kg (1)', 2, 273.00, 31.50, 'GPay / UPI', 'Completed', now() - INTERVAL '1 hour'),
        (o3, demo_store_id, '#1022', c3, 'Amit Singh', 'AS', 'Fortune Sunflower Oil 1L (1)', 1, 145.00, 17.00, 'Counter Cash', 'Completed', now() - INTERVAL '3 hours')
    ON CONFLICT (id) DO NOTHING;

    -- 5. Insert order items
    INSERT INTO public.order_items (order_id, product_id, product_name, qty, unit_price, subtotal)
    VALUES
        (o1, p1, 'Amul Taaza Homogenised Toned Milk 1L', 2, 72.00, 144.00),
        (o1, p2, 'Coca-Cola Original Taste 750ml', 1, 45.00, 45.00),
        (o2, p5, 'Aashirvaad Shudh Chakki Atta 5kg', 1, 245.00, 245.00),
        (o2, p4, 'Tata Salt Vacuum Evaporated 1kg', 1, 28.00, 28.00),
        (o3, p6, 'Fortune Sunlite Refined Sunflower Oil 1L', 1, 145.00, 145.00)
    ON CONFLICT (id) DO NOTHING;

    -- 6. Insert notifications
    INSERT INTO public.notifications (store_id, type, title, body, action_label, action_route, is_read, created_at)
    VALUES
        (demo_store_id, 'LOW STOCK', 'Critical Stock Warning', 'Fortune Sunflower Oil 1L is completely out of stock. 2 more items below threshold.', 'Restock Now', '/inventory', false, now() - INTERVAL '20 minutes'),
        (demo_store_id, 'AI INSIGHT', 'Sales Spike Detected', 'Evening beverage sales are 22% higher than last Tuesday. Check Coca-Cola stock.', 'View Insight', '/sales', false, now() - INTERVAL '1 hour'),
        (demo_store_id, 'CUSTOMER', 'VIP Regular Visit Expected', 'Rahul Sharma usually orders grocery staples on Wednesday evening.', 'View Profile', '/customers', true, now() - INTERVAL '3 hours')
    ON CONFLICT (id) DO NOTHING;

    -- 7. Insert AI brief
    INSERT INTO public.ai_briefs_and_health (
        store_id, date, health_score, sales_score, inventory_score, customers_score, profit_score, morning_summary, peak_hours
    ) VALUES (
        demo_store_id, CURRENT_DATE, 82, 88, 78, 84, 82,
        'Revenue is pacing +12.3% above weekly average. Morning footfall was high in Dairy & Beverages. Reorder Fortune Sunflower Oil and Atta before peak evening window.',
        '11:00 AM - 02:00 PM and 06:30 PM - 09:30 PM'
    ) ON CONFLICT (id) DO NOTHING;
END;
$$;
