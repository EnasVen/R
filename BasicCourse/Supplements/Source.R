# Source Example #
test.func = function(x){
  if(is.vector(x)==TRUE && all(is.numeric(x)==TRUE)){
    return(mean(x))
  }else{
    print('Error! Not a vector!')
  }
}
