# 🌍 Spatial Query Lab

An interactive **spatial SQL learning environment** using **Supabase (PostGIS)** and **Leaflet.js**.  
Developed for Texas A&M University students to explore geospatial databases, run spatial queries, and visualize results on a live map.

![Example Spatial Query Lab](https://github.com/rayford295/SpatialQueryLab/blob/main/Example_Spatial%20Quert%20Lab.PNG)
---

## 🚀 Overview

**Spatial Query Lab** lets students:
- Connect to a **Supabase/PostGIS** backend.
- Write and execute **SQL and spatial SQL** queries.
- Visualize query outputs (points, polygons, lines) instantly on a map.


---

## 🧭 Main Features

| Feature | Description |
|----------|-------------|
| 🗃️ **PostGIS Dataset** | Preloaded TAMU campus data (safety, buildings, roads, greens). |
| 💬 **SQL Runner (RPC)** | Executes queries via `run_open_sql(sql_text)` using Supabase. |
| 🗺️ **Interactive Map** | Leaflet-based visualization of GeoJSON results. |
| 📍 **Map Integration** | Click to inject `{{lat}}`, `{{lon}}`, `{{dist_m}}` into SQL. |
| 🧑‍🎓 **Teaching Sandbox** | Safe, resettable environment for classroom labs. |

---

## ⚙️ Quick Setup

1. **Create a Supabase Project**
   - Enable the **PostGIS** extension.
   - In SQL Editor, run the setup script [`setup_open.sql`](setup_open.sql).
   - This creates:
     - `campus_safety`, `campus_buildings`, `green_spaces`, `roads`
     - RPC: `run_open_sql(sql_text)`

2. **Run Locally**
   - Open `spatial_query_lab_fixed.html` in your browser.
   - Enter your **Supabase project URL** and **anon key**.
   - Write SQL → click **Run SQL** → view results on the map.

---

## 🧠 Example Spatial SQL Queries

A complete collection of **ready-to-run example queries** is provided here:  
👉 [**View Example Spatial Queries**](example_spatial_queries/example_spatial_queries.md)

These examples demonstrate core **PostGIS operations** used in the Spatial Query Lab:

- 🟢 **Buffering, Distance, and Proximity Analysis** — using `ST_Buffer`, `ST_DWithin`, and `ST_Distance`
- 🟣 **Spatial Joins and Intersections** — applying `ST_Intersects` and `ST_Intersection`
- 🟡 **Aggregation and Heatmap Preparation** — counting features per polygon and generating summary layers
- 🔵 **Interactive “Click-to-Query” Workflows** — dynamically inserting coordinates (`{{lat}}`, `{{lon}}`, `{{dist_m}}`) for user-driven queries
- 🟠 **Multi-layer Visualization** — combining outputs from multiple tables into a unified GeoJSON layer

Each query is annotated with its **purpose**, **PostGIS function**, and **expected visualization outcome** for teaching and exploration.


## 🧰 Tech Stack

* **Frontend:** HTML, JavaScript, Leaflet.js
* **Backend:** Supabase (PostgreSQL + PostGIS)
* **RPC:** `run_open_sql(sql_text)` (PL/pgSQL)
* **Data:** TAMU campus spatial dataset

---

## 🧩 Educational Use

Perfect for:

* Teaching **spatial SQL** and **PostGIS basics**
* Exploring **geodatabase design** and **spatial analysis**
* Hands-on **query visualization labs** in web GIS

---

## 🪪 License

MIT License © 2025 Yifan Yang
Department of Geography, Texas A&M University
[https://www.geoearlab.com](https://www.geoearlab.com)


