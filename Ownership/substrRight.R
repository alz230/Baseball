x <- "some text in a string"

substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

substrRight(x, 6)
[1] "string"

substrRight(x, 8)
[1] "a string"