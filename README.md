Perfect — here’s a polished and professional **GitHub README.md** (in English) you can paste directly:

---

````markdown
# 🌍 SpatialQueryLab

An **interactive geospatial database and SQL learning environment** for Texas A&M University (TAMU) students.  
The lab integrates **ArcGIS FeatureServer** and **Supabase/PostGIS** to teach spatial database concepts, spatial SQL, and real-time geodata visualization.

---

## 🚀 Overview

**SpatialQueryLab** is designed as a hands-on learning tool for geospatial courses (e.g., *GEOG 478 Web GIS, Geodatabase, or Spatial Analysis*).  
It allows students to:
- Load **real-world geospatial data** from ArcGIS FeatureServer (e.g., TAMU Campus Safety dataset).  
- Connect to a **Supabase/PostGIS** backend to execute spatial SQL queries.  
- Instantly **visualize query results** (points, buffers, and nearest features) on an interactive web map.  

---

## 🗺️ Features

| Feature | Description |
|----------|-------------|
| 🧭 **ArcGIS FeatureServer Loader** | Load live geospatial datasets directly via ArcGIS REST API (`/FeatureServer/query?f=geojson`). |
| 🧮 **SQL Runner (Supabase/PostGIS)** | Execute spatial SQL queries through Supabase RPC and display results on the map. |
| 🧑‍🎓 **Student-Friendly Sandbox** | Safe SQL environment with a read-only function `run_student_sql()` to prevent destructive queries. |
| 🌐 **Interactive Map Visualization** | Powered by **MapLibre GL JS** for dynamic spatial visualization. |
| 📦 **Local or Cloud Mode** | Works with both remote (Supabase) and local datasets for offline teaching. |

---

## ⚙️ How It Works

1. **Load Real Data (ArcGIS Mode)**  
   - The interface automatically fetches and displays GeoJSON from ArcGIS REST services.  
   - Example dataset:  
     [TAMU Campus Safety Map](https://services1.arcgis.com/qr14biwnHA6Vis6l/arcgis/rest/services/Campus_Safety_Layer/FeatureServer/0)

2. **Connect to Supabase (SQL Mode)**  
   - Create a free Supabase project with **PostGIS enabled**.  
   - Run the setup script [`spatial_sql_sqlrunner.sql`](spatial_sql_sqlrunner.sql) to define a safe RPC function:
     ```sql
     select * from run_student_sql('
       select id, name, type,
              st_distance(geom::geography, st_setsrid(st_point(-96.34, 30.62),4326)::geography) as dist_m,
              st_asgeojson(geom)::jsonb as geom
       from campus_safety
       order by geom <-> st_setsrid(st_point(-96.34, 30.62),4326)
       limit 20;
     ');
     ```
   - Click a point on the map to set `{{lon}}` and `{{lat}}` and visualize the results.

3. **Write & Run SQL**  
   Students can explore:
   - `ST_DWithin()` — find features within a radius.  
   - `ST_Distance()` — measure proximity.  
   - `ST_Intersects()` — test spatial relationships.  
   - `GROUP BY type` — aggregate by feature type.

---

## 📚 Example Classroom Exercises

| Exercise | Goal |
|-----------|------|
| **1. Nearest Safety Facility** | Find the nearest 10 emergency call boxes to any clicked location. |
| **2. Hotspot Analysis** | Count the number of safety features within 500 meters. |
| **3. Spatial Aggregation** | Summarize facilities by category (e.g., cameras vs. call boxes). |
| **4. Distance Comparison** | Compare spatial density between two parts of campus. |

---

## 🧰 Tech Stack

- **Frontend:** HTML5 + JavaScript + MapLibre GL JS  
- **Backend:** Supabase (PostgreSQL + PostGIS)  
- **Data Integration:** ArcGIS REST API / FeatureServer  
- **Libraries:** Turf.js, Supabase.js, ESRI GeoJSON  

---

## 🧪 Setup & Deployment

1. **Clone the Repository**
   ```bash
   git clone https://github.com/rayford295/SpatialQueryLab.git
   cd SpatialQueryLab
````

2. **Run Locally**

   * Open `spatial_lab_sandbox_v4.html` in your browser.
   * Or deploy via GitHub Pages (recommended for teaching):

     ```bash
     git add .
     git commit -m "Deploy SpatialQueryLab"
     git push
     ```

     Then enable Pages → "Deploy from `main` branch" → select `/ (root)`.

3. **Optional:** Set up Supabase SQL Runner

   * Open your Supabase SQL Editor.
   * Copy-paste and run [`spatial_sql_sqlrunner.sql`](spatial_sql_sqlrunner.sql).
   * Connect using your project URL and public anon key.

---

## 🧑‍🏫 Educational Use Case

This project is ideal for:

* Teaching **Geodatabase** or **Web GIS** concepts.
* Demonstrating **spatial SQL queries** interactively.
* Conducting **campus safety mapping** or **urban analysis** labs.
* Encouraging open-source, reproducible spatial education.

---

## 🧩 Future Extensions

* Polygon AOI drawing & querying (`ST_Intersects`, `ST_Contains`)
* Real-time analytics (e.g., heatmaps)
* Integration with open data APIs (OpenStreetMap, SafeGraph, etc.)
* Student submission & grading dashboard

---

## 🪪 License

MIT License © 2025 Yifan Yang
Department of Geography, Texas A&M University
[https://www.geoearlab.com](https://www.geoearlab.com)

---

### ⭐ Acknowledgments

This project was developed as part of **GEOG 478 / GEOG 651** coursework and research in the **GEAR Lab (Geospatial Exploration and Resolution Lab)**, advised by **Dr. Lei Zou**.

---

```

---

Would you like me to also generate a **shorter version for the GitHub Pages landing (index.html README section)** — so your repository doubles as an interactive webpage (with embedded screenshots and links)?
```
