-- Cultura & lazer: metadata editorial e sessões independentes de leitura
alter table public.vida_itens
  add column if not exists ano integer,
  add column if not exists duracao_oficial_min integer,
  add column if not exists total_paginas integer,
  add column if not exists formato text,
  add column if not exists status text;

alter table public.vida_itens
  drop constraint if exists vida_itens_ano_check,
  drop constraint if exists vida_itens_duracao_oficial_check,
  drop constraint if exists vida_itens_total_paginas_check,
  drop constraint if exists vida_itens_status_check;

alter table public.vida_itens
  add constraint vida_itens_ano_check
    check (ano is null or ano between 1800 and 2200),
  add constraint vida_itens_duracao_oficial_check
    check (duracao_oficial_min is null or duracao_oficial_min > 0),
  add constraint vida_itens_total_paginas_check
    check (total_paginas is null or total_paginas > 0),
  add constraint vida_itens_status_check
    check (status is null or status in ('quero_ver','em_andamento','concluido','pausado'));

alter table public.vida_registros
  drop constraint if exists vida_registros_tipo_evento_check;

alter table public.vida_registros
  add constraint vida_registros_tipo_evento_check
    check (tipo_evento = any (array['assistido','episodio','progresso_leitura','sessao_leitura','sessao_hobbie']::text[]));
