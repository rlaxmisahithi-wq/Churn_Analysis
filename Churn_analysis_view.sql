create view vw_churnData as
select * from prod_churn where Customer_Status in ('churned', 'stayed');

-- Joined data
create view vw_JoinData as
select * from prod_churn where Customer_Status = 'Joined';