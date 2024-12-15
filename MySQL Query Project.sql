-- Project MySQL

-- What is the Total Revenue
select round(sum(projects.sales.quantity * projects.products.unit_price_usd),2) as Total_Revenue
	from projects.sales
		join projects.products on (projects.products.product_key = projects.sales.product_key); 
        
-- Year over Year Sales
with cte as(select year(projects.sales.order_date) Year, round(SUM(projects.sales.quantity * projects.products.unit_price_usd),2) Sales
            from projects.sales
            join projects.products on (projects.products.product_key = projects.sales.product_key)
            group by year(projects.sales.order_date))
select c1.*, round((((c1.Sales - c2.Sales) / c2.Sales) * 100),2) as Percent_Growth
from cte c1
left join cte c2 on c1.Year = c2.Year + 1

-- What is the Total_Profit
select round(sum(projects.sales.quantity * projects.products.unit_price_usd),2) as Total_Revenue,
			round(sum(projects.sales.quantity * projects.products.unit_cost_usd),2) as Total_Cost,
				round((sum(projects.sales.quantity * projects.products.unit_price_usd)-sum(projects.sales.quantity * projects.products.unit_cost_usd)),2) as Total_Profit
from projects.sales
	join projects.products on (projects.products.product_key = projects.sales.product_key);

-- Year over Year Profit
with cte as(select year(projects.sales.order_date) as Year,
			round((sum(projects.sales.quantity * projects.products.unit_price_usd)-sum(projects.sales.quantity * projects.products.unit_cost_usd)),2) as Profit	
		  from projects.sales
            join projects.products on (projects.products.product_key = projects.sales.product_key)
            group by year(projects.sales.order_date))
select c1.*, round((((c1.Profit - c2.Profit) / c2.Profit) * 100),2) as Percent_Growth
from cte c1
left join cte c2 on c1.Year = c2.Year + 1

-- Total Products Sold
select sum(projects.sales.quantity) as Total_Products_Sold
	from projects.sales
    
-- Year over Year Products Sold or Quantity
with cte as(select year(projects.sales.order_date) as Year,
						sum(projects.sales.quantity) as Quantity
		  from projects.sales
            group by year(projects.sales.order_date))
select c1.*, ((c1.Quantity - c2.Quantity) / c2.Quantity) * 100 as Percent_Growth
from cte c1
left join cte c2 on c1.Year = c2.Year + 1
    
-- Total Orders
select count(distinct projects.sales.order_number) as Total_Orders
	from projects.sales
    
-- Average Order Value
select round((sum(projects.sales.quantity * projects.products.unit_price_usd)/count(distinct projects.sales.order_number)),2) as avg_order_value
from projects.sales
	join projects.products on (projects.products.product_key = projects.sales.product_key);
    
-- Average Product Per Order
select (sum(projects.sales.quantity)/count(distinct projects.sales.order_number)) as avg_order
	from projects.sales
		join projects.products on (projects.products.product_key = projects.sales.product_key);
        
-- Daily Trend For Total Revenue
select dayofweek(projects.sales.order_date) as day_number,
		dayname(projects.sales.order_date) as dayname,
			round(SUM(projects.sales.quantity * projects.products.unit_price_usd),2) as Sales
	from projects.sales
		join projects.products on (projects.products.product_key = projects.sales.product_key)
        group by day_number, dayname
        order by day_number
        
-- Monthly Trend For Total Order
select month(projects.sales.order_date) as month_number,
		monthname(projects.sales.order_date) as month_name,
			count(distinct projects.sales.order_number) as Total_Orders
	from projects.sales
        group by month_number, month_name
        order by month_number
			
-- Top 3 Category by Total Revenue in 2021
select projects.products.category as Category,
			round(sum(projects.sales.quantity*projects.products.unit_price_USD),2) as Total_Revenue
from projects.products
join projects.sales on (projects.sales.product_key = projects.products.product_key)
where year(projects.sales.order_date) = 2021
group by Category
order by Total_Revenue desc
limit 3

-- Bottom 3 Category by Total Revenue in 2021
select projects.products.category as Category,
			round(sum(projects.sales.quantity*projects.products.unit_price_USD),2) as Total_Revenue
from projects.products
join projects.sales on (projects.sales.product_key = projects.products.product_key)
where year(projects.sales.order_date) = 2021
group by Category
order by Total_Revenue asc
limit 3

-- Top 3 Category by Quantity Sold in 2021
select projects.products.category as Category,
			sum(projects.sales.quantity) as Quantity
from projects.products
join projects.sales on (projects.sales.product_key = projects.products.product_key)
where year(projects.sales.order_date) = 2021
group by Category
order by Quantity desc
limit 3

-- Bottom 3 Category by Quantity Sold in 2021
select projects.products.category as Category,
			sum(projects.sales.quantity) as Quantity
from projects.products
join projects.sales on (projects.sales.product_key = projects.products.product_key)
where year(projects.sales.order_date) = 2021
group by Category
order by Quantity asc
limit 3

-- Top 3 Category by Total Orders in 2021
select projects.products.category as Category,
			count(distinct projects.sales.order_number) as Total_Order
from projects.products
join projects.sales on (projects.sales.product_key = projects.products.product_key)
where year(projects.sales.order_date) = 2021
group by Category
order by Total_Order desc
limit 3

-- Bottom 3 Category by Total Orders in 2021
select projects.products.category as Category,
			count(distinct projects.sales.order_number) as Total_Order
from projects.products
join projects.sales on (projects.sales.product_key = projects.products.product_key)
where year(projects.sales.order_date) = 2021
group by Category
order by Total_Order asc
limit 3

-- Best sub-category by Total Revenue in 2020
select projects.products.subcategory as Subcategory,
		round(sum(projects.sales.quantity*projects.products.unit_price_USD),2) as Total_Revenue
from projects.products
join projects.sales on (projects.sales.product_key = projects.products.product_key)
where year(projects.sales.order_date) = 2020
group by Subcategory
order by Total_Revenue desc
limit 1

-- Worst sub-category by Total Revenue in 2020
select projects.products.subcategory as Subcategory,
		round(sum(projects.sales.quantity*projects.products.unit_price_USD),2) as Total_Revenue
	from projects.products
			join projects.sales on (projects.sales.product_key = projects.products.product_key)
				where year(projects.sales.order_date) = 2020
						group by Subcategory
									order by Total_Revenue asc
											limit 1

-- Which state has the highest sales rate in 2021
select projects.customers.state as State,
			round(sum(projects.sales.quantity*projects.products.unit_price_USD), 2) as Sales
	from projects.customers
			join projects.sales on (projects.sales.customer_key = projects.customers.customer_key)
				join projects.products on (projects.sales.product_key = projects.products.product_key)
					where year(projects.sales.order_date) = 2021
	group by State
		order by Sales desc
			limit 1

-- Who are the customers with the highest shopping amount in 2021
select projects.customers.name as Name,
			projects.customers.gender as Gender,
				projects.customers.birthday as Birthday,
					round(sum(projects.sales.quantity*projects.products.unit_price_USD), 2) as Amount_Sales
	from projects.customers
			join projects.sales on (projects.sales.customer_key = projects.customers.customer_key)
				join projects.products on (projects.sales.product_key = projects.products.product_key)
					where year(projects.sales.order_date) = 2021
	group by Name, Gender, Birthday
		order by Amount_Sales desc
			limit 1
            
