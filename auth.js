// auth.js — importado por todas as páginas
import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm';

export const SUPABASE_URL = 'https://bszolfkwpqidoqzlzjci.supabase.co';
export const SUPABASE_KEY = 'sb_publishable_72Os9pLeArI0ll83eZLPCw_0ttl9QNc';
export const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

// Verifica sessão — redireciona para login se não autenticado
export async function requireAuth() {
  const { data: { session } } = await supabase.auth.getSession();
  if (!session) {
    window.location.href = 'login.html';
    return null;
  }
  return session;
}

// Retorna token do usuário logado
export async function getToken() {
  const { data: { session } } = await supabase.auth.getSession();
  return session?.access_token || null;
}

// Fetch autenticado para a API REST do Supabase
export async function sbFetch(path, method = 'GET', body = null) {
  const token = await getToken();
  if (!token) { window.location.href = 'login.html'; return null; }

  const opts = {
    method,
    headers: {
      'apikey': SUPABASE_KEY,
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json',
      'Prefer': 'return=minimal'
    }
  };
  if (body) opts.body = JSON.stringify(body);

  const res = await fetch(`${SUPABASE_URL}/rest/v1/${path}`, opts);
  if (res.status === 401) { window.location.href = 'login.html'; return null; }
  if (method === 'GET') return res.json();
  if (!res.ok) throw new Error(await res.text());
  return true;
}

// Logout
export async function logout() {
  await supabase.auth.signOut();
  window.location.href = 'login.html';
}
