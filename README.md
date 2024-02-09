# LEGO Visualization Project

A SQL Portfolio challenge, create a schema, analyse data, create a visualisation.

# 🅰️ About

The LEGO Visualization Project aimed to explore and analyze the intricate world of LEGO sets using SQL and Snowflake for data management, analysis, and visualization. Through this project, I delved into the dataset to investigate various aspects of LEGO sets, including unique parts, set compositions, and trends over time.

The LEGO Visualization Project deepened my understanding of LEGO sets and their ecosystem. Analyzing data and creating visualizations highlighted the creativity and diversity of the LEGO brand. This project also enhanced my SQL, data management, and visualization skills, providing valuable tools for future data-driven projects. Overall, it was a fascinating exploration of the intersection between data science and one of the world's most cherished toys!


### Image of my dashboard:
![Lego Dashboard](https://github.com/harveyjoyce/Lego-Viz-Project/assets/158076969/1c940338-bdcb-41bb-ad4a-4adcf890c857)


# 🛢️ Data Sources

# Deliverables:

- 1️⃣ A schema in the TIL_PORTFOLIO_PROJECTS database with tables populated with LEGO data.

- 2️⃣ A SQL script creating the schema, tables, inserting data, and defining primary and foreign keys.

- 3️⃣ A DBeaver ER diagram showing table relationships.

## Created Schema:

I created a schema within the TIL_PORTFOLIO_PROJECTS database.

```
 CREATE schema til_portfolio_projects.harvey_schema;
```
## Created Tables:

I created tables based on existing data: COLORS, INVENTORIES, INVENTORY_PARTS, INVENTORY_SETS, PARTS, PART_CATEGORIES, SETS, THEMES.

```
 CREATE TABLE til_portfolio_projects.harvey_schema.LEGO_INVENTORIES (
	ID NUMBER(38,0),
	VERSION NUMBER(38,0),
	SET_NUM VARCHAR(255)
);
  -- Repeated for other tables
```
## Inserted Data:

I populated tables with data from the corresponding tables in the STAGING schema.

```
  INSERT INTO til_portfolio_projects.harvey_schema.LEGO_INVENTORIES (
SELECT *
FROM  TIL_PORTFOLIO_PROJECTS.STAGING.LEGO_INVENTORIES
);
  -- Repeated for other tables
```
## Set Primary and Foreign Keys:

I defined primary and foreign keys for each table.
```
ALTER TABLE LEGO_INVENTORIES ADD PRIMARY KEY (ID);
ALTER TABLE LEGO_INVENTORIES ADD FOREIGN KEY (SET_NUM) REFERENCES LEGO_SETS(SET_NUM);
  -- Repeated for other tables
```
## Created ER Diagram:

I downloaded DBeaver and created an ER diagram to visualize table relationships.

![Lego Schema DBeaver](https://github.com/harveyjoyce/Lego-Viz-Project/assets/158076969/be47a95e-c564-4201-bebc-fdc1b0fb7c37)



# 🪄 Data Reshape

# Deliverables:

- 1️⃣ Identified Unique Parts: I identified parts that appeared in only one LEGO set.
 ```
select 
    lp.name
    ,lp.part_num
    , count(distinct li.set_num) as num_of_sets
from lego_parts lp
inner join lego_inventory_parts lip 
on lp.part_num=lip.part_num
inner join lego_inventories li 
on lip.inventory_id=li.id 
inner join lego_sets ls 
on li.set_num=ls.set_num
group by lp.part_num, lp.name
having num_of_sets=1

```

- 2️⃣ Analyzed Sets: I calculated the number of unique parts and total parts for each LEGO set. I calculated the ratio of unique parts to total parts.
```
with cte_up as 
(select 
    lp.name
    ,lp.part_num
    , count(distinct li.set_num) as num_of_sets
from lego_parts lp
inner join lego_inventory_parts lip 
on lp.part_num=lip.part_num
inner join lego_inventories li 
on lip.inventory_id=li.id 
inner join lego_sets ls 
on li.set_num=ls.set_num
group by lp.part_num, lp.name
having num_of_sets=1)

select
    ls.name as set_name
    ,ls.year
    ,lt.name as theme
    ,count(up.part_num) as unique_parts
    ,count(lp.name) as parts
    ,count(up.part_num)/count(lp.name) as ratio
from lego_parts lp
inner join lego_inventory_parts lip 
on lp.part_num=lip.part_num
inner join lego_inventories li 
on lip.inventory_id=li.id 
inner join lego_sets ls 
on li.set_num=ls.set_num
inner join lego_part_categories lpc 
on lp.part_cat_id=lpc.id
left join lego_themes lt 
on ls.theme_id=lt.id
left join cte_up up 
on up.part_num=lp.part_num
group by ls.name, ls.year, lt.name
order by ratio desc
```

- 3️⃣ Created a View: I created a view containing set name, year of release, theme, number of unique parts, total number of parts, and uniqueness ratio.
```
create view uniqueness_by_sets as...
```

- 4️⃣ Downloaded Data: I extracted data from the view and saved it locally as a CSV file.


# 📈 Charting in Tableau

# Deliverables:

- 1️⃣ I built a Tableau dashboard to explore unique parts in LEGO sets:

- 2️⃣ I connected to Snowflake and the view created in Part 2.

- 3️⃣ I created three charts exploring unique LEGO parts: Change over time, Compared to the total parts in a set, By set theme.


I also added titles, tooltips and interactions to the visualization. A user is able to filter a particular year or specific uniqueness ratio!

![Lego Dashboard Filtered](https://github.com/harveyjoyce/Lego-Viz-Project/assets/158076969/5aaba7fe-83c6-46c6-b484-9245dc9c7f9f)


# ▶️ Next steps

Some areas that might improve this work could include:

- Incorporating sales data to answer the question "do sets with more unique parts sell better?"
- Incorporating colour data to look at how coloured parts have evolved over time.



By Harvey Joyce
