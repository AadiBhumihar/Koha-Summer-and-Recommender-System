#!/usr/bin/perl

## This is recommender system file based on Tf-idf
## In this user give a query related to book 
## By extracting data of book and user table from library Database
## We recommend book based on similarity with query
## And recommend book based on similarity with user past book transaction
## This is Content Based
## For this i have created a database of library 
## Having book_detail , user_detail and book_tranction table


use strict;
use DBI;
use Array::Utils qw(:all) ;
use tf_idf ;



   ####  Variable Initilization  #####

          my (@doc_lines ,@doc_i ,@word_array ,@word_hash);
          my ($doc_size ,$i , $j);

          my @tf_score ;
          my %idf_score ;
          my @tf_idf_score ;
          my (@sim_score ,@b_list);

       ####  Database Variable Initilization  #####

				my $driver = "mysql";
				my $database = "library";
				my $dsn = "DBI:$driver:database=$database";
				my $userid = "root";
				my $password = "adityaraj";

					### DataBase Connection  ###
				my $dbh = DBI->connect($dsn , $userid ,$password)  or die $DBI::errstr;

				#### Database Book-data Read operation #####

	my $sth = $dbh->prepare("SELECT DISTINCT  b_title ,b_subtitle
		                                  ,b_author ,b_author1 , b_author2 ,b_sub ,b_sub1
		                                  ,b_sub2 ,b_sub3  FROM l_book  ");

	$sth->execute() or die $DBI::errstr;        ### Database Binding ####

	my $book_count = 0;
	my $b_field = $sth->{NUM_OF_FIELDS} ;         #### No. of fields ####

    #### Storing Database Data into Array ####

	while ( my @b_value = $sth->fetchrow_array()) {
		  for(my $i = 0; $i<$b_field; $i++)   { 
			  if($b_value[$i] =~/./s)   {
		   					$doc_lines[$i][$book_count] = $b_value[$i];   
			  } else  { 
		   					$doc_lines[$i][$book_count] = "Null";   
		       }

		   }
		       $book_count++ ;

	} 

         $doc_size =  $book_count  ;

	   ####  Value Initilization  #####

	my $j = 0;
	 while ($j != $book_count)  {
		       my @split_a ;
		 		for(my $i = 0; $i<$b_field; $i++)   {
		                my $word = $doc_lines[$i][$j];
		                $word = lc($word) ;                     #### Converting all words into Lower_Case for case insensitive ####
		               $split_a[$i] = $word ;
		      }
						   @word_array = unique(@split_a,@word_array);              #### Formation of Array of All Words ####
							my $refer = \@split_a ;
							$doc_i[$j]  =  $refer ;
	 
		        $j++;
		 }

   				##### Sort the Array #####

 				     @word_array = sort(@word_array);

           ##### Word_Hash Initilization #####  
                 
           for (my $i = 0;$i<$book_count;$i++)      {               
              my %sample_hash = map{$_=>0}@word_array ;        
              my $refer =  \%sample_hash ;
              $word_hash[$i] = $refer;                         ##### Word_Hash Formation #####  
               foreach my $word (@{$doc_i[$i]})    {
                           $word_hash[$i]{$word}++;         ##### Word_Hash Key=>Value Initilization #####  
                 }
          }

          #### TF Function Call ####

           for ($i = 0;$i<$doc_size;$i++)      {               
						
                 my %tf_val = doc_tf (\scalar @{$doc_i[$i]} ,  \@word_array , $word_hash[$i]);
                 my $tf_refer = \%tf_val ;
                  $tf_score[$i] = $tf_refer ;          #### Tf-Score Vector ####
          }

          #### IDF Function Call ####

                 %idf_score = doc_idf (\$doc_size ,  \@word_array , \@word_hash);        #### Idf-Score Vector ####

          #### TF_IDF Function Call ####

           for ($i = 0;$i<$doc_size;$i++)      {               		
                 my %tf_idf_val = doc_tf_idf (\@word_array ,  $tf_score[$i] , \%idf_score);
                 my $tf_idf_refer = \%tf_idf_val ;
                  $tf_idf_score[$i] = $tf_idf_refer ;                 #### Tf-Idf Score Vector ####
          }   





          #### User Input Operation ####

	   print "Enter Any Query\n";                      
      my $query_stat = <STDIN> ;             ### Book-query input ####
      $query_stat = lc($query_stat) ;
 
	   print "Enter Any User_id\n";
      my $user_id = <STDIN>;                            ### User-detail input ####
      chomp($user_id);

      my @query = split(' ',$query_stat) ;                   ### Spliting Book-query input into array####
      my @sim_value = doc_sim(\@query , \@tf_idf_score , \@word_array);                     #### Function to find Similarity Call ####
       
      my @sim_book = similar_doc (\@sim_value , \$book_count);                             #### Function to find Similar documents  Call ####

      for(my $i =0; $i<scalar @sim_book ;$i++)    {
             print "Similar_book[$i] : $sim_book[$i]\n";             #### Print Similar books ####
      }

#### Database Operation to extract information of user past book transaction  ####
   my $sth = $dbh->prepare("SELECT   DISTINCT  
                                      b_title ,b_subtitle ,b_author ,b_author1 , b_author2 
                                      ,b_sub ,b_sub1,b_sub2 ,b_sub3   FROM 
                                      l_data JOIN l_book ON (l_book.b_id = l_data.b_id) WHERE u_id = ? ");

       $sth->execute($user_id) or die $DBI::errstr;       ### Database Binding with user_id ####

      #### Value Intilization for Database reading ####   
         my @b_data ;
    		my $j =0;
         my $count =0 ;

    #### Storing Database Data into Array ####

		if($sth->rows)  {
			while ( my @b_value = $sth->fetchrow_array()) {
				    $b_data[$j] = \@b_value ;
				    $count++ ;
				    $j++;
         }
		}  else {print "No user History\n"; }


   #### To form the Query Vector of User Past data 

      my @query1 ;

    for(my $i=0; $i<$sth->rows; $i++)   {
           my $k =0;
           for(my $j =0;$j<$sth->{NUM_OF_FIELDS} ;$j++)    {
                   if($b_data[$i]->[$j] =~/./s)  {
                                $query1[$i][$k] = lc($b_data[$i]->[$j]); $k++; 
                 }
          }
   }

   #### To Find Similar books for query vector ####

      my  @b_list ;
     for(my $i=0; $i<scalar @query1; $i++)    {
	      my @sim_value = doc_sim(\@{$query1[$i]} , \@tf_idf_score , \@word_array);
         my @sim_book = similar_doc (\@sim_value , \$book_count);
         @b_list = unique(@b_list , @sim_book);
     }

   #### To print similar books #### 
    print("\n\n\t#### Other Recommended Books ####\t\n\n");
      for(my $i =0; $i<scalar @b_list ;$i++)    {
             print "Similar_book[$i] : $b_list[$i]\n";
      }


  ####Function to get similar Books #####
   sub similar_doc {
       
     #### Value Intilization ####
      my($sim_value_ref , $doc_size_ref) = @_ ;
      my @sim_value = @$sim_value_ref ;
      my $doc_size = $$doc_size_ref  ;
      my $rb_count = 0;
      my @b_string ;
      my $index ;



           #### sorting the sim_value vector ####
		my @s_sim_value = sort(@sim_value);                                 
  
           for (my $i = 0;$i<$doc_size;$i++)      {                  #### and Filtering the book_list by ####
              						my $val = $s_sim_value[$i]	;	
                  if($val>0)	  {                                              #### by setting thresold value ####
                              $index = $i ;  
                                  last}
         }   

           for (my $i = $doc_size-1; $i>=$index; $i--)      {
						my $val = $s_sim_value[$i]	;	
           			for (my $j = 0; $j<$doc_size; $j++)    {
                        if($val ==$sim_value[$j] )      { 
                                         for (my $k =0; $k<$b_field ;$k++)   {
                                               if($doc_i[$j][$k] =~ /Null/i)  { $doc_i[$j][$k] = '  ' ; }        #### Parsing and choping book_data vector ####
                                         }
 													     $b_string[$rb_count] = join( ' ', @{$doc_i[$j]} );                  #### Transforming book_data vector into String ####
														                                                                                                     # and store it into array #
                                    last }                                                                        
                                     
    
                 }
                      $rb_count++;
          }

         return @b_string;
   }

