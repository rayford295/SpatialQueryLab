-- setup_open.sql
-- Full PostGIS teaching dataset (Texas A&M sample)
-- No query restrictions (students can freely INSERT/UPDATE/DELETE)

create extension if not exists postgis;

-- ------------------------------
-- 1) Points: campus safety features
-- ------------------------------
create table if not exists public.campus_safety (
  id serial primary key,
  name text,
  type text,
  geom geometry(Point, 4326)
);

truncate table public.campus_safety;
insert into public.campus_safety (name, type, geom) values
('Emergency Call Box - Zachry', 'call_box', st_setsrid(st_point(-96.3407, 30.6197),4326)),
('Security Camera - Library', 'camera', st_setsrid(st_point(-96.3389, 30.6181),4326)),
('Emergency Call Box - Kyle', 'call_box', st_setsrid(st_point(-96.3397, 30.6107),4326)),
('Security Camera - MSC', 'camera', st_setsrid(st_point(-96.3419, 30.6128),4326));

-- ------------------------------
-- 2) Buildings (polygons)
-- ------------------------------
create table if not exists public.campus_buildings (
  id serial primary key,
  bldg_name text,
  dept text,
  geom geometry(Polygon, 4326)
);

truncate table public.campus_buildings;
insert into public.campus_buildings (bldg_name, dept, geom) values
('Zachry Engineering Education Complex', 'Engineering',
 st_setsrid(st_geomfromtext('POLYGON((-96.3412 30.6199,-96.3404 30.6199,-96.3404 30.6194,-96.3412 30.6194,-96.3412 30.6199))'),4326)),
('Evans Library', 'Libraries',
 st_setsrid(st_geomfromtext('POLYGON((-96.3400 30.6184,-96.3392 30.6184,-96.3392 30.6178,-96.3400 30.6178,-96.3400 30.6184))'),4326));

-- ------------------------------
-- 3) Green spaces
-- ------------------------------
create table if not exists public.green_spaces (
  id serial primary key,
  name text,
  area_m2 numeric,
  geom geometry(Polygon, 4326)
);

truncate table public.green_spaces;
insert into public.green_spaces (name, area_m2, geom) values
('Simpson Drill Field', 60000,
 st_setsrid(st_geomfromtext('POLYGON((-96.3409 30.6179,-96.3397 30.6179,-96.3397 30.6168,-96.3409 30.6168,-96.3409 30.6179))'),4326));

-- ------------------------------
-- 4) Roads (lines)
-- ------------------------------
create table if not exists public.roads (
  id serial primary key,
  road_name text,
  road_type text,
  geom geometry(LineString, 4326)
);

truncate table public.roads;
insert into public.roads (road_name, road_type, geom) values
('George Bush Dr', 'primary',
 st_setsrid(st_geomfromtext('LINESTRING(-96.3476 30.6110,-96.3348 30.6110)'),4326));

-- ------------------------------
-- 5) Simplified open RPC for SQL execution (no restrictions)
-- ------------------------------
create or replace function public.run_open_sql(sql text)
returns jsonb[]
language plpgsql
security definer
as $$
declare
  rows jsonb[];
begin
  execute 'select coalesce(array_agg(to_jsonb(t)), array[]::jsonb[]) from (' || sql || ') as t' into rows;
  return rows;
end
$$;

grant execute on function public.run_open_sql(text) to anon, authenticated;
