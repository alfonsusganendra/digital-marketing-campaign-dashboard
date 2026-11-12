/*
 * Digital Marketing Campaign Performance Portfolio - SQL Queries & Dashboarding
 * Role Target: Business Analyst (Data Analyst)
 * Tools: PostgreSQL via DBeaver & Looker Studio
 * Dataset: Causal Digital Marketing Campaign Dataset

 * Queries included:
 * 1. Menghitung Return on Investment (ROI) (%)
 * 2. Menghitung Click Through Rate (%)
 * 3. Memberi label "campaign status" pada masing-masing campaign
 */

=========================================
-- Query Awal
=========================================

-- Cek semua kolom yang ada di dataset
select *
from raw_campaign_data
limit 10;

-- Cek total baris
select
	count(*) as total_rows
from raw_campaign_data

=========================================
-- Query Awal
=========================================

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
