#!/usr/bin/perl

## This is recommender system file based on low_rank
## In this user give a query  of his id  
## By extracting data of rating of book by user from table book_tranction from library Database
## We find similarity with other user 
## And recommend item based on similarity with other user 
## This is Collaborative Based
## For this i have created a database of library 
## Having book_detail , user_detail and book_tranction table


use strict;
use DBI;
use low_rank ;

       #### DataBase Intilization ####

		my $driver = "mysql";
		my $database = "library";
		my $dsn = "DBI:$driver:database=$database";
		my $userid = "root";
		my $password = "adityaraj";

       ####DataBase Connection ####

     my $dbh = DBI->connect($dsn , $userid ,$password)  or die $DBI::errstr;

      ###Database User-Data Read Operation#####

     my $sth = $dbh->prepare("SELECT   DISTINCT u_id FROM l_data ");
     $sth->execute() or die $DBI::errstr;                                               ### Database Binding ####

		my $count = 0;
		my @u_data = ();
		while (my @row  = $sth->fetchrow_array()) {
					 $u_data[$count]=  $row[0] ;                                             #### Extracting User data ####
				   $count++;
		}

      ###Database Book-Data Read Operation#####

      my $sth = $dbh->prepare("SELECT   DISTINCT b_id FROM l_data ");
      $sth->execute() or die $DBI::errstr;                                                  ### Database Binding ####        

		my $count = 0;
		my @b_data = ();
		while (my @row  = $sth->fetchrow_array()) {
					 $b_data[$count]=  $row[0] ;                                                #### Extracting book_item data ####
				   $count++;
		}

      #### Database User-Book Rating Read Operation ####
      #### User-Item Rating Matrix Formation #####

 	for(my $i=0 ; $i< scalar @u_data ; $i++)	{
        	for(my $j=0 ; $j< scalar @b_data ; $j++)	{

                my $user_id = $u_data[$i];                     ## Intilization of user id ##
                my $book_id =  $b_data[$j] ;                  ## Intilization of user id ##

                my $sth = $dbh->prepare("SELECT   b_rating  FROM l_data WHERE u_id= ? AND b_id = ? ");
                 $sth->execute($user_id , $book_id) or die $DBI::errstr;                 ### Database Binding of user_id and book_id #### 
                 my $rating  = $sth->fetchrow_array() ;

                if($rating)	{
                        $r_data[$i][$j] =  $rating ;
                } else {                                                      ## User-Item Rating Matrix value intilization ##
                        $r_data[$i][$j] =  0  ;
                   }
         }

    }

      #### Database Connection close operation ####
				
             $sth->finish();

     #### Printing Original User-Item Rating Matrix  ####
     
   print "\n\t####Original User-Item Rating Matrix  ####\t\n";
 	for(my $i=0 ; $i< scalar @u_data ; $i++)	{
        	for(my $j=0 ; $j< scalar @b_data ; $j++)	{
                  print "[$r_data[$i][$j]]\t";
          }
             print "\n";
    }
   
           	my (@m1 , @m2 );
            my $low_rank = 2 ;

 ### Calculating low_rank aproxmiation matrix
     for(my $j = 0 ;$j<$low_rank ;$j++)		{
	       for(my $i = 0 ;$i<$size ;$i++)          {
           	 for(my $k = 0 ;$k<scalar @{$user_item[0]} ;$k++)  {
                    $m1[$i][$j] = rand(1);                           ## Assigning random values to low_rank aproxmiation matrix
				        $m2[$k][$j] = rand(1);
             }
        }
     }

   ## calling matrix factorisation function ##
    my ($user_f_array , $item_f_array) = matrix_fac(\@user_item , \@m1 , \@m2 , \$low_rank) ;
         
   my @user_array = @$user_f_array ;
   my @item_array = @$item_f_array ;

   ## calling matrix multiplication function ##
   my @user_item = Matrix_Multiplication(\@user_array , \@item_array) ;

  #### Printing New Approxmiation 
   print "### Approx Matrix ####\n";

     	for(my $i = 0 ;$i<scalar @user_item ;$i++)  {
       for(my $j = 0 ;$j<scalar @{$user_item[0]} ;$j++)		{
    print "[$user_item[$i][$j]]\t";

        }
print "\n";
   }
        print "Enter User Id:\n";
        my  $user = <STDIN> ;
      
   ## calling user-similarity function ##
        my @sim = user_sim(\$user , \@user_item) ;
      
       ### Printing Simlarity with other User ###
       print "\n\t### Simlarity with other User ###\t\n";
            	for(my $i = 0 ;$i<scalar @user_item ;$i++)  {
                           print "Similarity of user[$i] is :[$sim[$i]]\n"; 
                 }


