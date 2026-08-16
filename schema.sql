-- Daily Budget Calculator schema
-- Run this once in the Supabase SQL editor (Dashboard -> SQL Editor -> New query -> paste -> Run).

create table settings (
  id int primary key default 1 check (id = 1),
  start_date date not null,
  total_days int not null,
  total_budget_krw bigint not null,
  exchange_rate numeric not null default 1415,
  floor_krw int not null default 15000,
  onetime_balance_krw bigint not null default 0
);

create table expenses (
  id uuid primary key default gen_random_uuid(),
  day date not null,
  amount_krw bigint not null,
  kind text not null default 'daily' check (kind in ('daily','onetime')),
  created_at timestamptz not null default now()
);

create table budget_events (
  id uuid primary key default gen_random_uuid(),
  day date not null,
  amount_krw bigint not null,   -- positive: payment received, negative: allocation to one-time pool
  added_days int not null default 0,
  note text
);

-- Open access (no auth) — deliberate choice: single user, unshared URL.
alter table settings disable row level security;
alter table expenses disable row level security;
alter table budget_events disable row level security;

-- Initial state: Aug 16, 45 days, $1,305 x 1,415 = 1,846,575 KRW
insert into settings (id, start_date, total_days, total_budget_krw, exchange_rate)
values (1, '2026-08-16', 45, 1846575, 1415);
