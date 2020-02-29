library(tensorflow)
library(keras)

install_tensorflow(method = "conda", version = "1.13.2", 
                   envname = "r-deeplearning")

install_tensorflow(method = "conda", version = "1.13.2-gpu", 
                   envname = "r-deeplearning")