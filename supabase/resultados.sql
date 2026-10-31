-- Página de resultados (resultados.html), aberta sem login: entrega o conteúdo das respostas sem dizer de quem é.
-- Não sai user_id, nome nem e-mail; "pessoa" é só um número (1, 2, 3…) para contar quantas pessoas responderam.
-- As tabelas continuam fechadas: quem não está logado só consegue chamar esta função.
-- Atenção: comentários e links de portfólio ficam visíveis para qualquer pessoa com o endereço da página.
create or replace function public.resultados()
  returns table (pessoa bigint, atividade text, resposta jsonb)
  language sql stable security definer set search_path = ''
  as $$
    select dense_rank() over (order by r.user_id), r.atividade, r.resposta
      from public.respostas r
     order by 1, 2
  $$;

revoke all on function public.resultados() from public;
grant execute on function public.resultados() to anon, authenticated;
