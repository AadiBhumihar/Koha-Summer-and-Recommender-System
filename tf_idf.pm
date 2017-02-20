package tf_idf ;


 ## tf_idf.pm is a package file which contains functions listed below:

 ## 1:To calculate Tf-score based on that 
 
  ## 2:To calculate Idf-score of each word based on that 

  ## 3:To calculate Tf-Idf-score of each word 
 
 ## 4: To find Similarity between Documents 



use Exporter ;
use Array::Utils qw(:all);

     #### Base Class  of module ####
@ISA = qw(Exporter);

     #### Exporting the  Method####

@EXPORT = qw(doc_tf
                         doc_idf
                          doc_tf_idf
                          doc_sim
                         similar_doc) ;


  #### Function to find TF Score####
	sub  doc_tf {
			       #### Value Intilization ####
				my %tf_score = {};
				my ($ws_ref, $wa_ref, $wh_ref) = @_;

		 		my $ws_val = $$ws_ref;	
				my @wa_val = @$wa_ref;	
				my %wh_val = %$wh_ref;	
		
   #### Finding IDF Score####
  
		foreach my $word (@wa_val)  {
				my $count = $wh_val{$word};      ### Finding how many times words are found 
				my $tf_val = $count/$ws_val;      #### Tf = No. of occurence of word / total no. of words in document   ####

				$tf_score{$word} = $tf_val;         ##   Tf-Idf hash formation ##

	  }
				return %tf_score;                        ### Returning Idf-Idf hash array ###
		     }

     ####Function to Find IDF Score####

  sub  doc_idf {
		
       #### Value Intilization ####	
		my %idf_score = {};
		my $count ;
		my $idf_val  ;
		my ($dn_ref, $wa_ref, $wh_ref) = @_;

 		my $dn_val = $$dn_ref;	
		my @wa_val = @$wa_ref;	
		my @wh_val = @$wh_ref;	
     
   #### Finding IDF Score####

     foreach my $word (@wa_val)    {
		   $count = 0;
			$idf_val = 0;
			for(my $i=0;$i<$dn_val;$i++)		{
         	  if ( $wh_val[$i]->{$word} )           ## Finding in how many doc. words are found ##
								{	 $count ++;   }     
  }

	   $idf_val = log($dn_val/$count);      ##       idf =  log of (total no. of document / no. of document contain that word) ;
      $idf_score{$word} = $idf_val;          ##   Idf-Idf hash formation ##

    }

  			return %idf_score;      ### Returning Idf-Idf hash array ###
 				}

     ####Function to Find TF-IDF Score####

  sub  doc_tf_idf {
	
       #### Value Intilization ####		
		my %tf_idf_score = {};
		my $tf_idf_val  ;
		my ($wa_ref, $tf_ref, $idf_ref) = @_;

 		my @wa_val = @$wa_ref;	
		my %tf_val = %$tf_ref;	
		my %idf_val = %$idf_ref;	


   #### Finding TF-IDF Score####

     foreach my $word (@wa_val)    {      
            if($word =~ /Null/i || $word =~ /Null/i )    {              ## Searching Null value case insensitive ###
                         $tf_idf_score{$word} = 0;                        ## Here we give some stop words tf-idf value = 0
             } else {             
			          $tf_idf_val = $tf_val {$word}* $idf_val{$word};      ##      Tf-Idf = tf*idf ;   ##

                    $tf_idf_score{$word} = $tf_idf_val;                     ##   Tf-Idf hash formation ##
               }
      }
     return  %tf_idf_score ;                       ### Returning Tf-Idf hash array ###
 				}

     ####Function to Find Similarity Between Documents####

  sub  doc_sim {

       #### Value Intilization ####
            my ($query_ref , $tf_idf_ref , $word_array_ref ) = @_ ;
    			my @word_array_val = @$word_array_ref ;
				my @query_array_val = @$query_ref;
				my @tf_idf_val = @$tf_idf_ref ;
            my @sim_d ;

    ### query hash intilization ###
            my %quey_score = map{$_=>0}@word_array_val ;
				
      ### query hash value intilization ###  
				foreach my $word (@query_array_val) 
                     { $quey_score{$word}++; } 

    ### Finding Mod of query hash vector ###  
				my $mod  = 0 ;
				foreach my $word (@query_array_val)      {
                       $mod = $mod + $quey_score{$word} ** 2 ;
            }
   
            my $mod_q = sqrt($mod);

    ###  Finding Similarity Based on Cosine Rule ####
				for(my $i =0; $i<@tf_idf_val; $i++)  {
                  my $mod  = 0 ;
						my $dot_pro = 0 ;
                  foreach my $word (@word_array_val)		{
                      $mod = $mod + $tf_idf_val[$i]->{$word} ** 2 ;        ### Finding Mod of query hash vector ###  
							  $dot_pro = $dot_pro + $tf_idf_val[$i]->{$word}*$quey_score{$word} ;      ### Finding Mod of query hash vector and 
                                                                                                                               ### tf-idf score vector 
                  }  
						my $mod_d = sqrt($mod);                                    ### Finding sqrt of Mod of query hash vector ###  
                  $sim_d[$i] = $dot_pro / ($mod_q * $mod_d) ;        ###  Finding Similarity Based on 
                                                                                           ####   sim(a,b) = (a.b)/(|a|.|b|)
           }
           
         return @sim_d ;                                ### Returning similarity vector array
 	}



  1;
