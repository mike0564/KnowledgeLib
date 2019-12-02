for i in $(ls|grep -v png|grep -v sh)  
   do mv $i $i".png"  
done 