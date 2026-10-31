-- Respostas das atividades: uma linha por pessoa + atividade, gravada quando a atividade é concluída.
-- "resposta" guarda o que a pessoa marcou, no mesmo formato do site (ex.: {"v": "Gostosura"}, {"answers": {...}}, {"score": 5, "text": "..."}).
create table if not exists public.respostas (
  user_id    uuid not null references auth.users (id) on delete cascade,
  atividade  text not null,
  titulo     text,
  tipo       text,
  resposta   jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (user_id, atividade)
);

alter table public.respostas enable row level security;

drop policy if exists "ler as próprias respostas" on public.respostas;
create policy "ler as próprias respostas" on public.respostas
  for select to authenticated using ((select auth.uid()) = user_id);

drop policy if exists "criar as próprias respostas" on public.respostas;
create policy "criar as próprias respostas" on public.respostas
  for insert to authenticated with check ((select auth.uid()) = user_id);

drop policy if exists "atualizar as próprias respostas" on public.respostas;
create policy "atualizar as próprias respostas" on public.respostas
  for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

revoke all on public.respostas from anon;
grant select, insert, update on public.respostas to authenticated;

-- Para ver tudo no SQL Editor (lá o RLS não se aplica), com nome e e-mail:
-- select t.nome, t.email, r.titulo, r.resposta, r.updated_at
--   from public.respostas r left join public.trilhas t using (user_id)
--   order by r.atividade, r.updated_at;
