# Postgres Windows Functions


Using our sample registered voter dataset, let's use windows functions to describe voter distribution (by streets) in a district.

Let's use a CTE 

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
    SELECT ROW_NUMBER() OVER (ORDER BY s.num_of_voters DESC, s.street) AS rank,                            
           s.street,                                                                                                     
           s.num_of_voters,                                                                              
           SUM(s.total_voters) OVER (ORDER BY s.num_of_voters DESC, s.street) AS running_count,       
           ROUND ((((s.total_voters) / sum(s.num_of_voters) OVER ()) * (100)), 2) AS pct_voters
    FROM stg s                                                                                                        
)                                                                                                                           
  SELECT a.rank,                                                                                                              
     a.street,                                                                                                                 
     a.num_of_voters,                                                                                                          
     a.running_count,                                                                                                          
     a.pct_voters,                                                                                                             
     sum(running.pct_voters) OVER (ORDER BY running.pct_voters DESC, running.street) AS running_pct                                  
    FROM agg a;

```

