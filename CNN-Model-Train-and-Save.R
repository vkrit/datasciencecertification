install_tensorflow(method = "conda", 
                   envname = "r-deeplearning2")

reticulate::use_condaenv(condaenv="r-deeplearning2", 
                         conda="/Users/kris/anaconda3/bin/conda", 
                         required=TRUE)


library(keras)
library(tensorflow)
mnist <- dataset_mnist()

mnist$train$x <- (mnist$train$x/255) %>% 
  array_reshape(., dim = c(dim(.), 1))

mnist$test$x <- (mnist$test$x/255) %>% 
  array_reshape(., dim = c(dim(.), 1))

model <- keras_model_sequential() %>% 
  layer_conv_2d(filters = 16, kernel_size = c(3,3), activation = "relu") %>% 
  layer_max_pooling_2d(pool_size = c(2,2)) %>% 
  layer_conv_2d(filters = 16, kernel_size = c(3,3), activation = "relu") %>% 
  layer_max_pooling_2d(pool_size = c(2,2)) %>% 
  layer_flatten() %>% 
  layer_dense(units = 128, activation = "relu") %>% 
  layer_dense(units = 10, activation = "softmax")

model %>% 
  compile(
    loss = "sparse_categorical_crossentropy",
    optimizer = "adam",
    metrics = "accuracy"
  )

model %>% 
  fit(
    x = mnist$train$x, y = mnist$train$y,
    batch_size = 32,
    epochs = 5,
    validation_sample = 0.2,
    verbose = 2
  )

model %>% evaluate(x = mnist$test$x, y = mnist$test$y)

save_model_tf(model, "cnn-mnist")


