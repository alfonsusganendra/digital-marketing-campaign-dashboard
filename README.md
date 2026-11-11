# Digital Marketing Campaign Performance Dashboard

## Project Objective
*Project* ini berisi analisis efektivitas kampanye pemasaran digital. 
Tujuan utama:
- Menghitung metrik kinerja kunci seperti *Return on Investment* (ROI) dan *Click-Through Rate* (CTR).
- Mengidentifikasi *channel* dan *device* yang paling menghasilkan *revenue*.
- Memberikan *actionable insight* kepada tim Marketing untuk optimasi alokasi budget iklan.

## Tools & Teknologi
- **SQL (PostgreSQL via DBeaver):** untuk ekstraksi, pembersihan data (*data cleaning*) dan *feature engineering* (fungsi agregasi, 'CASE WHEN', 'NULLIF' dan *type casting*).
- **Google Looker Studio:** untuk pembuatan *dashboard* interaktif dengan fitur *cross-filtering*.

## Sumber Data
*Dataset* yang digunakan adalah **Causal Digital Marketing Campaign Dataset** (sumber dari Kaggle). 
Dataset ini berisi lebih dari 5.000 baris data campaign yang terdiri dari antara lain:
- Metrik ("spend_usd", "revenue_usd", "impressions", "clicks")
- Dimensi ("channel", "device").

## Proses Analisis
1. **Data Preparation & Cleaning:** Filtering data mentah untuk membuang baris yang tidak valid ("spend_usd" <=0, "impressions" <= 0, "revenue_usd IS NULL") guna memastikan integritas data.
2. **SQL Querying & Feature Engineering:** Membuat kolom metrik baru yang nantinya digunakan untuk kebutuhan insight bisnis, antara lain:
- Menghitung "roi_percentage"
- Menghitung "ctr_percentage"
- Membuat kategori "campaign_status" ('Profitable", "Break Even", "Loss").

## *Query* SQL (Feature Engineering)
```
select
	-- identitas kampanye
	"campaign_id",
	"channel",
	"device",
	"country",
	
	-- metriks
	"impressions",
	"clicks",
	"spend_usd",
	"revenue_usd",
	
	-- Menghitung Return on Investment (%)
	round(((("revenue_usd" - "spend_usd") / nullif("spend_usd", 0)) * 100)::numeric, 2) as "roi_percentage",
	
	-- Menghitung Click Trough Rate (%)
	round((("clicks"::numeric / nullif("impressions",0)) * 100)::numeric, 2) as "ctr_percentage",
	<img width="839" height="628" alt="dashboard_screenshot" src="https://github.com/user-attachments/assets/595ca399-08a4-49c1-81d9-ec530cc5e06a" />

	-- Memberi label "Campaign Status"
	case
		when ("revenue_usd" - "spend_usd") > 0 then 'Profitable'
		when ("revenue_usd" - "spend_usd") = 0 then 'Break Even'
		else 'Loss'
	end as "campaign_status"
from raw_campaign_data
where
	"spend_usd" > 0
	and "impressions" > 0
	and "revenue_usd" is not null;
```

## Key Insights & Rekomendasi
1. **Tingkat kegagalan *campaign* sangat tinggi (89,9% Loss)**
- Hampir 90% *campaign* menghasilkan ROI -100% (tidak ada *revenue* sama sekali).
- **Rekomendasi**: perlu *audit* untuk *market targeting* dan kualitas *ads* untuk *campaign* dengan status *loss*.

2. **Konsentrasi *revenue* pada *channel* dengan *revenue* tertinggi
- *channel* **Social** dan **Search** mendominasi total *revenue* perusahaan (72% dari total *revenue*).
- **Rekomendasi:** Pertahankan *budget* untuk kedua *channel* di atas dan lakukan A/B testing untuk *channel* dengan *revenue* rendah (channel Display dan Video).

## Tantangan dan Pembelajaran
- **Menangani *outlier* yang menmpengaruhi keseluruhan data**: Saat analisis awal, rata-rata (*mean*) ROI sangat tinggi (9363%). Saya menemukan hasil ini muncul karena *campaign* dengan *spend* yang kecil tapi *revenue* yang besar. Saya belajar mencoba melakukan validasi distribusi data dengan menggunakan **Median** untuk mendapatkkan gambaran bisnis yang lebih akurat.
- **Type Casting di PostgreSQL:** Saat menghitung ROI dan CTR, saya menemukan error 'function round(double precision, integer) does not exist'. Saya belajar mencoba melakukan *explicit casting* ('::numeric') pada hasil perhitungan sebelum dibulatkan dan belajar memahami pentingnya mengetahui sistem tipe data di PostgreSQL.

## Tampilan Dashboard
<img width="839" height="628" alt="dashboard_screenshot" src="https://github.com/user-attachments/assets/25744a2e-7065-4b15-8ea5-5179c48280ff" />

## Struktur file repository
-'README.md': Dokumentasi lengkap *project* ini. 
-'dashboard_screenshot.png': *Screenshot* tampilan *dashboard* di Looker Studio. 
-'data_transformation.sql': *Script* SQL lengkap (PostgreSQL) yang digunakan untuk *data cleaning* dan *feature engineering* di DBeaver. 
-'clean_campaign_data.csv': file data bersih hasil ekspor yang menjadi sumber data untuk visualisasi di Looker Studio. 

--------
Dibuat oleh saya, **Alfonsus Ganendra W. G. K.** sebagai bagian dari portfolio untuk *role* Business Analyst/Performance Analyst. 

[LinkedIn: https://linkedin.com/in/alfonsusganendra/]
