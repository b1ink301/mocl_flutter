/// 관리 화면 한 장(HTML · CSS · JS 를 모두 안에 둔다, 외부 요청 없음).
///
/// 비밀은 담지 않는다. 토큰은 사용자가 입력하고(또는 `/admin#token=...`),
/// 브라우저(localStorage 또는 sessionStorage)에만 두고 API 요청 헤더로만 보낸다.
const String adminPageHtml = r'''<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="robots" content="noindex, nofollow">
<meta name="referrer" content="no-referrer">
<title>Mocl 관리</title>
<style>
:root {
  --bg: #f6f7f9; --card: #fff; --text: #1b1d21; --sub: #6b7280; --line: #e5e7eb;
  --accent: #3b6cf6; --accent-weak: rgba(59,108,246,.1); --danger: #e5484d; --ok: #2f9e6b;
  --warn: #c27c0e; --skel: #e9ebef; --radius: 14px;
}
@media (prefers-color-scheme: dark) {
  :root {
    --bg: #111317; --card: #1a1d23; --text: #e8eaed; --sub: #9aa0aa; --line: #2b2f37;
    --accent: #6d93ff; --accent-weak: rgba(109,147,255,.14); --skel: #2b2f37;
  }
}
* { box-sizing: border-box; }
body {
  margin: 0; background: var(--bg); color: var(--text);
  font: 15px/1.5 -apple-system, BlinkMacSystemFont, "Pretendard", "Apple SD Gothic Neo", "Noto Sans KR", sans-serif;
  padding-bottom: 96px;
}
header {
  position: sticky; top: 0; z-index: 5; background: var(--bg);
  display: flex; align-items: center; gap: 10px; padding: 14px 18px; border-bottom: 1px solid var(--line);
}
header h1 { font-size: 17px; margin: 0; flex: 1; }
main { max-width: 760px; margin: 0 auto; padding: 16px; display: grid; gap: 16px; }
.card { background: var(--card); border: 1px solid var(--line); border-radius: var(--radius); padding: 18px; }
.card h2 { font-size: 16px; margin: 0 0 4px; }
.card > p.desc { color: var(--sub); margin: 0 0 14px; font-size: 13px; }
label.field { display: block; margin: 12px 0 6px; font-weight: 600; font-size: 14px; }
input[type=text], input[type=password], input[type=number], select, textarea {
  width: 100%; padding: 10px 12px; border-radius: 10px; border: 1px solid var(--line);
  background: var(--bg); color: var(--text); font: inherit;
}
textarea { font: 13px/1.5 ui-monospace, SFMono-Regular, Menlo, monospace; min-height: 280px; resize: vertical; }
button {
  font: inherit; border: 0; border-radius: 10px; padding: 10px 14px; cursor: pointer;
  background: var(--accent-weak); color: var(--accent); font-weight: 600;
}
button.primary { background: var(--accent); color: #fff; }
button.ghost { background: transparent; color: var(--sub); }
button.danger { background: transparent; color: var(--danger); }
button:disabled { opacity: .45; cursor: default; }
.row { display: flex; gap: 8px; align-items: center; }
.row > * { min-width: 0; }
.grow { flex: 1; }
.pill { font-size: 12px; padding: 3px 9px; border-radius: 999px; background: var(--accent-weak); color: var(--accent); white-space: nowrap; }
.pill.ok { background: rgba(47,158,107,.12); color: var(--ok); }
.pill.bad { background: rgba(229,72,77,.12); color: var(--danger); }
.muted { color: var(--sub); font-size: 13px; }
.hidden { display: none !important; }

/* 상세 광고 크기 카드 */
.sizes { display: grid; grid-template-columns: repeat(auto-fill, minmax(130px, 1fr)); gap: 10px; }
.size {
  border: 1.5px solid var(--line); border-radius: 12px; padding: 10px; cursor: pointer;
  display: flex; flex-direction: column; gap: 8px; background: var(--card); text-align: left; color: var(--text);
}
.size.on { border-color: var(--accent); background: var(--accent-weak); }
.size b { font-size: 14px; }
.size small { color: var(--sub); font-size: 12px; font-weight: 400; }
.wire { background: var(--bg); border-radius: 8px; padding: 6px; height: 112px; display: flex; flex-direction: column; justify-content: flex-start; gap: 3px; overflow: hidden; }
.wire i { display: block; background: var(--skel); border-radius: 3px; }
.wire .m { background: var(--accent); opacity: .28; }
.wire .h { display: flex; gap: 4px; }

/* 목록 광고 */
.stepper { display: flex; align-items: center; gap: 6px; }
.stepper input { text-align: center; width: 80px; }
.stepper button { width: 40px; padding: 10px 0; }
.preview-list { margin-top: 10px; display: flex; flex-wrap: wrap; gap: 3px; }
.preview-list span { width: 14px; height: 8px; border-radius: 2px; background: var(--skel); }
.preview-list span.ad { background: var(--accent); }

/* UA */
.site-row { display: grid; grid-template-columns: 1.1fr 1fr auto; gap: 6px; margin-bottom: 6px; }
.site-row input { grid-column: 1 / -1; }

/* 이력 */
.hist { display: flex; align-items: center; gap: 8px; padding: 8px 0; border-top: 1px solid var(--line); }
.hist:first-child { border-top: 0; }

/* 문제 · 변경 목록 */
.issues { margin: 10px 0 0; padding: 10px 12px; border-radius: 10px; background: rgba(229,72,77,.08); color: var(--danger); font-size: 13px; }
.issues ul { margin: 0; padding-left: 18px; }
.changes { font: 13px/1.6 ui-monospace, SFMono-Regular, Menlo, monospace; word-break: break-all; }
.changes div { padding: 4px 0; border-top: 1px dashed var(--line); }
.changes del { color: var(--danger); }
.changes ins { color: var(--ok); text-decoration: none; }

/* 아래 저장 막대 */
.savebar {
  position: fixed; left: 0; right: 0; bottom: 0; z-index: 6; background: var(--card);
  border-top: 1px solid var(--line); padding: 12px 16px calc(12px + env(safe-area-inset-bottom));
}
.savebar .inner { max-width: 760px; margin: 0 auto; display: flex; gap: 8px; align-items: center; }

/* 대화 상자 · 알림 */
.backdrop { position: fixed; inset: 0; background: rgba(0,0,0,.45); z-index: 10; display: flex; align-items: flex-end; justify-content: center; }
@media (min-width: 640px) { .backdrop { align-items: center; } }
.dialog { background: var(--card); width: min(640px, 100%); max-height: 85vh; overflow: auto; border-radius: 18px 18px 0 0; padding: 20px; }
@media (min-width: 640px) { .dialog { border-radius: 18px; } }
.dialog h3 { margin: 0 0 12px; }
.dialog pre { white-space: pre-wrap; word-break: break-all; font-size: 12px; background: var(--bg); padding: 12px; border-radius: 10px; }
.toast { position: fixed; left: 50%; bottom: 96px; transform: translateX(-50%); background: #222; color: #fff; padding: 10px 16px; border-radius: 10px; z-index: 20; font-size: 14px; max-width: 90vw; }
</style>
</head>
<body>
<header>
  <h1>Mocl 관리</h1>
  <span id="status" class="pill hidden"></span>
  <button id="logout" class="ghost hidden" type="button">로그아웃</button>
</header>

<main id="login" class="hidden">
  <section class="card">
    <h2>관리자 토큰</h2>
    <p class="desc">서버 <code>.env</code> 의 <code>ADMIN_TOKEN</code> 값을 넣으세요. 토큰은 이 브라우저에만 저장되고 서버 요청 헤더로만 보냅니다.</p>
    <input id="token" type="password" autocomplete="current-password" placeholder="ADMIN_TOKEN">
    <div class="row" style="margin-top:10px">
      <label class="grow muted"><input id="remember" type="checkbox" checked> 이 기기에서 기억하기</label>
      <button id="loginBtn" class="primary" type="button">들어가기</button>
    </div>
    <p id="loginError" class="issues hidden"></p>
  </section>
</main>

<main id="app" class="hidden">
  <section class="card">
    <h2>상세 광고 크기</h2>
    <p class="desc">글 본문과 댓글 사이 광고. 높이는 폰(폭 393dp) 기준. 앱은 <b>다음 실행부터</b> 적용합니다.</p>
    <div id="sizes" class="sizes"></div>
  </section>

  <section class="card">
    <h2>목록 광고 위치</h2>
    <p class="desc">첫 광고를 몇 번째 글 뒤에 넣고, 그다음 몇 개마다 넣을지.</p>
    <div class="row" style="flex-wrap:wrap; gap:18px">
      <div>
        <label class="field">첫 광고 위치 <span id="firstRange" class="muted"></span></label>
        <div class="stepper" data-key="listFirst">
          <button type="button" data-step="-1">−</button><input id="listFirst" type="number"><button type="button" data-step="1">+</button>
        </div>
        <label class="muted"><input id="listFirstDefault" type="checkbox"> 앱 기본값</label>
      </div>
      <div>
        <label class="field">간격 <span id="intervalRange" class="muted"></span></label>
        <div class="stepper" data-key="listInterval">
          <button type="button" data-step="-1">−</button><input id="listInterval" type="number"><button type="button" data-step="1">+</button>
        </div>
        <label class="muted"><input id="listIntervalDefault" type="checkbox"> 앱 기본값</label>
      </div>
    </div>
    <p id="listSummary" class="muted" style="margin:12px 0 0"></p>
    <div id="listPreview" class="preview-list"></div>
  </section>

  <section class="card">
    <h2>사이트 요청 UA</h2>
    <p class="desc">비우면 앱에 박힌 값을 씁니다. 사이트별로 프리셋(mobile · pc) 또는 UA 문자열을 지정할 수 있습니다.</p>
    <div id="presetFields"></div>
    <label class="field">사이트별</label>
    <div id="siteRows"></div>
    <button id="addSite" type="button">+ 사이트 추가</button>
  </section>

  <section class="card">
    <div class="row"><h2 class="grow">JSON 직접 편집</h2><button id="toggleJson" type="button" class="ghost">펼치기</button></div>
    <p class="desc">위 항목과 같은 내용입니다. 고친 뒤 <b>적용</b>을 누르면 위 화면에 반영됩니다.</p>
    <div id="jsonBox" class="hidden">
      <textarea id="json" spellcheck="false"></textarea>
      <div class="row" style="margin-top:8px"><span class="grow"></span><button id="applyJson" type="button">적용</button></div>
    </div>
  </section>

  <section class="card">
    <div class="row"><h2 class="grow">변경 이력</h2><button id="reloadHistory" type="button" class="ghost">새로고침</button></div>
    <p class="desc">저장할 때마다 바로 전 설정을 남깁니다. <b>불러오기</b> 후 저장하면 그 버전으로 돌아갑니다.</p>
    <div id="history" class="muted">불러오는 중…</div>
  </section>

  <section class="card">
    <h2>서버 상태</h2>
    <div id="serverStatus" class="muted">불러오는 중…</div>
  </section>
</main>

<div id="savebar" class="savebar hidden">
  <div class="inner">
    <span id="dirty" class="grow muted">변경 없음</span>
    <button id="revert" type="button" class="ghost" disabled>되돌리기</button>
    <button id="save" type="button" class="primary" disabled>저장</button>
  </div>
</div>

<script>
'use strict';
const SIZE_INFO = {
  compact: { label: 'compact', height: '~71dp', note: '목록 행 모양, 이미지 없음' },
  small:   { label: 'small',   height: '~144dp', note: '정사각 미디어 + 글' },
  medium:  { label: 'medium',  height: '~250dp', note: '카드, 낮은 미디어' },
  large:   { label: 'large',   height: '~310dp', note: '카드, 16:9 미디어' },
  off:     { label: 'off',     height: '0',      note: '광고 없음' },
};
const STORE_KEY = 'mocl-admin-token';
const $ = (id) => document.getElementById(id);
const el = (tag, attrs = {}, ...children) => {
  const node = document.createElement(tag);
  for (const [k, v] of Object.entries(attrs)) {
    if (k === 'class') node.className = v;
    else if (k.startsWith('on')) node.addEventListener(k.slice(2), v);
    else if (v !== undefined && v !== null && v !== false) node.setAttribute(k, v === true ? '' : v);
  }
  for (const c of children.flat()) if (c != null) node.append(c);
  return node;
};

let token = null;
let meta = null;
let baseText = '';      // 서버 파일 원문
let baseEtag = '';      // 그 원문의 해시(동시 수정 감지)
let base = {};          // 원문을 읽은 객체
let cfg = {};           // 편집 중인 객체

// ---------- 인증 ----------
function loadToken() {
  const hash = new URLSearchParams(location.hash.slice(1));
  if (hash.get('token')) {
    // 북마크용 #token=… 은 읽고 바로 주소창에서 지운다(서버로는 가지 않는 값).
    const t = hash.get('token');
    history.replaceState(null, '', location.pathname);
    localStorage.setItem(STORE_KEY, t);
    return t;
  }
  return localStorage.getItem(STORE_KEY) || sessionStorage.getItem(STORE_KEY);
}
function saveToken(t, remember) {
  localStorage.removeItem(STORE_KEY); sessionStorage.removeItem(STORE_KEY);
  (remember ? localStorage : sessionStorage).setItem(STORE_KEY, t);
}
function logout() {
  localStorage.removeItem(STORE_KEY); sessionStorage.removeItem(STORE_KEY);
  token = null; showLogin();
}

async function api(method, path, body) {
  const res = await fetch('/admin/api' + path, {
    method,
    headers: { 'authorization': 'Bearer ' + token, ...(body ? { 'content-type': 'application/json' } : {}) },
    body: body ? JSON.stringify(body) : undefined,
    cache: 'no-store',
  });
  let data = null;
  try { data = await res.json(); } catch (_) {}
  if (res.status === 401) { logout(); throw new Error('토큰이 맞지 않습니다'); }
  if (res.status === 429) throw new Error('잠시 뒤에 다시 시도하세요(인증 실패가 많음)');
  return { status: res.status, data };
}

function showLogin(message) {
  $('login').classList.remove('hidden');
  $('app').classList.add('hidden'); $('savebar').classList.add('hidden');
  $('logout').classList.add('hidden'); $('status').classList.add('hidden');
  $('loginError').classList.toggle('hidden', !message);
  $('loginError').textContent = message || '';
  $('token').focus();
}

async function enter() {
  try {
    const { status, data } = await api('GET', '/config');
    if (status !== 200) throw new Error(data?.error || ('HTTP ' + status));
    $('login').classList.add('hidden');
    $('app').classList.remove('hidden'); $('savebar').classList.remove('hidden');
    $('logout').classList.remove('hidden');
    meta = data.meta;
    setBase(data);
    renderStatic();
    render();
    loadHistory();
    loadStatus();
  } catch (e) {
    showLogin(e.message);
  }
}

// ---------- 상태 ----------
function setBase(data) {
  baseText = data.text; baseEtag = data.fileEtag;
  try { base = JSON.parse(baseText); } catch (_) { base = { schemaVersion: meta.schemaVersion }; }
  cfg = structuredClone(base);
  const pill = $('status');
  pill.classList.remove('hidden');
  pill.textContent = '적용 중 ' + data.servedEtag.replaceAll('"', '').slice(0, 8);
}
const clone = (o) => JSON.parse(JSON.stringify(o));
function ads() { return cfg.ads || {}; }
function setAds(mut) {
  const next = clone(ads());
  mut(next);
  if (next.list && Object.keys(next.list).length === 0) delete next.list;
  if (Object.keys(next).length === 0) delete cfg.ads; else cfg.ads = next;
  render();
}

// ---------- 그리기 ----------
function wire(size) {
  const i = (cls, w, h) => el('i', { class: cls || '', style: `width:${w};height:${h}px` });
  switch (size) {
    case 'compact': return [i('', '70%', 8), i('', '40%', 6)];
    case 'small': return [el('div', { class: 'h' }, i('m', '40px', 40), el('div', { style: 'flex:1;display:grid;gap:3px;align-content:start' }, i('', '90%', 6), i('', '60%', 6), i('', '50%', 5)))];
    case 'medium': return [i('', '50%', 6), i('m', '100%', 40), i('', '70%', 5)];
    case 'large': return [i('', '50%', 6), i('m', '100%', 70), i('', '70%', 5)];
    default: return [el('span', { class: 'muted', style: 'margin:auto' }, '없음')];
  }
}

function renderStatic() {
  const f = meta.limits.listFirst, n = meta.limits.listInterval;
  $('firstRange').textContent = `(${f[0]}~${f[1]})`;
  $('intervalRange').textContent = `(${n[0]}~${n[1]})`;
  for (const id of ['listFirst', 'listInterval']) {
    const range = meta.limits[id];
    $(id).min = range[0]; $(id).max = range[1];
  }
}

function render() {
  const a = ads();
  const def = meta.defaults;

  // 상세 광고 크기
  const current = a.detail || null;
  const sizes = $('sizes');
  sizes.replaceChildren(
    ...meta.detailSizes.map((s) => {
      const info = SIZE_INFO[s] || { label: s, height: '', note: '' };
      const isDefault = s === def.detail;
      const on = current === s || (!current && isDefault);
      return el('button', {
        type: 'button', class: 'size' + (on ? ' on' : ''),
        onclick: () => setAds((x) => { if (isDefault) delete x.detail; else x.detail = s; }),
      },
        el('div', { class: 'wire' }, wire(s)),
        el('b', {}, info.label, isDefault ? el('small', {}, ' · 기본') : null),
        el('small', {}, `${info.height} · ${info.note}`));
    }),
  );

  // 목록 광고
  const first = a.list?.first, interval = a.list?.interval;
  $('listFirst').value = first ?? def.listFirst;
  $('listInterval').value = interval ?? def.listInterval;
  $('listFirst').disabled = first == null; $('listInterval').disabled = interval == null;
  $('listFirstDefault').checked = first == null; $('listIntervalDefault').checked = interval == null;
  const f = first ?? def.listFirst, n = interval ?? def.listInterval;
  const slots = [];
  for (let k = f; k <= 60; k += n) slots.push(k);
  $('listSummary').textContent = `${slots.slice(0, 4).join(', ')}${slots.length > 4 ? ', …' : ''}번째 글 뒤에 광고 (60개 중 ${slots.length}개)`;
  $('listPreview').replaceChildren(
    ...Array.from({ length: 60 }, (_, idx) => el('span', { class: slots.includes(idx + 1) ? 'ad' : '', title: `${idx + 1}` })),
  );

  // UA 프리셋
  $('presetFields').replaceChildren(
    ...meta.presets.map((p) => el('div', {},
      el('label', { class: 'field' }, `${p} 프리셋 UA`),
      el('input', {
        type: 'text', value: cfg.userAgents?.[p] || '', placeholder: '비우면 앱 기본값',
        onchange: (e) => {
          const v = e.target.value.trim();
          cfg.userAgents = { ...(cfg.userAgents || {}) };
          if (v) cfg.userAgents[p] = v; else delete cfg.userAgents[p];
          if (!Object.keys(cfg.userAgents).length) delete cfg.userAgents;
          render();
        },
      }))),
  );

  // 사이트별 UA
  const sites = cfg.sites || {};
  $('siteRows').replaceChildren(
    ...Object.entries(sites).map(([site, value]) => siteRow(site, value?.userAgent ?? '')),
  );
  if (!Object.keys(sites).length) $('siteRows').append(el('p', { class: 'muted', style: 'margin:0 0 8px' }, '지정한 사이트 없음'));

  // JSON
  if (document.activeElement !== $('json')) $('json').value = pretty(cfg);

  updateDirty();
}

function siteRow(site, ua) {
  const isPreset = meta.presets.includes(ua);
  const mode = el('select', {
    onchange: (e) => {
      const v = e.target.value;
      setSite(site, site, v === 'custom' ? (isPreset ? '' : ua) : v);
    },
  },
  ...meta.presets.map((p) => el('option', { value: p, selected: ua === p }, `프리셋 ${p}`)),
  el('option', { value: 'custom', selected: !isPreset }, 'UA 직접 입력'));
  const used = Object.keys(cfg.sites || {});
  const siteSel = el('select', { onchange: (e) => setSite(site, e.target.value, ua) },
    ...meta.sites.filter((s) => s === site || !used.includes(s)).map((s) => el('option', { value: s, selected: s === site }, s)));
  return el('div', { class: 'site-row' },
    siteSel, mode,
    el('button', { type: 'button', class: 'danger', onclick: () => setSite(site, null) }, '삭제'),
    isPreset ? null : el('input', { type: 'text', value: ua, placeholder: 'Mozilla/5.0 …', onchange: (e) => setSite(site, site, e.target.value.trim()) }));
}

function setSite(oldSite, newSite, ua) {
  const next = {};
  for (const [k, v] of Object.entries(cfg.sites || {})) {
    if (k !== oldSite) next[k] = v;
    else if (newSite) next[newSite] = { userAgent: ua };
  }
  if (Object.keys(next).length) cfg.sites = next; else delete cfg.sites;
  render();
}

const pretty = (o) => JSON.stringify(o, null, 2) + '\n';

// ---------- 변경 비교 ----------
function flatten(o, prefix = '', out = {}) {
  if (o && typeof o === 'object' && !Array.isArray(o)) {
    const keys = Object.keys(o);
    if (!keys.length && prefix) out[prefix] = '{}';
    for (const k of keys) flatten(o[k], prefix ? `${prefix}.${k}` : k, out);
  } else out[prefix] = JSON.stringify(o);
  return out;
}
function changes() {
  const a = flatten(base), b = flatten(cfg);
  const keys = [...new Set([...Object.keys(a), ...Object.keys(b)])].sort();
  return keys.filter((k) => a[k] !== b[k]).map((k) => ({ key: k, from: a[k], to: b[k] }));
}
function updateDirty() {
  const n = changes().length;
  $('dirty').textContent = n ? `변경 ${n}개` : '변경 없음';
  $('save').disabled = !n; $('revert').disabled = !n;
}

// ---------- 저장 ----------
async function save() {
  const text = pretty(cfg);
  const check = await api('POST', '/validate', { text });
  const issues = check.data?.issues || [];
  if (issues.length) return showIssues(issues);
  const list = changes();
  const ok = await confirmDialog('이렇게 바꿀까요?', el('div', { class: 'changes' },
    ...list.map((c) => el('div', {}, el('b', {}, c.key), el('br'),
      c.from !== undefined ? el('del', {}, c.from) : el('span', { class: 'muted' }, '(없음 → 앱 기본값)'),
      ' → ',
      c.to !== undefined ? el('ins', {}, c.to) : el('span', { class: 'muted' }, '(지움 → 앱 기본값)')))),
    '저장');
  if (!ok) return;
  const { status, data } = await api('PUT', '/config', { text, baseEtag });
  if (status === 200) {
    setBase(data); render(); loadHistory(); loadStatus();
    toast(data.unchanged ? '바뀐 내용이 없습니다' : '저장했습니다. 앱은 다음 실행부터 적용합니다.');
  } else if (status === 409) {
    if (await confirmDialog('다른 곳에서 바뀌었습니다', el('p', {}, '서버의 최신 설정을 불러올까요? 지금 고친 내용은 사라집니다.'), '불러오기')) enter();
  } else if (status === 422) {
    showIssues(data.issues || []);
  } else {
    toast('저장 실패: ' + (data?.detail || data?.error || status));
  }
}

function showIssues(issues) {
  confirmDialog('저장할 수 없습니다', el('div', { class: 'issues' }, el('ul', {}, ...issues.map((m) => el('li', {}, m)))), null);
}

// ---------- 이력 · 상태 ----------
async function loadHistory() {
  const { data } = await api('GET', '/history');
  const items = data?.items || [];
  const box = $('history');
  if (!items.length) { box.textContent = '아직 없습니다'; return; }
  box.replaceChildren(...items.slice(0, 30).map((it) => el('div', { class: 'hist' },
    el('span', { class: 'grow' }, new Date(it.savedAt).toLocaleString('ko-KR'), el('span', { class: 'muted' }, ` · ${it.bytes}B`)),
    el('button', { type: 'button', class: 'ghost', onclick: () => viewHistory(it.id, false) }, '보기'),
    el('button', { type: 'button', onclick: () => viewHistory(it.id, true) }, '불러오기'))));
}

async function viewHistory(id, load) {
  const { status, data } = await api('GET', '/history/' + id);
  if (status !== 200) return toast('이력을 읽지 못했습니다');
  if (!load) return confirmDialog('저장 전 설정', el('pre', {}, data.text), null);
  try { cfg = JSON.parse(data.text); } catch (_) { return toast('이 이력은 JSON 이 깨져 있습니다'); }
  render();
  toast('불러왔습니다. 저장을 눌러야 적용됩니다.');
}

async function loadStatus() {
  const { data } = await api('GET', '/status');
  if (!data) return;
  const rows = [];
  const ago = (sec) => sec == null ? '아직 없음' : sec < 60 ? `${sec}초 전` : `${Math.round(sec / 60)}분 전`;
  const c = data.crawl;
  if (c) {
    rows.push(`키워드 알림 등록 기기: ${c.devices}`);
    rows.push(`감시 게시판: ${c.boards}개 · 실패 중: ${c.failingBoards}개`);
    rows.push(`알림 크롤 마지막: ${ago(c.lastTickAgoSec)} · 이슈 레이더 마지막: ${ago(c.radarLastRunAgoSec)}`);
  }
  rows.push(`적용 중인 설정 ETag: ${data.servedEtag}`);
  $('serverStatus').replaceChildren(...rows.map((r) => el('div', {}, r)));
}

// ---------- 대화 상자 ----------
function confirmDialog(title, body, okLabel) {
  return new Promise((resolve) => {
    const close = (v) => { back.remove(); resolve(v); };
    const back = el('div', { class: 'backdrop', onclick: (e) => { if (e.target === back) close(false); } },
      el('div', { class: 'dialog', role: 'dialog' },
        el('h3', {}, title), body,
        el('div', { class: 'row', style: 'margin-top:16px;justify-content:flex-end' },
          el('button', { type: 'button', class: 'ghost', onclick: () => close(false) }, okLabel ? '취소' : '닫기'),
          okLabel ? el('button', { type: 'button', class: 'primary', onclick: () => close(true) }, okLabel) : null)));
    document.body.append(back);
  });
}
let toastTimer;
function toast(message) {
  document.querySelector('.toast')?.remove();
  const t = el('div', { class: 'toast' }, message);
  document.body.append(t);
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => t.remove(), 3000);
}

// ---------- 이벤트 ----------
$('loginBtn').addEventListener('click', () => {
  const t = $('token').value.trim();
  if (!t) return;
  token = t; saveToken(t, $('remember').checked); $('token').value = '';
  enter();
});
$('token').addEventListener('keydown', (e) => { if (e.key === 'Enter') $('loginBtn').click(); });
$('logout').addEventListener('click', logout);
$('save').addEventListener('click', () => save().catch((e) => toast(e.message)));
$('revert').addEventListener('click', () => { cfg = clone(base); render(); });
$('reloadHistory').addEventListener('click', () => { loadHistory(); loadStatus(); });
$('addSite').addEventListener('click', () => {
  const used = Object.keys(cfg.sites || {});
  const site = meta.sites.find((s) => !used.includes(s));
  if (!site) return toast('모든 사이트가 이미 있습니다');
  cfg.sites = { ...(cfg.sites || {}), [site]: { userAgent: meta.presets[0] } };
  render();
});
$('toggleJson').addEventListener('click', () => {
  const box = $('jsonBox');
  box.classList.toggle('hidden');
  $('toggleJson').textContent = box.classList.contains('hidden') ? '펼치기' : '접기';
});
$('applyJson').addEventListener('click', () => {
  try {
    const next = JSON.parse($('json').value);
    if (!next || typeof next !== 'object' || Array.isArray(next)) throw new Error('최상위는 객체여야 합니다');
    cfg = next; $('json').blur(); render(); toast('적용했습니다. 저장을 눌러야 서버에 반영됩니다.');
  } catch (e) { toast('JSON 오류: ' + e.message); }
});
for (const key of ['listFirst', 'listInterval']) {
  const field = key === 'listFirst' ? 'first' : 'interval';
  const clamp = (v) => Math.min(meta.limits[key][1], Math.max(meta.limits[key][0], v));
  const set = (v) => setAds((x) => { x.list = { ...(x.list || {}), [field]: clamp(v) }; });
  $(key).addEventListener('change', (e) => { const v = parseInt(e.target.value, 10); if (!Number.isNaN(v)) set(v); else render(); });
  document.querySelector(`.stepper[data-key=${key}]`).addEventListener('click', (e) => {
    const step = Number(e.target.dataset.step);
    if (!step) return;
    const curr = ads().list?.[field] ?? meta.defaults[key];
    set(curr + step);
  });
  $(key + 'Default').addEventListener('change', (e) => setAds((x) => {
    x.list = { ...(x.list || {}) };
    if (e.target.checked) delete x.list[field]; else x.list[field] = meta.defaults[key];
  }));
}
document.addEventListener('keydown', (e) => {
  if ((e.metaKey || e.ctrlKey) && e.key === 's') { e.preventDefault(); if (!$('save').disabled) $('save').click(); }
});
window.addEventListener('beforeunload', (e) => { if (cfg && base && changes().length) e.preventDefault(); });

token = loadToken();
if (token) enter(); else showLogin();
</script>
</body>
</html>
''';
