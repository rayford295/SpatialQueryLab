
-- spatial_sql_sqlrunner.sql
-- Read-only SQL runner for classroom use.
-- Creates: run_student_sql(sql text) RETURNS SETOF jsonb
-- - Only allows single SELECT statements (no ';')
-- - Blacklists dangerous keywords
-- - Applies LIMIT 1000 if not present
-- - Students should output ST_AsGeoJSON(geom)::jsonb AS geom for map drawing.

create or replace function public.run_student_sql(sql text)
returns setof jsonb
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  q text := trim(sql);
  lowered text;
  final text;
begin
  -- basic guards
  if position(';' in q) > 0 then
    raise exception 'Multiple statements are not allowed';
  end if;

  lowered := lower(q);
  if position('insert ' in lowered) > 0 or
     position('update ' in lowered) > 0 or
     position('delete ' in lowered) > 0 or
     position('alter ' in lowered) > 0 or
     position('drop ' in lowered) > 0 or
     position('create ' in lowered) > 0 or
     position('grant ' in lowered) > 0 or
     position('revoke ' in lowered) > 0 or
     position('truncate ' in lowered) > 0 then
     raise exception 'Only SELECT queries are permitted';
  end if;

  if left(lowered, 6) <> 'select' then
    raise exception 'Query must start with SELECT';
  end if;

  -- enforce LIMIT if missing (basic heuristic)
  if position(' limit ' in lowered) = 0 then
    q := q || ' limit 1000';
  end if;

  -- timeout per query
  perform set_config('statement_timeout','5000',true);

  final := 'select to_jsonb(t) from (' || q || ') t';
  return query execute final;
end;
$$;

-- NOTE: For geometry visualization, students should include:
--   ST_AsGeoJSON(geom)::jsonb AS geom
-- in their SELECT list so the frontend can draw features.
