cluster_carac_quali <- 
  function( dtf , classc , alpha = 0.05 , neg = TRUE , wt = NULL, na_class = FALSE , na_categ = FALSE, extra_info = TRUE  ){  
    
    require( tidyverse )
    
    if (!is.null(wt)) {
      stopifnot(length(wt) == nrow(dtf))
    }
    wt_vec <- if (is.null(wt)) rep(1, nrow(dtf)) else wt

    lFclass <- levels( classc )
    v_lim <- qnorm(1 - alpha/2)

    # nj Category size
    # nk Class size
    # njk Category and class size
        
    dq <- unclass( dtf ) %>%
       map( ~ tibble( category = .x , classc = classc , wt_col = wt_vec ) %>% 
              count( category , classc , wt = wt_col , name = "njk" , .drop = FALSE )
          ) %>% 
       plyr::ldply( as_tibble ) %>% 
      rename( variable = .id )

    if( !na_categ ){ dq <- dq |> filter( !is.na(category) ) }  
    if( !na_class ){ dq <- dq |> filter( !is.na(classc  ) ) }  
      
    dq <- dq %>%
      group_by( variable , classc ) %>%
      mutate( nk = sum(njk) ) %>%
      group_by( variable , category ) %>%
      mutate( nj = sum(njk) ) %>%
      group_by( variable  ) %>%
      mutate( n = sum(njk) ,
              clas_mod = njk/nj ,
              mod_clas = njk/nk ,
              Global   = nj/n   ,
              p_value  = ifelse( mod_clas >= Global , phyper(njk - 1, nj, n - nj, nk, lower.tail = FALSE) , phyper( njk , nj , n-nj , nk ) )  ,
              V_test   = ifelse( mod_clas >= Global , qnorm(p_value/2, lower.tail = FALSE) , qnorm(p_value/2) ) ) %>%
      ungroup()


    dqr <-  dq %>%
      transmute( class = classc    , variable , category ,
                 staistic = V_test, p_value = p_value,
                 clas_cat = clas_mod , cat_clas = mod_clas , global = Global , n = n , nj = nj , nk , njk ) %>%
      arrange( class , desc( test_value )  ) %>%
      filter( abs(test_value) >= v_lim )

    if( !extra_info ){
      dqr <- dqr |> rename(Weight = nj) |> select(-nk,-njk,-n)
    } 
    
    return(dqr)
    
}
  
