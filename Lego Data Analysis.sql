
-- Key Steps
-- 1. Unique Parts Identification:
-- Identify parts that appear in only one LEGO set. Note the quantity of the part does not matter.
-- Hint: You'll need to use an aggregate function to count the number of distinct sets each part appears in. A part is unique if it appears in exactly one set.


select *
from lego_parts
;
create view uniqueness_by_part as
select 
    lp.name as part_name
    ,lp.part_num
    ,lpc.name as category_name
    , count(distinct li.set_num) as num_of_sets
from lego_parts lp
inner join lego_inventory_parts lip 
on lp.part_num=lip.part_num
inner join lego_inventories li 
on lip.inventory_id=li.id 
inner join lego_sets ls 
on li.set_num=ls.set_num
inner join lego_part_categories lpc 
on lp.part_cat_id=lpc.id
group by lp.part_num, lp.name, lpc.name
order by num_of_sets desc;

;
create view uniqueness_by_part_colour as
select 
    lp.name as part_name
    ,lp.part_num
    ,lpc.name as category_name
    ,lc.rgb
    , count(distinct li.set_num) as num_of_sets
from lego_parts lp
inner join lego_inventory_parts lip 
on lp.part_num=lip.part_num
inner join lego_inventories li 
on lip.inventory_id=li.id 
inner join lego_sets ls 
on li.set_num=ls.set_num
inner join lego_part_categories lpc 
on lp.part_cat_id=lpc.id
inner join lego_colors lc 
on lip.color_id=lc.id
group by lp.part_num, lp.name, lpc.name, lc.rgb --with colour
order by num_of_sets desc;

;
create view uniqueness_by_sets as
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
;


select *
from uniqueness_by_sets;

select *
from uniqueness_by_part;

select *
from uniqueness_by_part_colour;

-- 2. Set Analysis:
-- For each LEGO set, calculate the number of unique parts it includes and the total number of parts (we're looking for a count of the parts, not quantity). Calculate the ratio of unique parts to total parts as a measure of 'uniqueness' for each set. Enrich your query with the set year and theme name.
-- Hint: You can join the unique parts list to the inventory parts table on the part number. Use a LEFT JOIN so that you include all parts, not just the unique ones.

with partnumb as 
(select 
lp.name
,max(lp.part_num) as max_part_num
, count(distinct ls.name) as num_of_sets
from lego_parts lp
inner join lego_inventory_parts lip
on lp.part_num=lip.part_num
inner join lego_inventories li
on lip.inventory_id=li.id
inner join lego_sets ls
on li.set_num=ls.set_num
group by lp.name
order by num_of_sets asc)

, uniqu as
(select *
, 'unique' as uni
from partnumb
where num_of_sets=1)


, most as 
(select 
*
,lp.name as name_of_part
,lp.part_num as number_of_part
,lip.inventory_id as id_invenp
,li.id as id_inven
,li.set_num as set_num_li
,ls.name as name_of_set
,ls.year as years
,lt.name as name_of_theme
from lego_parts lp
inner join lego_inventory_parts lip
on lp.part_num=lip.part_num
inner join lego_inventories li
on lip.inventory_id=li.id
inner join lego_sets ls
on li.set_num=ls.set_num
inner join lego_themes lt
on ls.theme_id=lt.id

)

Select 
m.name_of_set
, max(m.years)
, max(m.name_of_theme)
, count(uni)
, max(m.num_parts)
, count(uni)/max(m.num_parts) as ratio
from most m
left join uniqu u
on m.number_of_part=u.max_part_num
group by m.name_of_set
order by ratio desc
;



select
name_of_set
, count(uni) as number_of_unique
, max(num_parts)
, (number_of_unique/max(num_parts))as ratio
,max(name_of_theme) as theme_of_set
,max(year)
from most m
left join uniqu u
on m.number_of_part=u.max(part_num)
group by name_of_set
order by ratio desc
;

select
*
from most m
left join uniqu u
on m.part_number=u.partnum

;  select *
from lego_inventory_parts lip
inner join lego_parts lp
on lip.part_num=lp.part_num

;


with partnumb as 
(select 
lp.name
,max(lp.part_num) as max_part_num
, count(distinct ls.name) as num_of_sets
from lego_parts lp
inner join lego_inventory_parts lip
on lp.part_num=lip.part_num
inner join lego_inventories li
on lip.inventory_id=li.id
inner join lego_sets ls
on li.set_num=ls.set_num
group by lp.name
order by num_of_sets asc)

select *
, 'unique' as uni
from partnumb
where num_of_sets=1