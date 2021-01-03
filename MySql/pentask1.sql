USE client_rw;

SELECT A1.account_number, ifnull(avg_deposit, 0) as avg_deposit,ifnull(avg_withdraw, 0) as avg_withdraw FROM
	(SELECT account_number, avg(lcy_amount_deposit) as avg_deposit FROM
		(
		SELECT 
				account_number, 
				SUM(lcy_amount) as lcy_amount_deposit, 
				dc_indicator,
				MONTH(tran_date) AS month,
				YEAR(tran_date) AS year
				FROM fc_transaction_base
				where dc_indicator="deposit"
				GROUP BY account_number, dc_indicator, month, year) dep
				GROUP BY account_number) A1 
	 LEFT JOIN
	 (SELECT account_number, avg(lcy_amount_withdraw) as avg_withdraw FROM
		(
		SELECT 
				account_number, 
				SUM(lcy_amount) as lcy_amount_withdraw, 
				dc_indicator,
				MONTH(tran_date) AS month,
				YEAR(tran_date) AS year
				FROM fc_transaction_base
				where dc_indicator="withdraw"
				GROUP BY account_number, dc_indicator, month, year) withdraw
				GROUP BY account_number) A2
	 ON A1.account_number = A2.account_number
     UNION ALL
     SELECT A2.account_number,ifnull(avg_deposit, 0) as avg_deposit, ifnull(avg_withdraw, 0) as avg_withdraw FROM
	(SELECT account_number, avg(lcy_amount_deposit) as avg_deposit FROM
		(
		SELECT 
				account_number, 
				SUM(lcy_amount) as lcy_amount_deposit, 
				dc_indicator,
				MONTH(tran_date) AS month,
				YEAR(tran_date) AS year
				FROM fc_transaction_base
				where dc_indicator="deposit"
				GROUP BY account_number, dc_indicator, month, year) dep
				GROUP BY account_number) A1 
	 RIGHT JOIN
	 (SELECT account_number, avg(lcy_amount_withdraw) as avg_withdraw FROM
		(
		SELECT 
				account_number, 
				SUM(lcy_amount) as lcy_amount_withdraw, 
				dc_indicator,
				MONTH(tran_date) AS month,
				YEAR(tran_date) AS year
				FROM fc_transaction_base
				where dc_indicator="withdraw"
				GROUP BY account_number, dc_indicator, month, year) withdraw
				GROUP BY account_number) A2
	 ON A1.account_number = A2.account_number