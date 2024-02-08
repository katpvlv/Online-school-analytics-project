select count(distinct visitor_id)
from sessions;

select count(distinct lead_id)
from leads;

select count(case when status_id = 142 then visitor_id end)
from leads;

with tab as (
    select
        date(visit_date) as day_,
        *
    from sessions
),

tab2 as (
    select
        count(visitor_id) over (partition by day_, source order by day_) as visitors,
        row_number() over (partition by day_, source order by day_) as rn,
        day_,
        source
    from tab
)

select
    visitors,
    extract(month from day_) as month_,
    extract(week from day_) as week_,
    day_,
    source 
from tab2
where rn = 1;

select
    date(s.visit_date) as date_,
    extract(week from s.visit_date) as week_,
    extract(month from s.visit_date) as month_,
    count(distinct l.lead_id) as lead,
    s.source
from sessions s
left join leads l
    on s.visitor_id = l.visitor_id
group by 1, 2, 3, 5;

select
    date(created_at) as date,
    count(case when status_id = 142 then visitor_id end) as purchase
from leads
group by 1
order by 1;

with sessions_with_paid_mark as (
    select
        *,
        case
            when
                medium in (
                    'cpc',
                    'cpm',
                    'cpa',
                    'youtube',
                    'cpp',
                    'tg',
                    'social'
                )
                then 1
            else 0
        end as is_paid
    from sessions
),

visitors_with_leads as (
    select
        s.visitor_id,
        s.visit_date,
        l.lead_id,
        l.created_at,
        l.amount,
        l.closing_reason,
        l.status_id,
        s.medium as utm_medium,
        s.campaign as utm_campaign,
        lower(s.source) as utm_source,
        row_number() over (
            partition by s.visitor_id
            order by s.is_paid desc, s.visit_date desc
        ) as rn
    from sessions_with_paid_mark as s
    left join leads as l
        on
            s.visitor_id = l.visitor_id
            and s.visit_date <= l.created_at
    where s.is_paid = 1
),

attribution as (
    select *
    from visitors_with_leads
    where rn = 1
),

aggregated_data as (
    select
        utm_source,
        utm_medium,
        utm_campaign,
        date(visit_date) as visit_date,
        date(created_at) as created_at,
        count(visitor_id) as visitors_count,
        count(
            case
                when created_at is not null then visitor_id
            end
        ) as leads_count,
        count(case when status_id = 142 then visitor_id end) as purchases_count,
        sum(case when status_id = 142 then amount end) as revenue
    from attribution
    group by 1, 2, 3, 4, 5
),

marketing_data as (
    select
        date(campaign_date) as visit_date,
        utm_source,
        utm_medium,
        utm_campaign,
        sum(daily_spent) as total_cost
    from ya_ads
    group by 1, 2, 3, 4
    union all
    select
        date(campaign_date) as visit_date,
        utm_source,
        utm_medium,
        utm_campaign,
        sum(daily_spent) as total_cost
    from vk_ads
    group by 1, 2, 3, 4
)

select
    a.visit_date,
    a.utm_source,
    a.utm_medium,
    a.utm_campaign,
    a.visitors_count,
    m.total_cost,
    a.leads_count,
    a.purchases_count,
    a.revenue,
    a.created_at,
    a.created_at - a.visit_date as date_diff
from aggregated_data as a
left join marketing_data as m
    on
        a.visit_date = m.visit_date
        and lower(a.utm_source) = m.utm_source
        and lower(a.utm_medium) = m.utm_medium
        and lower(a.utm_campaign) = m.utm_campaign
order by 9 desc nulls last, 1, 5 desc, 2, 3, 4;
