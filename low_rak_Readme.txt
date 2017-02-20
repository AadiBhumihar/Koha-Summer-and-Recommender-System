 ##    Low Rank Matrix  Factorisation ##
      
    In this we have a R = user -item rating matrix of |U| * |I| dimension  in which user rate for each item
         from this we assume that we would like to discover $K$ latent features. 
          Our task, then, is to find two matrics matrices m1 ( |U| *|K| ) and m2 ( |D| *|K|) such that their product approximates
           A new  R_a = user -item rating matrix of |U| * |I| 
                   1: R =~ m1 * m2T = R_a ;
                   2: R_a [i][j] = sum(m1T[i][k] * m2 [k][j]) for all 0<=k <K
                   3: err  ^ 2 = ( R[i][j] - R_a[i][j] ) ^ 2;
                                  = ( R[i][j] - sum(m1T[i][k] * m2 [k][j])for all 0<=k <K ) ^ 2 

        To minimize error we use gradient slope method and differentiate with both i and j each
         And obtained the gradient, we can now formulate the update rules
         Then updated  m1[i][j] and m2[i][j]
 
         m1'[i][j] = m1[i][j] + 2*alpha*err*m2[i][j] ;
         m2'[i][j] = m2[i][j] + 2*alpha*err*m1[i][j] ;

     alpha is a constant whose value determines the rate of approaching the minimum. 


     A common extension to this algorithm is to introduce regularization to avoid overfitting. 
    This is done by adding a parameter beta  squared error as follows:

     err ^2 = ( R[i][j] - sum(m1T[i][k] * m2 [k][j])for all 0<=k <K ) ^ 2  + beta/2 * sum(||m1|| ^2 + ||m2||^2)  for all 0<=k <K

           Then updated  m1[i][j] and m2[i][j]
 
         m1'[i][j] = m1[i][j] + alpha*(2*err*m2[i][j] - beta *m1[i][j]) ;
         m2'[i][j] = m2[i][j] + alpha*(2*err*m1[i][j] - beta *m2[i][j]) ;


 for a number of steps or untill error get too small ;

## This is Collaborative Based

 ## for this function to run we have other recommender_low_rank file 
        in which R is formed by taking user-item rating from Database
      Which Calculate random  low_rank aproxmiation matrix
       and call matrix factorisation function
       and then approxmiate new user_item rating matrix

 ## Then Similarity function method between 2 users which is based on 
     sim(ui , uj) = sum((R_a[i][k] - mean_r[i])*(R_a[j][k] - mean_r[j]))  / |(sum(R_a[i][k] - mean_r[i]))| * |(sum(R_a[j][k] - mean_r[j]))||
                                                     for all 0<=k<|I|
