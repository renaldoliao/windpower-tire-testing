-- Windpower Books: database setup
-- Paste all of this into Supabase > SQL Editor > New query, then press Run.
-- BEFORE running: change the email and name on the last line to the owner's.

-- 1. Who may use the book
create table if not exists public.members (
  email text primary key,
  name text,
  role text not null default 'staff' check (role in ('owner','staff')),
  added_at timestamptz not null default now()
);

create or replace function public.is_member() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.members where email = lower(auth.jwt() ->> 'email'));
$$;

create or replace function public.is_owner() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.members where email = lower(auth.jwt() ->> 'email') and role = 'owner');
$$;

-- 2. The records
create table if not exists public.entries  (id text primary key, d date not null, data jsonb not null, created_by uuid default auth.uid(), updated_at timestamptz not null default now());
create table if not exists public.products (id text primary key, data jsonb not null, updated_at timestamptz not null default now());
create table if not exists public.contacts (id text primary key, data jsonb not null, updated_at timestamptz not null default now());
create table if not exists public.settings (id text primary key, data jsonb not null, updated_at timestamptz not null default now());

-- 3. Only members can read or change anything
alter table public.members  enable row level security;
alter table public.entries  enable row level security;
alter table public.products enable row level security;
alter table public.contacts enable row level security;
alter table public.settings enable row level security;

do $$
declare t text;
begin
  foreach t in array array['entries','products','contacts','settings'] loop
    execute format('drop policy if exists "members read" on public.%I', t);
    execute format('drop policy if exists "members write" on public.%I', t);
    execute format('create policy "members read" on public.%I for select to authenticated using (public.is_member())', t);
    execute format('create policy "members write" on public.%I for all to authenticated using (public.is_member()) with check (public.is_member())', t);
  end loop;
end $$;

drop policy if exists "see own row or all if member" on public.members;
drop policy if exists "owners manage" on public.members;
create policy "see own row or all if member" on public.members for select to authenticated
  using (email = lower(auth.jwt() ->> 'email') or public.is_member());
create policy "owners manage" on public.members for all to authenticated
  using (public.is_owner()) with check (public.is_owner());

-- 4. Live updates between phones
do $$
declare t text;
begin
  foreach t in array array['entries','products','contacts','settings'] loop
    begin
      execute format('alter publication supabase_realtime add table public.%I', t);
    exception when duplicate_object then null;
    end;
  end loop;
end $$;

-- 5. Tire photos
insert into storage.buckets (id, name, public) values ('tire-photos', 'tire-photos', true)
on conflict (id) do nothing;
drop policy if exists "members upload photos" on storage.objects;
drop policy if exists "members delete photos" on storage.objects;
create policy "members upload photos" on storage.objects for insert to authenticated
  with check (bucket_id = 'tire-photos' and public.is_member());
create policy "members delete photos" on storage.objects for delete to authenticated
  using (bucket_id = 'tire-photos' and public.is_member());

-- 6. Starting data: the two Windpower tires
insert into public.products (id, data) values
  ('p-wgc29', '{"brand":"Windpower","size":"7.50-16","pattern":"WGC29","cat":"Truck","price":2050000,"low":0}'),
  ('p-wsr81', '{"brand":"Windpower","size":"7.50-16","pattern":"WSR81","cat":"Truck","price":2050000,"low":0}')
on conflict (id) do nothing;

-- 7. The first owner. CHANGE THIS EMAIL AND NAME before pressing Run.
insert into public.members (email, name, role) values ('owner@example.com', 'Ci Via', 'owner')
on conflict (email) do update set role = 'owner';
