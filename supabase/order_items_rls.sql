-- ============================================================
-- order_items 表 RLS 策略
-- 在 Supabase SQL Editor 中运行此脚本
-- ============================================================

-- 启用行级安全
alter table public.order_items enable row level security;

-- 授予 anon 和 authenticated 角色的基础权限
revoke all on table public.order_items from anon, authenticated;
grant select, insert, update, delete on table public.order_items to anon, authenticated;
grant select, insert, update, delete on table public.order_items to service_role;
grant usage, select on sequence public.order_items_id_seq to anon, authenticated, service_role;

-- 策略1: 任何人都可以查看 order_items
drop policy if exists "Anyone can view order_items" on public.order_items;
create policy "Anyone can view order_items"
on public.order_items
for select
to anon, authenticated
using (true);

-- 策略2: 访客可以创建订单项
drop policy if exists "Guests can place order_items" on public.order_items;
create policy "Guests can place order_items"
on public.order_items
for insert
to anon, authenticated
with check (
  status = 'new'
  and quantity > 0
  and subtotal_usd >= 0
  and subtotal_khr >= 0
);

-- 策略3: 访客可以更新订单项状态
drop policy if exists "Guests can update order_items status" on public.order_items;
create policy "Guests can update order_items status"
on public.order_items
for update
to anon, authenticated
using (true)
with check (
  status in ('new', 'accepted', 'preparing', 'ready', 'completed', 'cancelled')
);

-- 策略4: 访客可以删除订单项
drop policy if exists "Guests can delete order_items" on public.order_items;
create policy "Guests can delete order_items"
on public.order_items
for delete
to anon, authenticated
using (true);
