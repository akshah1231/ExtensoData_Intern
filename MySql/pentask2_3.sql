Call fc_balance_compare();

/*	drop table if exists QA_fc_balance;

	CREATE TABLE client1_rw.QA_fc_balance as
	(SELECT 
		 a.account_number
		,a.tran_date
		,balance,today_balance_qa
		,case when ifnull(balance,0)=ifnull(today_balance_qa,0) then 'pass' else 'fail' end as today_balance_status
		,balance_before_1_day
		,balance_before_1_day_qa
		,case when ifnull(balance_before_1_day,0)=ifnull(balance_before_1_day_qa,0) then 'pass' else 'fail' end as balance_before_1_day_status
		,balance_before_2_days
		,balance_before_2_days_qa
		,case when ifnull(balance_before_2_days,0)=ifnull(balance_before_2_days_qa,0) then 'pass' else 'fail' end as balance_before_2_days_status
		,balance_before_3_days
		,balance_before_3_days_qa
		,case when ifnull(balance_before_3_days,0)=ifnull(balance_before_3_days_qa,0) then 'pass' else 'fail' end as balance_before_3_days_status
	FROM
	(SELECT
		account_number
		,tran_date
		,lcy_amount as today_balance_qa
		,LAG(lcy_amount, 1) over (partition by account_number order by tran_date) balance_before_1_day_qa
		,LAG(lcy_amount, 2) over (partition by account_number order by tran_date) balance_before_2_days_qa
		,LAG(lcy_amount, 3) over (partition by account_number order by tran_date) balance_before_3_days_qa
		FROM client1_rw.fc_balance_summary
		)a
		inner join 
		(
		select * from client1_rw.fc_balance_fact_penta 
		)b
		on a.account_number=b.account_number and a.tran_date=b.tran_date); */