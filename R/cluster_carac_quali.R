
cluster_carac_quali <- 
  function( dtf , classc , v_lim = 2 , neg = TRUE , na_class = FALSE , na_cat = FALSE ){  
    
    require( tidyverse )
    
    lFclass <- levels( classc )
    
    # nj Category size
    # nk Class size
    # njk Category and class size
        
    dq <- unclass( dtf ) %>%
       map( ~ tibble( category = .x , classc = classc ) %>% 
              # mutate( category = as.character(category) ,
              #         classc   = as.character(classc  ) ,
              #       ) %>% 
              count( category , classc , name = "njk" , .drop = FALSE )
          ) %>% 
       plyr::ldply( as_tibble ) %>% 
       rename( variable = .id ) %>% 
       # filter( !( is.na(classc) | is.na(category)  ) )  %>%
      group_by( variable , classc ) %>%
      mutate( nk = sum(njk) ) %>%
      group_by( variable , category ) %>%
      mutate( nj = sum(njk) ) %>%
      group_by( variable  ) %>%
      mutate( n = sum(njk) ,
              clas_mod = njk/nj ,
              mod_clas = njk/nk ,
              Global   = nj/n   ,
              prob     = ifelse( mod_clas >= Global , phyper(njk - 1, nj, n - nj, nk, lower.tail = FALSE) , phyper( njk , nj , n-nj , nk ) )  ,
              V_test   = ifelse( mod_clas >= Global , qnorm(prob/2, lower.tail = FALSE) , qnorm(prob/2) ) ) %>%
      ungroup()


    dqr <-  dq %>%
      transmute( class = classc    , variable , category ,
                 test_value = V_test, p_value = prob,
                 clas_cat = clas_mod , cat_clas = mod_clas , global = Global , Weight = nj ) %>%
      arrange( class , desc( test_value )  ) %>%
      filter( abs(test_value) >= v_lim )

    return(dqr)
    
}
  