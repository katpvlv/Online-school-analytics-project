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
)
select 
	visitor_id,
	visit_date,
	utm_source, 
	utm_medium,
	utm_campaign,
	coalesce(lead_id, NULL) as lead_id,
	coalesce(created_at, NULL) as created_at,
	coalesce(amount, NULL) as amount,
	coalesce(closing_reason, NULL) as closing_reason,
	coalesce(status_id, NULL) as status_id
from attribution
order by amount desc NULLS last, visit_date, utm_source, utm_medium, utm_campaign
limit 10;
