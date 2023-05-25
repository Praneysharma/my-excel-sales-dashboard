
 
 Q1 -- Who is the senior most employee based on job title?
       select first_name,last_name,title
	   from employee
       where reports_to is null 
	   
ALTERNATIVE 
             select first_name,last_name,title from employee 
		    order by levels desc
		    limit 1
          
ALTERNATIVE
             select e1.title  ,e1.first_name,e1.last_name from employee as e1
             self join employee as e2 
             on e1.employee_id = e2.reports_to
             where e1.reports_to is null;
	 
	 
Q2-- Which country have the most Invoices?
       select count(billing_country) as country,billing_country
       from invoice
       group by billing_country
       order by country desc
       limit 1
Q3-- What are top 3 values of total invoice? 
     select total 
	 from invoice
     order by total desc
     limit 3
	 
ALTERNATIVE

             with cte1 as(
		select invoice.total ,  dense_rank() over(order by total desc) as rnk
			  from invoice
		)
		
		select distinct total
		from cte1 
		where rnk<=3
	    
	 
	 
	 
Q4-- Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals
     select billing_city,sum(total) as invoice_total 
	 from invoice
     group by billing_city
     order by invoice_total desc
Q5-- Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money 
     select c.customer_id,sum(total) as total,first_name,last_name
	 from invoice as i
	 join customer as c
	 on i.customer_id = c.customer_id
	 group by c.customer_id
	 order by total desc 
	 limit 1
Q6-- Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A 	 
	 select distinct email,first_name,last_name,g.name 
	 from customer as c
	 join invoice as i
	 on i.customer_id = c.customer_id
	 join invoice_line as il 
	 on il.invoice_id = i.invoice_id
	 join track as t 
	 on t.track_id = il.track_id
	 join genre as g 
	 on g.genre_id = t.genre_id
	 where g.name like 'Rock'
	 order by email ;
Q7--  Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands 
	  select artist.artist_id,artist.name,count(track.track_id) as no_of_tracks
	  from track join album 
	  on album.album_id = track.album_id
	  join artist 
	  on artist.artist_id = album.artist_id
	  join genre
	  on genre.genre_id = track.genre_id
	  where genre.name like 'Rock'
	  group by artist.artist_id
	  order by no_of_songs desc
	  limit 10;
Q8--   Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first
	   select name , milliseconds 
	   from track 
	   where milliseconds > (
	            select avg(milliseconds) as avg_track_length 
	            from track)
	     order by milliseconds desc;
Q9--   Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent 
		with MUSIC as (
		select artist.artist_id as Artist_id, artist.name as artist_name, 
		sum(il.unit_price*il.quantity) as total_sales
		from invoice_line as il join track
		on track.track_id =il.track_id
		join album on album.album_id = track.album_id
		join artist on artist.artist_id = album.artist_id
		group by 1
		order by total_sales desc
		limit 1
)

	select c.customer_id , c.first_name, c.last_name, MUSIC.artist_name,
	sum(il.unit_price*il.quantity) as Amnt
    from customer as c
	join invoice as i
    on i.customer_id = c.customer_id
	join invoice_line as il 
	on il.invoice_id = i.invoice_id
	join track as t 
	on t.track_id = il.track_id
	join album
	on album.album_id =t.album_id
	join music 
	on music.artist_id = album.artist_id
	group by 1,2,3,4 
	order by amnt desc;

Q10--  We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres
       with cte1 as 
       (
	   select count(il.quantity) as purchase ,customer.country , genre.name as genre_name,
        row_number() over(partition by customer.country order by count(il.quantity) desc) as rowno
	   from invoice_line as il
	   join invoice on invoice.invoice_id = il.invoice_id
	   join customer on customer.customer_id = invoice.customer_id
	   join track on track.track_id = il.track_id
	   join genre on genre.genre_id = track.genre_id
       group by 2,3
	   order by 2, 1 desc 
)
	select * from cte1 
	where rowno <=1
		
ALTERNATIVE
	   with cte1 as (
	   select count(il.quantity) as purchase ,customer.country , genre.name as genre_name,
        dense_rank() over(partition by customer.country order by count(il.quantity) desc) as rnk
	   from invoice_line as il
	   join invoice on invoice.invoice_id = il.invoice_id
	   join customer on customer.customer_id = invoice.customer_id
	   join track on track.track_id = il.track_id
	   join genre on genre.genre_id = track.genre_id
       group by 2,3
	   order by 2, 1 desc 
	   
)
select * from cte1
where rnk<= 1


Q11--  Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount
       with cte1 as (
		 select customer.customer_id,first_name,last_name,billing_country,sum(total) as spending,
		 row_number() over(partition by billing_country order by sum(total) desc) as rowno
		 from invoice 
		 join customer on customer.customer_id = invoice.customer_id
		 group by 1,2,3,4
		 order by billing_country,spending desc
)	 
		   select * from cte1 
		   where rowno<=1
	
	

		  
		  
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	 
	 
	 
	 
	 
	 
	 
	      
	