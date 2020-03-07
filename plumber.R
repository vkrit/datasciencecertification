# plumber.R

# Read model data.
model.list <- readRDS(file = 'cars-model.rds')

#* @param wt
#* @param qsec
#* @param am
#* @post /predict
CalculatePrediction <- function(wt, qsec, am){
  
  wt %<>% as.numeric
  qsec %<>% as.numeric
  am %<>% as.numeric
  
  X.new <- tibble(wt = wt, qsec = qsec, am = am)
  
  y.pred <- model.list$GetNewPredictions(model = model.list$model.obj, 
                                         transformer = model.list$scaler.obj, 
                                         newdata = X.new)
  
  return(y.pred)
}
