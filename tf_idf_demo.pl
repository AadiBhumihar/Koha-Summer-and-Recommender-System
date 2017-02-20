#!/usr/bin/perl


## This is demo file just to show Tf-Idf work 

use strict ;
use Array::Utils qw(:all);
use tf_idf ;


   ####  Variable Initilization  #####

          my $doc_size ;
          my  @doc_i ;
			 my  @word_array ;
          my  ($i , $j);
			 my @word_hash ;
          my @tf_score ;
          my %idf_score ;
          my @tf_idf_score ;
          my @sim_score ;

    ####  Input_File Operation  #####

			open(DATA,"<tf_idf_input.txt") or die "Can't open data";
			my @doc_lines = <DATA>;
			close(DATA);
			
	   ####  Value Initilization  #####

         $doc_size =  @doc_lines  ;
			for($i =0 ; $i < $doc_size ; $i= $i + 1)   {
                   my @split_a = split(' ',$doc_lines[$i]);
				      @word_array = unique(@split_a,@word_array);
						my $refer = \@split_a ;
					   $doc_i[$i]  =  $refer ;
            }

   				##### Sort the Array #####

 				     @word_array = sort(@word_array);

           ##### Word_Hash Initilization #####  
                 
				$i =0;
           for ($i = 0;$i<4;$i++)      {               
              my %sample_hash = map{$_=>0}@word_array ;
              my $refer =  \%sample_hash ;
              $word_hash[$i] = $refer;
               foreach my $word (@{$doc_i[$i]})    {
                           $word_hash[$i]{$word}++;
                 }
          }

          #### TF Function Call ####

           for ($i = 0;$i<$doc_size;$i++)      {               
						
                 my %tf_val = doc_tf (\scalar @{$doc_i[$i]} ,  \@word_array , $word_hash[$i]);
                 my $tf_refer = \%tf_val ;
                  $tf_score[$i] = $tf_refer ;
          }

          #### IDF Function Call ####

                 %idf_score = doc_idf (\$doc_size ,  \@word_array , \@word_hash);

          #### TF_IDF Function Call ####

           for ($i = 0;$i<$doc_size;$i++)      {               		
                 my %tf_idf_val = doc_tf_idf (\@word_array ,  $tf_score[$i] , \%idf_score);
                 my $tf_idf_refer = \%tf_idf_val ;
                  $tf_idf_score[$i] = $tf_idf_refer ;
          }

          #### TF_IDF Value Print ####

           for ($i = 0;$i<4;$i++)      {
                print   "######Value of Tf_Idf_of Doc[$i]#####\n";
                foreach my $word (@word_array)    {
      				     print   "Value of Tf_idf_[$i]{$word} : $tf_idf_score[$i]->{$word}\n" ;
                }

         }                  

          #### Similarity Function Call ####
	   print "Enter Any Query\n";
      my $query_stat = "cat on table" ;
      my @query = split(' ',$query_stat) ;
      my @sim_value = doc_sim(\@query , \@tf_idf_score , \@word_array);
		my @s_sim_value = sort(@sim_value);
           for (my $i = 0;$i<4;$i++)      {
                 #my $max = $sim_value[0]
                print   "######Value of sim_with Doc#####\n";
      				     print   "Value of sim of doc[$i] is  : $sim_value[$i]\n" ;

         }                  
           for (my $i = 3; $i>=0; $i--)      {
						my $val = $s_sim_value[$i]	;		
           			for (my $j = 0; $j<4; $j++)      {
                        if($val ==$sim_value[$j] )  
                                  { 
print "Similar doc : $doc_lines[$j]\n"; 
}   

                     }

               }                  

          
