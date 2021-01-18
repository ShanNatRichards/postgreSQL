# Postgres Windows Functions


Using our sample registered voter dataset, let's use windows functions to describe voter distribution (by streets) in a district.
See full code at the end


1. Let's first create a CTE that provides a count of the number of voters per distinct street, which will use in our windows functions

```SQL

WITH stg AS 
(
    SELECT  w.street,
            COUNT(*) AS num_of_voters
    FROM wbw_voters  w
    GROUP BY w.street
),

```

2. Use window function RANK() to rank streets by the number of registered voters per street.
   The ORDER BY clause specifies that ranking should done in descending order on the number of voters and then by the name of street (in case of ties).
   

```SQL

ROW_NUMBER() OVER (ORDER BY s.num_of_voters DESC, s.street) AS rank

```

3. With POSTGRES we can use the aggregrate function SUM as a windows function to get a running sum of voters.
    The ORDER BY clause indicates the order should be in descending order on the number of voters and then by the name of street (in case of ties).

```SQL

SUM(s.num_of_voters) OVER (ORDER BY s.num_of_voters DESC, s.street) AS running_sum_voters    

```
4. We can also get the running total percentage of voters with another SUM windows function

```SQL
SUM(a.pct_voters) OVER (ORDER BY a.pct_voters DESC, a.street) AS running_pct
```

5. See the complete code


```SQL

WITH stg AS 
(
    SELECT  w.street,
            COUNT(*) AS num_of_voters
    FROM wbw_voters  w
    GROUP BY w.street
),

agg AS
(
    SELECT RANK() OVER (ORDER BY s.num_of_voters DESC, s.street) AS rank,
           s.street,
           s.num_of_voters,
           SUM(s.num_of_voters) OVER (ORDER BY s.num_of_voters DESC, s.street) AS running_sum_voters,       
           ROUND ((((s.num_of_voters) / sum(s.num_of_voters) OVER ()) * (100)), 2) AS pct_voters           
    FROM stg s
)

  SELECT a.rank,
     a.street,
     a.num_of_voters,
     a.running_sum_voters,
     a.pct_voters,
     SUM(a.pct_voters) OVER (ORDER BY a.pct_voters DESC, a.street) AS running_pct
    FROM agg a;


```




