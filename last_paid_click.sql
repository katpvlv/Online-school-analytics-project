select 
	s.visitor_id,
	s.visit_date,
	s.source as utm_source, 
	s.medium as utm_medium,
	s.campaign as utm_campaign,
	coalesce(l.lead_id, NULL) as lead_id,
	coalesce(l.created_at, NULL) as created_at,
	coalesce(l.amount, NULL) as amount,
	coalesce(l.closing_reason, NULL) as closing_reason,
	coalesce(l.status_id, NULL) as status_id
from sessions s
join leads l
	on s.visitor_id = l.visitor_id
where s.medium in ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
order by amount desc NULLS last, visit_date, utm_source, utm_medium, utm_campaign;
