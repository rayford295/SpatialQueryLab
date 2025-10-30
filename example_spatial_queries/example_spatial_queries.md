Perfect — these example SQL queries are a great teaching addition for your **Spatial Query Lab** repository.
Here’s a clean, professional way to integrate them:

---

### 🧭 Option 1: Add a separate file

Create a new file called:
📄 **`example_spatial_queries.md`**

with this full content:

---

````markdown
# 🧠 Example Spatial SQL Queries for Spatial Query Lab

This collection provides **ready-to-run spatial SQL examples** for use with the Spatial Query Lab teaching environment.  
Each query is designed to illustrate a specific **PostGIS function** or **geospatial analysis concept**, ideal for interactive classroom exercises.

---

## 🟢 1. View All Campus Safety Features
```sql
select id, name, type,
       st_asgeojson(geom)::jsonb as geom
from campus_safety
limit 20;
````

**Purpose:** Basic query to verify table structure and visualize all points.

---

## 🟣 2. Buffer Around Each Point (50 meters)

```sql
select id, name,
       st_asgeojson(st_buffer(geom::geography, 50)::geometry)::jsonb as geom
from campus_safety;
```

**Purpose:** Creates circular buffers around each feature to visualize coverage zones.

---

## 🟡 3. Find Features Within a Distance (Click-to-Query)

```sql
select id, name, type,
       st_asgeojson(geom)::jsonb as geom
from campus_safety
where st_dwithin(
  geom::geography,
  st_setsrid(st_point({{lon}}, {{lat}}), 4326)::geography,
  {{dist_m}}
);
```

**Purpose:** Finds all features within a radius (e.g., 200 m) of the clicked point on the map.

---

## 🔵 4. Find the Nearest Feature to a Clicked Point

```sql
select id, name, type,
       st_distance(
         geom::geography,
         st_setsrid(st_point({{lon}}, {{lat}}),4326)::geography
       ) as dist_m,
       st_asgeojson(geom)::jsonb as geom
from campus_safety
order by geom <-> st_setsrid(st_point({{lon}}, {{lat}}),4326)
limit 1;
```

**Purpose:** Returns the single nearest safety facility to a location.

---

## 🟠 5. Intersect Features Between Tables

```sql
select s.id as safety_id, s.name as safety_name, b.bldg_name,
       st_asgeojson(s.geom)::jsonb as geom
from campus_safety s
join campus_buildings b
on st_intersects(s.geom, b.geom);
```

**Purpose:** Finds safety features located within or touching campus buildings.

---

## 🟢 6. Count Features Per Type

```sql
select type, count(*) as feature_count
from campus_safety
group by type
order by feature_count desc;
```

**Purpose:** Aggregates the number of cameras and call boxes for a quick summary.

---

## 🔵 7. Clip Buildings by Green Space

```sql
select b.id, b.bldg_name, g.name as park_name,
       st_asgeojson(st_intersection(b.geom, g.geom))::jsonb as geom
from campus_buildings b
join green_spaces g
on st_intersects(b.geom, g.geom);
```

**Purpose:** Shows which building footprints overlap with green spaces.

---

## 🟣 8. Compute Distance Between Cameras and Call Boxes

```sql
select c1.name as camera_name, c2.name as callbox_name,
       st_distance(c1.geom::geography, c2.geom::geography) as dist_m
from campus_safety c1, campus_safety c2
where c1.type = 'camera'
  and c2.type = 'call_box'
order by dist_m
limit 10;
```

**Purpose:** Measures nearest distances between two different feature types.

---

## 🟤 9. Find Buildings Near Roads (Within 30 m)

```sql
select b.id, b.bldg_name, r.road_name,
       st_asgeojson(b.geom)::jsonb as geom
from campus_buildings b
join roads r
on st_dwithin(b.geom::geography, r.geom::geography, 30);
```

**Purpose:** Identifies buildings located close to major roads.

---

## 🟡 10. Create Combined GeoJSON Layers

```sql
select 'campus_safety' as layer, st_asgeojson(geom)::jsonb as geom from campus_safety
union all
select 'campus_buildings' as layer, st_asgeojson(geom)::jsonb as geom from campus_buildings
union all
select 'roads' as layer, st_asgeojson(geom)::jsonb as geom from roads;
```

**Purpose:** Combines multiple datasets into a single map layer for visualization.

---

## 🔴 11. Find Green Spaces Containing Clicked Location

```sql
select name, area_m2,
       st_asgeojson(geom)::jsonb as geom
from green_spaces
where st_contains(
  geom,
  st_setsrid(st_point({{lon}}, {{lat}}),4326)
);
```

**Purpose:** Identifies which park or green area a clicked point falls into.

---

## 🟣 12. Heatmap Preparation – Count Safety Features per Building

```sql
select b.bldg_name, count(s.id) as safety_count,
       st_asgeojson(b.geom)::jsonb as geom
from campus_buildings b
left join campus_safety s
on st_within(s.geom, b.geom)
group by b.bldg_name, b.geom
order by safety_count desc;
```

**Purpose:** Creates aggregated spatial counts useful for heatmaps or choropleth visualization.

---

## 🧩 13. Multi-Condition Query (Spatial + Attribute)

```sql
select id, name, type,
       st_asgeojson(geom)::jsonb as geom
from campus_safety
where type = 'call_box'
  and st_dwithin(
    geom::geography,
    st_setsrid(st_point({{lon}}, {{lat}}), 4326)::geography,
    300
  );
```

**Purpose:** Finds only call boxes within 300 m of a user-selected location.

---

## ⚙️ 14. Create Bounding Box from All Features

```sql
select st_asgeojson(st_extent(geom))::jsonb as geom
from campus_safety;
```

**Purpose:** Displays a bounding box around all safety points.

---

## 🧠 15. Nearest Building to Clicked Point

```sql
select b.id, b.bldg_name,
       st_distance(
         b.geom::geography,
         st_setsrid(st_point({{lon}}, {{lat}}),4326)::geography
       ) as dist_m,
       st_asgeojson(b.geom)::jsonb as geom
from campus_buildings b
order by geom <-> st_setsrid(st_point({{lon}}, {{lat}}),4326)
limit 1;
```

**Purpose:** Returns the closest building to the selected map location.

---

### ✅ Teaching Tips

Encourage students to:

* Modify buffer radius (e.g., 100 m, 250 m).
* Experiment with **ST_Union**, **ST_Area**, and **ST_Length**.
* Combine **attribute + spatial filters** for richer analysis.
* Compare **query performance** using spatial indexes.

````

---

### 🧩 Step 2: Link it from your main `README.md`
In your main README (after the “Educational Use” section), add this:

```markdown
---

## 🧠 Example SQL Queries

Explore practical, ready-to-run examples here:  
👉 [Example Spatial SQL Queries](example_spatial_queries.md)

These queries illustrate:
- Buffering and distance operations  
- Spatial joins and intersections  
- Aggregation, filtering, and visualization techniques  
- Interactive click-to-query workflows
````

---

Would you like me to reformat the query file with collapsible `<details>` sections (like an interactive GitHub tutorial style)? That version looks great for teaching repositories — each query can expand/collapse for students.

