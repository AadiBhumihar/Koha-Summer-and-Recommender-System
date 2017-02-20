package low_rank;

## This is a low_rank  package file Which contain :
 
## 1: matrix_fac routine for Matrix - Factorization

## 2: Matrix_Transpose routine for transposing matrix 

## 3: Matrix_Multiplication routine for Multiplication of two matrix 

## 4: user_sim  routine for finding similarity between two user



use Exporter ;
use Array::Utils qw(:all);

     #### Base Class  of module ####
@ISA = qw(Exporter);

     #### Exporting the matrix_fac and Matrix_Multiplication Method####

@EXPORT = qw(matrix_fac 
                         Matrix_Multiplication
                         user_sim) ;

     #### Exporting the Matrix_Transpose Method on demand ####

@EXPORT_OK = qw(Matrix_Transpose) ;



  #### Function for Low_Rank_Matrix_Factorisation ####
sub  matrix_fac {
			  			       #### Value Intilization ####
      my ($user_item_ref , $user_f_ref , $item_f_ref , $l_rank_ref ) = @_;
   
        my @user_item = @$user_item_ref ;
		  my @user_f =  @$user_f_ref ;
        my  @item = @$item_f_ref ;
		  my  $l_rank = $$l_rank_ref ;
		  my $steps  = 10000;
        my $alpha = 0.0002 ;      ## determines the rate of approaching the minimum. 
        my $beta = 0.02 ;           ## control the magnitudes of the user-f and item-f vectors
        my $count ;
        my $sigma ;
        my $min_err ;

   ### Transpose Function Call ####
		 my @item_f = Matrix_Transpose(@item);

   #### Function Part To Calculate low_rank matrix ####
      for(my $indx = 0; $indx<$steps ; $indx++)	{
           $count++;
			  for(my $i =0; $i< scalar @user_item; $i++) 			{

				  for(my $j =0; $j< scalar @{$user_item[$i]}; $j++) 			{

						if($user_item[$i][$j] >0)    {
                        $sigma = 0;
                        for(my $z =0;$z<$l_rank ;$z++)		{
                                  $sigma = $sigma + $user_f[$i][$z]* $item_f[$z][$j] ;    
                         }
							   $err = $user_item[$i][$j] - 	$sigma ;		
		      ## using gradient approch to find minimum 
 							 for(my $k =0; $k< $l_rank; $k++)  {
									 $user_f[$i][$k] = $user_f[$i][$k] + $alpha * ((2 * $err * $item_f[$k][$j]) - ($beta * $user_f[$i][$k])) ;
	                         $item_f[$k][$j] = $item_f[$k][$j] + $alpha * ((2 * $err * $user_f[$i][$k]) - ($beta * $item_f[$k][$j]))
                      }

                  }    
              }
          }

 #### Function Part To Calculate and Minimize Error ####
           $min_err = 0 ;

			  for(my $i =0; $i< scalar @user_item; $i++) 			{

				  for(my $j =0; $j< scalar @{$user_item[$i]}; $j++) 			{

						if($user_item[$i][$j] >0)    {
                        $sigma = 0;
                        for(my $z =0;$z<$l_rank ;$z++)		{
                                $sigma = $sigma + $user_f[$i][$z]* $item_f[$z][$j] ;
							   }
							  $min_er =  ($user_item[$i][$j] - 	$sigma) ** 2 ;	
                       $min_err = $min_er ;		
                        ## calculating min-error by using beta to avoid overfitting	   
 							 for(my $k =0; $k< $l_rank; $k++)  { 
                          $min_err = $min_err + ($beta/2) *( ($user_f[$i][$k] ** 2 )+ ($item_f[$k][$j] ** 2 )) ;  }
                      }
                       $min_err = sqrt($min_err);
              }   
     }
             if($min_err < 0.001)      
              { last; }

     }
           return \@user_f , \@item_f ;

}

		####Transpose Function####

	sub Matrix_Transpose {
		  			       #### Value Intilization ####

		 my @sample_matrix = @_ ;
		 my  @tra_matrix ;

		for (my $i =0 ;$i < @{$sample_matrix[0]} ; $i++)  {
				for (my $j = 0 ; $j < @sample_matrix; $j++)	  		{
				             $tra_matrix[$i][$j]  = $sample_matrix[$j][$i]  ;  ## Swapping Matrix element 

		      }
		}            
		  return @tra_matrix;                         ## Returning transpose matrix
	 }

#### Matrix Multiplication #### 

  sub Matrix_Multiplication {
			  			       #### Value Intilization ####

   my ($matrix1 , $matrix2) = @_ ;
   my @m_matrix1 = @$matrix1 ;
   my @m_matrix2 = @$matrix2 ;
	my @mul_matrix ;
	my $mul ;

	  	for(my $i = 0 ;$i<scalar @m_matrix1 ;$i++)  {
		    for(my $j = 0 ;$j<scalar @{$m_matrix2[0]} ;$j++)		{ 
		        $mul = 0;
		       for(my $z = 0 ;$z<scalar @{$m_matrix1[0]} ;$z++)		{
		                   $mul = $mul + $m_matrix1[$i][$z] * $m_matrix2[$z][$j] ;    ## Multiplication of each element by row * coloumn rule  
		       }
		             $mul_matrix[$i][$j]  =  $mul ;           
		    }

	  }

      return  @mul_matrix ;      ## Returning multiplied matrix
  }

#### User_Similarity Function #### 

  sub user_sim{
			  			       #### Value Intilization ####

   my ($user_r , $r_matrix_r) = @_ ;
   my $user = $$user_r ;
   my @r_matrix = @$r_matrix_r ;

   my $user_s = @r_matrix;
   my $item_s = @{$r_matrix[0]} ; 
   my @mean_r ;
    my @sim_m ;


#### Function Part To Calculate mean rating ####
      for(my $i = 0 ;$i<$user_s ;$i++)    {
                 my $r_sum = 0;
                 for(my $j = 0 ;$j<$item_s ;$j++)    {
                       $r_sum = $r_sum +  $r_matrix[$i][$j] ;     ## calculating total rating of each user ##         
                 }
                   $mean_r[$i] =  $r_sum/$item_s ;                 ## calculating mean rating of each user ##
         }

   
#### Function Part To Calculate Similarity between users ###          
                  my $r_diff_0 = 0 ;
                  my  $r_mod_0 = 0 ;
						my  $r_mod_i  = 0 ;

  
      for(my $i = 0 ;$i<$user_s ;$i++)    {
                   $r_diff_0 = 0 ;
                    $r_mod_0 = 0 ;
						  $r_mod_i  = 0 ;
                 for(my $j = 0 ;$j<$item_s ;$j++)    {    

                       ##dot product = ( r[s_user][j] - mean_r	[s_user] ).( r[i][j] - mean_r[i] ) ^ 2 for all item(j) and for all user(i)

                      $r_diff_0 = $r_diff_0 + ( $r_matrix[$user][$j] - $mean_r[$user]) * ( $r_matrix[$i][$j] -$mean_r[$i]) ;   
                      $r_mod_0 = $r_mod_0 + ( ($r_matrix[$user][$j] - $mean_r[$user] ) ** 2)  ;    ## square of Mode of Specific uesr  on 
                                                                                                                                  ## sum  ( r[s_user][j] - mean_r	[s_user] ) ^ 2 for all item(j)
                      $r_mod_i = $r_mod_i + ( ($r_matrix[$i][$j] - $mean_r[$i] ) ** 2)  ;          ## square of Mode of each uesr
                  }                                                                                                         ## sum  ( r[i][j] - mean_r[i] ) ^ 2 for all item(j) and for all user(i)
                    $r_mod_0 = sqrt($r_mod_0);            ## Mode of Specific uesr
						  $r_mod_i  = sqrt($r_mod_i );           ## Mode of each uesr
                    $sim_m[$i] = abs($r_diff_0)/ ($r_mod_0 * $r_mod_i);     ## sim(u_specific , u[i]) =  dot product / ( |r_Specific uesr| . |r_each uesr| )
         }

        return @sim_m  ;             ## returning similarity vector 

  }

 

1;
