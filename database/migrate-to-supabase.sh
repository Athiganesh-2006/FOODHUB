#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Migrate the local foodhub database into Supabase.
#
# Reads the Supabase password from DB_PASSWORD — nothing is stored in this file.
# The local database is only ever READ from (pg_dump); it is never modified.
#
#   DB_PASSWORD='<supabase password>' bash database/migrate-to-supabase.sh
#
# Safe to re-run: it refuses to import if the Supabase tables already hold rows.
# ---------------------------------------------------------------------------
set -euo pipefail

PGBIN="${PGBIN:-/c/Program Files/PostgreSQL/17/bin}"
export PATH="$PGBIN:$PATH"

BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/backups"
SCHEMA_SQL="$(ls -t "$BACKUP_DIR"/foodhub-schema-*.sql | head -1)"
DATA_SQL="$(ls -t "$BACKUP_DIR"/foodhub-data-*.sql | head -1)"

LOCAL_PW="${LOCAL_DB_PASSWORD:-qwertyuiopasdfghjkl}"
SUPA_HOST="${SUPA_HOST:-db.zbiglpyyirmmauowesof.supabase.co}"
SUPA_PORT="${SUPA_PORT:-5432}"
SUPA_DB="${SUPA_DB:-postgres}"
SUPA_USER="${SUPA_USER:-postgres}"

: "${DB_PASSWORD:?DB_PASSWORD (the Supabase database password) must be set}"

SUPA_CONN="host=$SUPA_HOST port=$SUPA_PORT dbname=$SUPA_DB user=$SUPA_USER sslmode=require"
export PGCONNECT_TIMEOUT=20

supa() { PGPASSWORD="$DB_PASSWORD" psql "$SUPA_CONN" "$@"; }
local_q() { PGPASSWORD="$LOCAL_PW" psql -h localhost -p 5432 -U postgres -d foodhub -Atc "$1"; }

TABLES="users shops foods carts cart_items orders order_items"

echo "== 1. local source counts (read-only) =="
for t in $TABLES; do printf '   %-12s %s\n' "$t" "$(local_q "select count(*) from $t")"; done

echo
echo "== 2. Supabase connectivity =="
supa -Atc "select 'connected to ' || current_database() || ' as ' || current_user;"

echo
echo "== 3. duplicate guard: what is already in Supabase? =="
EXISTING=0
for t in $TABLES; do
  n=$(supa -Atc "select coalesce((select count(*) from public.$t), 0)" 2>/dev/null || echo "absent")
  printf '   %-12s %s\n' "$t" "$n"
  [ "$n" != "absent" ] && [ "$n" != "0" ] && EXISTING=$((EXISTING+1)) || true
done
if [ "$EXISTING" -gt 0 ]; then
  echo
  echo "   !! Supabase already holds FOODHUB rows in $EXISTING table(s)."
  echo "   !! Refusing to import — that would duplicate users/shops/foods/orders."
  echo "   !! Inspect and clear those tables first, then re-run."
  exit 2
fi

echo
echo "== 4. creating schema in Supabase =="
echo "   from: $(basename "$SCHEMA_SQL")"
supa -v ON_ERROR_STOP=1 -q -f "$SCHEMA_SQL"
echo "   schema created"

echo
echo "== 5. importing data (single transaction) =="
echo "   from: $(basename "$DATA_SQL")"
supa -v ON_ERROR_STOP=1 -q --single-transaction -f "$DATA_SQL"
echo "   data imported"

echo
echo "== 6. aligning sequences with the imported ids =="
for t in $TABLES; do
  supa -Atc "select setval(pg_get_serial_sequence('public.$t','id'), coalesce((select max(id) from public.$t), 1), (select count(*) from public.$t) > 0);" > /dev/null
  printf '   %-12s nextval -> %s\n' "$t" "$(supa -Atc "select last_value + case when is_called then 1 else 0 end from $(supa -Atc "select pg_get_serial_sequence('public.$t','id')")")"
done

echo
echo "== 7. verification: local vs Supabase =="
FAIL=0
printf '   %-12s %8s %10s   %s\n' TABLE LOCAL SUPABASE RESULT
for t in $TABLES; do
  l=$(local_q "select count(*) from $t"); s=$(supa -Atc "select count(*) from public.$t")
  if [ "$l" = "$s" ]; then r=MATCH; else r=MISMATCH; FAIL=1; fi
  printf '   %-12s %8s %10s   %s\n' "$t" "$l" "$s" "$r"
done

echo
echo "== 8. demo users in Supabase =="
supa -Atc "select email || '  ' || role || '  bcrypt=' || (left(password,4) in ('\$2a\$','\$2b\$','\$2y\$'))::text from users where email in ('customer@foodhub.com','owner@foodhub.com','admin@foodhub.com') order by email;"

echo
[ "$FAIL" = "0" ] && echo "MIGRATION OK — all table counts match." || { echo "MIGRATION INCOMPLETE — see MISMATCH rows above."; exit 1; }
