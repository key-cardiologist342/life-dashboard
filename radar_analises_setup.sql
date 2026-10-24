-- Configuração única da tabela que guarda as interpretações assistidas do Radar.
-- Execute no Supabase SQL Editor do projeto bszolfkwpqidoqzlzjci.

create table if not exists public.radar_analises (
  id uuid primary key default gen_random_uuid(),
  gerado_em timestamptz not null default now(),
  data_inicio date not null,
  data_fim date not null,
  texto text not null,
  resumo text,
  sinais_observados text,
  limitacoes text,
  acoes text,
  constraint radar_analises_periodo_valido check (data_fim >= data_inicio)
);

-- Mantém compatibilidade com tabelas já criadas antes da saída estruturada.
alter table public.radar_analises
  add column if not exists resumo text,
  add column if not exists sinais_observados text,
  add column if not exists limitacoes text,
  add column if not exists acoes text;

alter table public.radar_analises enable row level security;

-- A tabela é consultada pela dashboard com a sessão autenticada.
-- Grants explícitos: novos objetos podem não receber acesso automático pela Data API.
grant select, insert on table public.radar_analises to authenticated;

drop policy if exists "authenticated can read radar analyses" on public.radar_analises;
create policy "authenticated can read radar analyses"
on public.radar_analises
for select
to authenticated
using (true);

drop policy if exists "authenticated can insert radar analyses" on public.radar_analises;
create policy "authenticated can insert radar analyses"
on public.radar_analises
for insert
to authenticated
with check (true);

notify pgrst, 'reload schema';
