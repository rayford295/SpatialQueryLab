-- setup_open.sql
-- PostGIS teaching dataset + open SQL RPC
-- WARNING: run_open_sql executes arbitrary SQL. Use only for teaching / sandbox.

-- 0) Enable PostGIS
create extension if not exists postgis;

-- ------------------------------------------------------------
-- 1) Points: campus safety features
-- ------------------------------------------------------------
create table if not exists public.campus_safety (
  id   serial primary key,
  name text,
  type text,
  geom geometry(Point, 4326)
);

truncate table public.campus_safety;
insert into public.campus_safety (name, type, geom) values
('Emergency Call Box - Zachry', 'call_box', st_setsrid(st_point(-96.3407, 30.6197),4326)),
('Security Camera - Library',  'camera',   st_setsrid(st_point(-96.3389, 30.6181),4326)),
('Emergency Call Box - Kyle',  'call_box', st_setsrid(st_point(-96.3397, 30.6107),4326)),
('Security Camera - MSC',      'camera',   st_setsrid(st_point(-96.3419, 30.6128),4326));

-- ------------------------------------------------------------
-- 2) Buildings (polygons)
-- ------------------------------------------------------------
create table if not exists public.campus_buildings (
  id        serial primary key,
  bldg_name text,
  dept      text,
  geom      geometry(Polygon, 4326)
);

truncate table public.campus_buildings;
insert into public.campus_buildings (bldg_name, dept, geom) values
('Zachry Engineering Education Complex', 'Engineering',
 st_setsrid(st_geomfromtext('POLYGON((-96.3412 30.6199,-96.3404 30.6199,-96.3404 30.6194,-96.3412 30.6194,-96.3412 30.6199))'),4326)),
('Evans Library', 'Libraries',
 st_setsrid(st_geomfromtext('POLYGON((-96.3400 30.6184,-96.3392 30.6184,-96.3392 30.6178,-96.3400 30.6178,-96.3400 30.6184))'),4326));

-- ------------------------------------------------------------
-- 3) Green spaces (polygons)
-- ------------------------------------------------------------
create table if not exists public.green_spaces (
  id      serial primary key,
  name    text,
  area_m2 numeric,
  geom    geometry(Polygon, 4326)
);

truncate table public.green_spaces;
insert into public.green_spaces (name, area_m2, geom) values
('Simpson Drill Field', 60000,
 st_setsrid(st_geomfromtext('POLYGON((-96.3409 30.6179,-96.3397 30.6179,-96.3397 30.6168,-96.3409 30.6168,-96.3409 30.6179))'),4326));

-- ------------------------------------------------------------
-- 4) Roads (lines)
-- ------------------------------------------------------------
create table if not exists public.roads (
  id        serial primary key,
  road_name text,
  road_type text,
  geom      geometry(LineString, 4326)
);

truncate table public.roads;
insert into public.roads (road_name, road_type, geom) values
('George Bush Dr', 'primary',
 st_setsrid(st_geomfromtext('LINESTRING(-96.3476 30.6110,-96.3348 30.6110)'),4326));

-- ------------------------------------------------------------
-- 5) Spatial indexes (optional but recommended)
-- ------------------------------------------------------------
create index if not exists idx_campus_safety_geom     on public.campus_safety     using gist (geom);
create index if not exists idx_campus_buildings_geom  on public.campus_buildings  using gist (geom);
create index if not exists idx_green_spaces_geom      on public.green_spaces      using gist (geom);
create index if not exists idx_roads_geom             on public.roads             using gist (geom);

-- ------------------------------------------------------------
-- 6) Open RPC: run_open_sql(sql_text)
--    - Drop old version first (required if return type changed)
-- ------------------------------------------------------------
drop function if exists public.run_open_sql(text);

-- Create the correct version:
create or replace function public.run_open_sql(sql_text text)
returns setof jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  r record;
  rowcount bigint;
begin
  -- Try to execute as a SELECT and return each row as jsonb
  begin
    for r in execute sql_text loop
      return next to_jsonb(r);
    end loop;
    return;
  exception
    -- If not a SELECT (e.g., INSERT/UPDATE/DELETE), execute and return affected rowcount
    when feature_not_supported or sqlstate '0A000' then
      execute sql_text;
      get diagnostics rowcount = row_count;
      return next jsonb_build_object('ok', true, 'rowcount', rowcount);
      return;
  end;
end;
$$;

-- Grant execute to frontend roles
grant execute on function public.run_open_sql(text) to anon, authenticated;

-- Force PostgREST to reload the schema so RPC is immediately available
select pg_notify('pgrst', 'reload schema');

-- Smoke test: expect one row like {"?column?": 1}
select * from public.run_open_sql('select 1');
