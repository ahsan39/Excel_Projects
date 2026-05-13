SELECT * FROM blinkitdb.dbo.Blinkit_Data


select count(*) from blinkitdb.dbo.Blinkit_Data

update blinkitdb.dbo.Blinkit_Data
set Item_Fat_Content =
case 
    when Item_Fat_Content in ('LF','low fat') then 'Low Fat'
    when Item_Fat_Content = 'reg' then 'Regular'
    else Item_Fat_Content
end

SELECT DISTINCT(Item_Fat_Content) from blinkitdb.dbo.Blinkit_Data

select cast(sum(sales) /1000000 as decimal(10,2)) as Total_Sales_Millions 
from blinkitdb.dbo.Blinkit_Data

select cast(avg(sales) as decimal(10,0)) as Avg_Sales 
from blinkitdb.dbo.Blinkit_Data

select count(*) as No_of_Items 
from blinkitdb.dbo.Blinkit_Data

select cast(sum(sales) /1000000 as decimal(10,2)) as Total_Sales_Millions 
from blinkitdb.dbo.Blinkit_Data
where Item_Fat_Content = 'Low Fat'

select cast(avg(sales) as decimal(10,2)) as Total_Sales_Millions 
from blinkitdb.dbo.Blinkit_Data
where Outlet_Establishment_Year = 2022

select cast(sum(sales) /1000000 as decimal(10,2)) as total_sales_million 
from blinkitdb.dbo.Blinkit_Data
where Outlet_Establishment_Year = 2022

select count(*) as No_of_Items 
from blinkitdb.dbo.Blinkit_Data
where Outlet_Establishment_Year = 2022

select cast(avg(rating) as decimal(10,2)) as Avg_rating 
from blinkitdb.dbo.Blinkit_Data

-- granular requirements 
-- total sales by fat content 
select * from blinkitdb.dbo.Blinkit_Data

-- when using aggregation with a dimension field use group by like sum
select Item_Fat_Content,
    cast(sum(sales) as decimal(10,2)) as total_sales,
    cast(avg(sales) as decimal(10,1)) as Avg_sales,
    count(*) as No_of_times,
    cast(avg(rating) as decimal(10,2)) as Avg_rating
from blinkitdb.dbo.Blinkit_Data 
group by Item_Fat_Content 
order by total_sales desc

select Item_Fat_Content,
    cast(sum(sales) as decimal(10,2)) as total_sales,
    cast(avg(sales) as decimal(10,1)) as Avg_sales,
    count(*) as No_of_times,
    cast(avg(rating) as decimal(10,2)) as Avg_rating
from blinkitdb.dbo.Blinkit_Data 
where Outlet_Establishment_Year = 2020
group by Item_Fat_Content 
order by total_sales desc

-- total sales by item type 
select top 6 Item_Type,
    cast(sum(sales) as decimal(10,2)) as total_sales,
    cast(avg(sales) as decimal(10,1)) as Avg_sales,
    count(*) as No_of_times,
    cast(avg(rating) as decimal(10,2)) as Avg_rating
from blinkitdb.dbo.Blinkit_Data 
group by Item_Type 
order by total_sales asc

-- fat content by outlet for total sales
select Outlet_Location_Type, Item_Fat_Content,
    cast(sum(sales) as decimal(10,2)) as total_sales,
    cast(avg(sales) as decimal(10,1)) as Avg_sales,
    count(*) as No_of_times,
    cast(avg(rating) as decimal(10,2)) as Avg_rating
from blinkitdb.dbo.Blinkit_Data 
group by Outlet_Location_Type, Item_Fat_Content 
order by total_sales asc

select Outlet_Location_Type, Item_Fat_Content,
    cast(sum(sales) as decimal(10,2)) as total_sales
from blinkitdb.dbo.Blinkit_Data 
group by Outlet_Location_Type, Item_Fat_Content 
order by total_sales asc

SELECT Outlet_Location_Type,
       ISNULL([Low Fat], 0) AS Low_Fat,
       ISNULL([Regular], 0) AS Regular
FROM
(
    SELECT Outlet_Location_Type, Item_Fat_Content,
           CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkitdb.dbo.Blinkit_Data
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT
(
    SUM(Total_Sales)
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;

-- total sales by outlet establishment year
select Outlet_Establishment_Year,
    cast(sum(sales) as decimal(10,2)) as total_sales,
    cast(avg(sales) as decimal(10,1)) as Avg_sales,
    count(*) as No_of_times,
    cast(avg(rating) as decimal(10,2)) as Avg_rating
from blinkitdb.dbo.Blinkit_Data 
group by Outlet_Establishment_Year 
order by total_sales desc

-- percentage of sales by outlet size 

SELECT
    Outlet_Size,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkitdb.dbo.Blinkit_Data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

-- sales by outlet location 
select Outlet_Location_Type,
    cast(sum(sales) as decimal(10,2)) as total_sales,
	 CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
    cast(avg(sales) as decimal(10,1)) as Avg_sales,
    count(*) as No_of_times,
    cast(avg(rating) as decimal(10,2)) as Avg_rating
from blinkitdb.dbo.Blinkit_Data 
group by Outlet_Location_Type 
order by total_sales desc

-- all metrics by outlet type
select Outlet_Type,
    cast(sum(sales) as decimal(10,2)) as total_sales,
	 CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
    cast(avg(sales) as decimal(10,1)) as Avg_sales,
    count(*) as No_of_times,
    cast(avg(rating) as decimal(10,2)) as Avg_rating
from blinkitdb.dbo.Blinkit_Data 
group by Outlet_Type 
order by total_sales desc
