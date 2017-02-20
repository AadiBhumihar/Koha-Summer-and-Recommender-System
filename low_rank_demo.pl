#!/usr/bin/perl

## This is demo file just to show low_rank matrix factorisation work 

use strict;
use DBI;
use low_rank ;


    ###Intilization####

   my @user_item = ([5,3,0,1] ,[4,0,0,1] ,[1,1,0,5] ,[1,0,0,4] ,[0,1,5,4]) ;
   my $size =  @user_item ; 
	my (@m1 , @m2 );
   my $low_rank = 2 ;


  print "####Original Matrix ###\n";
	for(my $i = 0 ;$i<scalar @user_item ;$i++)  {
       for(my $j = 0 ;$j<scalar @{$user_item[0]} ;$j++)		{
    print "[$user_item[$i][$j]]\t";
        }
print"\n";
   }


     for(my $j = 0 ;$j<$low_rank ;$j++)		{
	       for(my $i = 0 ;$i<$size ;$i++)          {
           	 for(my $k = 0 ;$k<scalar @{$user_item[0]} ;$k++)  {
                    $m1[$i][$j] = rand(1);
				        $m2[$k][$j] = rand(1);
             }
        }
     }


    my ($user_f_array , $item_f_array) = matrix_fac(\@user_item , \@m1 , \@m2 , \$low_rank) ;

   my @u1 = @$user_f_array ;
   my @u2 = @$item_f_array ;

   my @u3 = Matrix_Multiplication(\@u1 , \@u2) ;

   print "### Approx Matrix ####\n";

     	for(my $i = 0 ;$i<scalar @u3 ;$i++)  {
       for(my $j = 0 ;$j<scalar @{$u3[0]} ;$j++)		{
    print "[$u3[$i][$j]]\t";

        }
print "\n";
   }
        my  $user = 0 ;
        my @sim = user_sim(\$user , \@u3) ;
            	for(my $i = 0 ;$i<scalar @u3 ;$i++)  {
                           print "Similarity of user[$i] is :[$sim[$i]]\n"; 
                 }

