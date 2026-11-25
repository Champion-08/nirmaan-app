-- ==============================================================================
-- NIRMAAN: AI-Powered Business Operating System for Local Businesses
-- Migration: 20260101000000_init_nirmaan.sql
-- ==============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. STORES
CREATE TABLE IF NOT EXISTS public.stores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    business_name TEXT NOT NULL DEFAULT 'Shree Krishna General Store',
    category TEXT NOT NULL DEFAULT 'Grocery & Daily Essentials',
    owner_name TEXT NOT NULL DEFAULT 'Rahul Sharma',
    phone TEXT NOT NULL DEFAULT '+91 98765 43210',
    email TEXT,
    gst_registered BOOLEAN NOT NULL DEFAULT true,
    currency TEXT NOT NULL DEFAULT 'INR',
    business_hours TEXT NOT NULL DEFAULT '08:00 AM - 10:00 PM',
    kyc_verified BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. PRODUCTS
CREATE TABLE IF NOT EXISTS public.products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    sku TEXT,
    barcode TEXT,
    category TEXT NOT NULL CHECK (category IN ('Dairy', 'Snacks', 'Beverages', 'Grocery', 'Personal Care', 'Staples', 'Other')),
    selling_price NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    purchase_price NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    unit TEXT NOT NULL DEFAULT 'unit' CHECK (unit IN ('unit', 'bottle', 'pack', 'bag', 'kg', 'litre')),
    stock_qty INT NOT NULL DEFAULT 0,
    low_stock_threshold INT NOT NULL DEFAULT 5,
    image_url TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 3. CUSTOMERS
CREATE TABLE IF NOT EXISTS public.customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    initials TEXT NOT NULL,
    phone TEXT NOT NULL,
    segment TEXT NOT NULL DEFAULT 'Regular' CHECK (segment IN ('VIP Regular', 'Weekly', 'Regular', 'Inactive')),
    total_spent NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    order_count INT NOT NULL DEFAULT 0,
    avg_cycle_days INT NOT NULL DEFAULT 7,
    last_purchase_at TIMESTAMPTZ,
    preferred_payment TEXT NOT NULL DEFAULT 'UPI / Instant' CHECK (preferred_payment IN ('UPI / Instant', 'Cash', 'Card')),
    loyalty_points INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 4. ORDERS
CREATE TABLE IF NOT EXISTS public.orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    order_number TEXT NOT NULL,
    customer_id UUID REFERENCES public.customers(id) ON DELETE SET NULL,
    customer_name TEXT NOT NULL,
    customer_initials TEXT NOT NULL,
    items_summary TEXT NOT NULL DEFAULT '',
    item_count INT NOT NULL DEFAULT 1,
    total_amount NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    net_profit NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    payment_method TEXT NOT NULL DEFAULT 'UPI Paid' CHECK (payment_method IN ('UPI Paid', 'Cash on Delivery', 'GPay / UPI', 'Counter Cash')),
    status TEXT NOT NULL DEFAULT 'Completed' CHECK (status IN ('Completed', 'Pending')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 5. ORDER ITEMS
CREATE TABLE IF NOT EXISTS public.order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
    product_id UUID REFERENCES public.products(id) ON DELETE SET NULL,
    product_name TEXT NOT NULL,
    qty INT NOT NULL DEFAULT 1,
    unit_price NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    subtotal NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 6. NOTIFICATIONS
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('LOW STOCK', 'AI INSIGHT', 'CUSTOMER', 'SALES', 'INVENTORY')),
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    action_label TEXT,
    action_route TEXT,
    is_read BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 7. AI BRIEFS & BUSINESS HEALTH
CREATE TABLE IF NOT EXISTS public.ai_briefs_and_health (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    health_score INT NOT NULL DEFAULT 82,
    sales_score INT NOT NULL DEFAULT 88,
    inventory_score INT NOT NULL DEFAULT 78,
    customers_score INT NOT NULL DEFAULT 84,
    profit_score INT NOT NULL DEFAULT 82,
    morning_summary TEXT NOT NULL,
    peak_hours TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 8. USER SETTINGS
CREATE TABLE IF NOT EXISTS public.user_settings (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    theme_mode TEXT NOT NULL DEFAULT 'system',
    language TEXT NOT NULL DEFAULT 'English',
    business_alerts BOOLEAN NOT NULL DEFAULT true,
    daily_brief BOOLEAN NOT NULL DEFAULT true,
    low_stock_alerts BOOLEAN NOT NULL DEFAULT true,
    customer_alerts BOOLEAN NOT NULL DEFAULT true,
    ai_recommendations BOOLEAN NOT NULL DEFAULT true,
    marketing_updates BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ==============================================================================
-- INDEXES FOR PERFORMANCE
-- ==============================================================================
CREATE INDEX IF NOT EXISTS idx_stores_owner ON public.stores(owner_id);
CREATE INDEX IF NOT EXISTS idx_products_store ON public.products(store_id);
CREATE INDEX IF NOT EXISTS idx_products_barcode ON public.products(barcode);
CREATE INDEX IF NOT EXISTS idx_customers_store ON public.customers(store_id);
CREATE INDEX IF NOT EXISTS idx_orders_store ON public.orders(store_id);
CREATE INDEX IF NOT EXISTS idx_orders_customer ON public.orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON public.order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_notifications_store ON public.notifications(store_id);
CREATE INDEX IF NOT EXISTS idx_ai_briefs_store_date ON public.ai_briefs_and_health(store_id, date);

-- ==============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==============================================================================
ALTER TABLE public.stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_briefs_and_health ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_settings ENABLE ROW LEVEL SECURITY;

-- Helper function to check store ownership
CREATE OR REPLACE FUNCTION public.is_store_owner(lookup_store_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.stores
    WHERE id = lookup_store_id
      AND owner_id = auth.uid()
  );
$$;

-- STORES policies
CREATE POLICY "Stores can be viewed by owner"
    ON public.stores FOR SELECT
    USING (owner_id = auth.uid());

CREATE POLICY "Stores can be updated by owner"
    ON public.stores FOR UPDATE
    USING (owner_id = auth.uid());

CREATE POLICY "Stores can be inserted by owner"
    ON public.stores FOR INSERT
    WITH CHECK (owner_id = auth.uid());

CREATE POLICY "Stores can be deleted by owner"
    ON public.stores FOR DELETE
    USING (owner_id = auth.uid());

-- PRODUCTS policies
CREATE POLICY "Products viewable by store owner"
    ON public.products FOR SELECT
    USING (public.is_store_owner(store_id));

CREATE POLICY "Products insertable by store owner"
    ON public.products FOR INSERT
    WITH CHECK (public.is_store_owner(store_id));

CREATE POLICY "Products updatable by store owner"
    ON public.products FOR UPDATE
    USING (public.is_store_owner(store_id));

CREATE POLICY "Products deletable by store owner"
    ON public.products FOR DELETE
    USING (public.is_store_owner(store_id));

-- CUSTOMERS policies
CREATE POLICY "Customers viewable by store owner"
    ON public.customers FOR SELECT
    USING (public.is_store_owner(store_id));

CREATE POLICY "Customers insertable by store owner"
    ON public.customers FOR INSERT
    WITH CHECK (public.is_store_owner(store_id));

CREATE POLICY "Customers updatable by store owner"
    ON public.customers FOR UPDATE
    USING (public.is_store_owner(store_id));

CREATE POLICY "Customers deletable by store owner"
    ON public.customers FOR DELETE
    USING (public.is_store_owner(store_id));

-- ORDERS policies
CREATE POLICY "Orders viewable by store owner"
    ON public.orders FOR SELECT
    USING (public.is_store_owner(store_id));

CREATE POLICY "Orders insertable by store owner"
    ON public.orders FOR INSERT
    WITH CHECK (public.is_store_owner(store_id));

CREATE POLICY "Orders updatable by store owner"
    ON public.orders FOR UPDATE
    USING (public.is_store_owner(store_id));

CREATE POLICY "Orders deletable by store owner"
    ON public.orders FOR DELETE
    USING (public.is_store_owner(store_id));

-- ORDER ITEMS policies
CREATE POLICY "Order items viewable by store owner"
    ON public.order_items FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.orders o
            WHERE o.id = order_items.order_id
              AND public.is_store_owner(o.store_id)
        )
    );

CREATE POLICY "Order items insertable by store owner"
    ON public.order_items FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.orders o
            WHERE o.id = order_items.order_id
              AND public.is_store_owner(o.store_id)
        )
    );

CREATE POLICY "Order items updatable by store owner"
    ON public.order_items FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM public.orders o
            WHERE o.id = order_items.order_id
              AND public.is_store_owner(o.store_id)
        )
    );

CREATE POLICY "Order items deletable by store owner"
    ON public.order_items FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM public.orders o
            WHERE o.id = order_items.order_id
              AND public.is_store_owner(o.store_id)
        )
    );

-- NOTIFICATIONS policies
CREATE POLICY "Notifications viewable by store owner"
    ON public.notifications FOR SELECT
    USING (public.is_store_owner(store_id));

CREATE POLICY "Notifications updatable by store owner"
    ON public.notifications FOR UPDATE
    USING (public.is_store_owner(store_id));

CREATE POLICY "Notifications deletable by store owner"
    ON public.notifications FOR DELETE
    USING (public.is_store_owner(store_id));

-- AI BRIEFS policies
CREATE POLICY "AI briefs viewable by store owner"
    ON public.ai_briefs_and_health FOR SELECT
    USING (public.is_store_owner(store_id));

-- USER SETTINGS policies
CREATE POLICY "User settings viewable by user"
    ON public.user_settings FOR SELECT
    USING (user_id = auth.uid());

CREATE POLICY "User settings updatable by user"
    ON public.user_settings FOR UPDATE
    USING (user_id = auth.uid());

CREATE POLICY "User settings insertable by user"
    ON public.user_settings FOR INSERT
    WITH CHECK (user_id = auth.uid());

-- ==============================================================================
-- AUTOMATIC NEW USER SETUP TRIGGER (Store + Demo Catalog & Seed Data)
-- ==============================================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    new_store_id UUID;
    prod_amul UUID;
    prod_coke UUID;
    prod_parle UUID;
    prod_salt UUID;
    prod_atta UUID;
    prod_oil UUID;
    cust_rahul UUID;
    cust_priya UUID;
    cust_amit UUID;
    cust_neha UUID;
    cust_vikram UUID;
    ord_1 UUID;
    ord_2 UUID;
    ord_3 UUID;
BEGIN
    -- 1. Create Default Store for the Merchant
    INSERT INTO public.stores (
        owner_id,
        business_name,
        category,
        owner_name,
        phone,
        email,
        gst_registered,
        currency,
        business_hours,
        kyc_verified
    ) VALUES (
        NEW.id,
        'Shree Krishna General Store',
        'Grocery & Daily Essentials',
        COALESCE(NEW.raw_user_meta_data->>'full_name', 'Rahul Sharma'),
        COALESCE(NEW.phone, '+91 98765 43210'),
        NEW.email,
        true,
        'INR',
        '08:00 AM - 10:00 PM',
        true
    ) RETURNING id INTO new_store_id;

    -- 2. Create Default User Settings
    INSERT INTO public.user_settings (
        user_id,
        theme_mode,
        language,
        business_alerts,
        daily_brief,
        low_stock_alerts,
        customer_alerts,
        ai_recommendations,
        marketing_updates
    ) VALUES (
        NEW.id,
        'system',
        'English',
        true,
        true,
        true,
        true,
        true,
        false
    );

    -- 3. Seed Demo Catalog Products matching Figma prototype
    INSERT INTO public.products (store_id, name, sku, barcode, category, selling_price, purchase_price, unit, stock_qty, low_stock_threshold)
    VALUES (new_store_id, 'Amul Taaza Homogenised Toned Milk 1L', 'DAIRY-AMUL-1L', '8901262010053', 'Dairy', 72.00, 64.00, 'pack', 28, 5)
    RETURNING id INTO prod_amul;

    INSERT INTO public.products (store_id, name, sku, barcode, category, selling_price, purchase_price, unit, stock_qty, low_stock_threshold)
    VALUES (new_store_id, 'Coca-Cola Original Taste 750ml', 'BEV-COKE-750', '8901764012231', 'Beverages', 45.00, 38.00, 'bottle', 18, 5)
    RETURNING id INTO prod_coke;

    INSERT INTO public.products (store_id, name, sku, barcode, category, selling_price, purchase_price, unit, stock_qty, low_stock_threshold)
    VALUES (new_store_id, 'Parle-G Gold Biscuits 1kg', 'SNK-PARLE-1K', '8901719101034', 'Snacks', 120.00, 102.00, 'pack', 4, 5)
    RETURNING id INTO prod_parle;

    INSERT INTO public.products (store_id, name, sku, barcode, category, selling_price, purchase_price, unit, stock_qty, low_stock_threshold)
    VALUES (new_store_id, 'Tata Salt Vacuum Evaporated 1kg', 'GROC-SALT-1K', '8904043901005', 'Staples', 28.00, 23.50, 'pack', 65, 10)
    RETURNING id INTO prod_salt;

    INSERT INTO public.products (store_id, name, sku, barcode, category, selling_price, purchase_price, unit, stock_qty, low_stock_threshold)
    VALUES (new_store_id, 'Aashirvaad Shudh Chakki Atta 5kg', 'STP-AASH-5K', '8901030383794', 'Staples', 245.00, 218.00, 'bag', 3, 5)
    RETURNING id INTO prod_atta;

    INSERT INTO public.products (store_id, name, sku, barcode, category, selling_price, purchase_price, unit, stock_qty, low_stock_threshold)
    VALUES (new_store_id, 'Fortune Sunlite Refined Sunflower Oil 1L', 'OIL-FORT-1L', '8906007280237', 'Grocery', 145.00, 128.00, 'bottle', 0, 5)
    RETURNING id INTO prod_oil;

    -- 4. Seed Demo Customers matching Figma prototype
    INSERT INTO public.customers (store_id, name, initials, phone, segment, total_spent, order_count, avg_cycle_days, last_purchase_at, preferred_payment, loyalty_points)
    VALUES (new_store_id, 'Rahul Sharma', 'RS', '+91 98201 22341', 'VIP Regular', 18450.00, 24, 3, now() - INTERVAL '2 hours', 'UPI / Instant', 420)
    RETURNING id INTO cust_rahul;

    INSERT INTO public.customers (store_id, name, initials, phone, segment, total_spent, order_count, avg_cycle_days, last_purchase_at, preferred_payment, loyalty_points)
    VALUES (new_store_id, 'Priya Patel', 'PP', '+91 97123 44556', 'Weekly', 9600.00, 12, 6, now() - INTERVAL '5 hours', 'UPI / Instant', 180)
    RETURNING id INTO cust_priya;

    INSERT INTO public.customers (store_id, name, initials, phone, segment, total_spent, order_count, avg_cycle_days, last_purchase_at, preferred_payment, loyalty_points)
    VALUES (new_store_id, 'Amit Singh', 'AS', '+91 98450 99887', 'Regular', 3420.00, 3, 12, now() - INTERVAL '1 day', 'Cash', 45)
    RETURNING id INTO cust_amit;

    INSERT INTO public.customers (store_id, name, initials, phone, segment, total_spent, order_count, avg_cycle_days, last_purchase_at, preferred_payment, loyalty_points)
    VALUES (new_store_id, 'Neha Gupta', 'NG', '+91 99100 11223', 'Regular', 7890.00, 9, 8, now() - INTERVAL '3 days', 'UPI / Instant', 110)
    RETURNING id INTO cust_neha;

    INSERT INTO public.customers (store_id, name, initials, phone, segment, total_spent, order_count, avg_cycle_days, last_purchase_at, preferred_payment, loyalty_points)
    VALUES (new_store_id, 'Vikram Reddy', 'VR', '+91 96541 77889', 'Regular', 6200.00, 8, 10, now() - INTERVAL '4 days', 'Cash', 90)
    RETURNING id INTO cust_vikram;

    -- 5. Seed Sample Orders matching Figma prototype
    INSERT INTO public.orders (store_id, order_number, customer_id, customer_name, customer_initials, items_summary, item_count, total_amount, net_profit, payment_method, status, created_at)
    VALUES (new_store_id, '#1024', cust_rahul, 'Rahul Sharma', 'RS', 'Amul Milk 1L (2), Coca-Cola 750ml (1)', 3, 189.00, 29.00, 'UPI Paid', 'Completed', now() - INTERVAL '15 minutes')
    RETURNING id INTO ord_1;

    INSERT INTO public.orders (store_id, order_number, customer_id, customer_name, customer_initials, items_summary, item_count, total_amount, net_profit, payment_method, status, created_at)
    VALUES (new_store_id, '#1023', cust_priya, 'Priya Patel', 'PP', 'Aashirvaad Atta 5kg (1), Tata Salt 1kg (1)', 2, 273.00, 31.50, 'GPay / UPI', 'Completed', now() - INTERVAL '1 hour')
    RETURNING id INTO ord_2;

    INSERT INTO public.orders (store_id, order_number, customer_id, customer_name, customer_initials, items_summary, item_count, total_amount, net_profit, payment_method, status, created_at)
    VALUES (new_store_id, '#1022', cust_amit, 'Amit Singh', 'AS', 'Fortune Sunflower Oil 1L (1)', 1, 145.00, 17.00, 'Counter Cash', 'Completed', now() - INTERVAL '3 hours')
    RETURNING id INTO ord_3;

    -- 6. Seed Order Items
    INSERT INTO public.order_items (order_id, product_id, product_name, qty, unit_price, subtotal)
    VALUES
        (ord_1, prod_amul, 'Amul Taaza Homogenised Toned Milk 1L', 2, 72.00, 144.00),
        (ord_1, prod_coke, 'Coca-Cola Original Taste 750ml', 1, 45.00, 45.00),
        (ord_2, prod_atta, 'Aashirvaad Shudh Chakki Atta 5kg', 1, 245.00, 245.00),
        (ord_2, prod_salt, 'Tata Salt Vacuum Evaporated 1kg', 1, 28.00, 28.00),
        (ord_3, prod_oil, 'Fortune Sunlite Refined Sunflower Oil 1L', 1, 145.00, 145.00);

    -- 7. Seed Notifications
    INSERT INTO public.notifications (store_id, type, title, body, action_label, action_route, is_read, created_at)
    VALUES
        (new_store_id, 'LOW STOCK', 'Critical Stock Warning', 'Fortune Sunflower Oil 1L is completely out of stock. 2 more items below threshold.', 'Restock Now', '/inventory', false, now() - INTERVAL '20 minutes'),
        (new_store_id, 'AI INSIGHT', 'Sales Spike Detected', 'Evening beverage sales are 22% higher than last Tuesday. Check Coca-Cola stock.', 'View Insight', '/sales', false, now() - INTERVAL '1 hour'),
        (new_store_id, 'CUSTOMER', 'VIP Regular Visit Expected', 'Rahul Sharma usually orders grocery staples on Wednesday evening.', 'View Profile', '/customers', true, now() - INTERVAL '3 hours');

    -- 8. Seed AI Briefs and Health Metric
    INSERT INTO public.ai_briefs_and_health (
        store_id,
        date,
        health_score,
        sales_score,
        inventory_score,
        customers_score,
        profit_score,
        morning_summary,
        peak_hours
    ) VALUES (
        new_store_id,
        CURRENT_DATE,
        82,
        88,
        78,
        84,
        82,
        'Revenue is pacing +12.3% above weekly average. Morning footfall was high in Dairy & Beverages. Reorder Fortune Sunflower Oil and Atta before peak evening window.',
        '11:00 AM - 02:00 PM and 06:30 PM - 09:30 PM'
    );

    RETURN NEW;
END;
$$;

-- Trigger on auth.users sign-up
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- ==============================================================================
-- SUPABASE REALTIME ENABLEMENT
-- ==============================================================================
DO $$
BEGIN
    -- Add tables to realtime publication if not already present
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables
        WHERE pubname = 'supabase_realtime' AND tablename = 'products'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.products;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables
        WHERE pubname = 'supabase_realtime' AND tablename = 'orders'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.orders;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables
        WHERE pubname = 'supabase_realtime' AND tablename = 'customers'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.customers;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables
        WHERE pubname = 'supabase_realtime' AND tablename = 'notifications'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;
    END IF;
END;
$$;
