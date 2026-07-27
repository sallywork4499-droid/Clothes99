-- ═══════════════════════════════════════════════════════════
--  Clothes 99 — bảng "outfits" (tính năng Mix đồ)
--  Bảng HOÀN TOÀN TÁCH BIỆT với app_data hiện có.
--  Chạy trong Supabase Dashboard > SQL Editor > Run.
--  An toàn để chạy nhiều lần (dùng IF NOT EXISTS).
-- ═══════════════════════════════════════════════════════════

create table if not exists public.outfits (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  slots jsonb not null default '{}'::jsonb,   -- {top:[id,id,id], bottom:id, bag:id, shoes:id, accessories:[id,id]}
  use_count integer not null default 0,
  last_used_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists outfits_user_id_idx on public.outfits(user_id);

alter table public.outfits enable row level security;

drop policy if exists "outfits_select_own" on public.outfits;
create policy "outfits_select_own" on public.outfits
  for select using (auth.uid() = user_id);

drop policy if exists "outfits_insert_own" on public.outfits;
create policy "outfits_insert_own" on public.outfits
  for insert with check (auth.uid() = user_id);

drop policy if exists "outfits_update_own" on public.outfits;
create policy "outfits_update_own" on public.outfits
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "outfits_delete_own" on public.outfits;
create policy "outfits_delete_own" on public.outfits
  for delete using (auth.uid() = user_id);
