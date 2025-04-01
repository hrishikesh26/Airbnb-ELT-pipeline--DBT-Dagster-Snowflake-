{{
  config(
    materialized = 'incremental',      
    on_schema_change='fail'            
    )   
}}
-- this is model level configuration
-- 'this is added so that if theres any changes in the schema in the upstream data then this should fail and necessary actions should be taken'
WITH src_reviews AS (
  SELECT * FROM {{ ref('src_reviews') }}
)
--SELECT * FROM src_reviews
--WHERE review_text is not null
--the above select statement was used to select all from the source review table - which did not contain a review id (surrogate key or unique id)

--to create a surrogate key - 
SELECT 
  {{ dbt_utils.generate_surrogate_key(['listing_id', 'review_date', 'reviewer_name', 'review_text']) }}
    AS review_id,
  * 
  FROM src_reviews
WHERE review_text is not null

-- now i need to mention how dbt/jinja would know if this is a new record or not. 

{% if is_incremental() %}
  {% if var("start_date", False) and var("end_date", False) %}
    {{ log('Loading ' ~ this ~ ' incrementally (start_date: ' ~ var("start_date") ~ ', end_date: ' ~ var("end_date") ~ ')', info=True) }}
    AND review_date >= '{{ var("start_date") }}'    -- line 29-30 is added to make dbt partition aware, this makes it incremental from the dates selected.
    AND review_date < '{{ var("end_date") }}'
  {% else %}
    AND review_date > (select max(review_date) from {{ this }})
    {{ log('Loading ' ~ this ~ ' incrementally (all missing dates)', info=True)}}
  {% endif %}
{% endif %}