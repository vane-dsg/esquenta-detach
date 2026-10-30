-- Trilha de cada pessoa logada com o Google (uma linha por usuário).
-- O site lê e grava só a própria linha: o RLS compara user_id com o usuário da sessão.
create table if not exists public.trilhas (
  user_id    uuid primary key references auth.users (id) on delete cascade,
  nome       text,
  email      text,
  estado     jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.trilhas enable row level security;

drop policy if exists "ler a própria trilha" on public.trilhas;
create policy "ler a própria trilha" on public.trilhas
  for select to authenticated using ((select auth.uid()) = user_id);

drop policy if exists "criar a própria trilha" on public.trilhas;
create policy "criar a própria trilha" on public.trilhas
  for insert to authenticated with check ((select auth.uid()) = user_id);

drop policy if exists "atualizar a própria trilha" on public.trilhas;
create policy "atualizar a própria trilha" on public.trilhas
  for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

revoke all on public.trilhas from anon;
grant select, insert, update on public.trilhas to authenticated;
