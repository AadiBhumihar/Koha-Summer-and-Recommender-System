tf_idf.pm is a package file which contains functions listed below:
 1:To calculate Tf-score based on that 
       tf = No. of occurence of word / total no. of words in document ;
 
 2:To calculate Idf-score of each word based on that 
       idf =  log of (total no. of document / no. of document contain that word) ;

 3:To calculate Tf-Idf-score of each word based on that 
       Tf-Idf = tf*idf ;

  Here we give some stop words tf-idf value = 0
 
 4:To find Similarity between Documents based on 
    sim(a,b) = (a.b)/(|a|.|b|)
     where a , b are two document 
      tf-idf vector 

## This is Content Based

 ## for this function to run we have other tf_idf_recommender file 
     in which we form a list of doc. from database by taking book detail 
     and by taking input from user  we recommend item similar to user
     query and past book transction which algo is based on tf-idf 


