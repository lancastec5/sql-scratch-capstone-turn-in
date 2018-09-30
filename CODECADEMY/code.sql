--Get familiar with CoolTShirts
-- How many campaigns and sources does CoolTShirts use?
SELECT count(DISTINCT utm_campaign) AS 'Distinct UTM Campaigns', count(distinct utm_source) as 'Distinct UTM Sources'
FROM page_visits;

-- Which source is used for each campaign?
SELECT DISTINCT utm_source AS 'UTM Source', utm_campaign AS 'UTM Campaign'
FROM page_visits;

-- What pages are on the CoolTShirts website?
SELECT DISTINCT page_name AS 'CoolTShirts Webpages'
FROM page_visits;

--User Journey
--How many first touches is each campaign responsible for?
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source AS 'source',
       ft_attr.utm_campaign as'campaign',
       COUNT(*) AS 'ft per campaign'
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

-- How many last touches is each campaign responsible for?
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS 'source',
       lt_attr.utm_campaign as'campaign',
       COUNT(*) AS 'lt per campaign'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

-- How many visitors make a purchase?
SELECT COUNT(DISTINCT user_id) AS 'purchasers'
FROM page_visits
WHERE page_name = '4 - purchase';


-- How many last touches on the purchase page is each campaign responsible for?
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
  	WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS 'source',
       lt_attr.utm_campaign as'campaign',
       COUNT(*) AS 'lt per campaign purchased'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC
;
