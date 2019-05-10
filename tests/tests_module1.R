library(rlang)
library(glue)

setwd('..')

solution <- new.env()
source('tests/solution.R', local = solution)

user_source_file <- 'reading.R'

user <- new.env()
source(user_source_file, local = user)

parsed <- parse_exprs(file(user_source_file))

for (line in parsed) {
  if(line[[1]] == 'plot' && line[[2]] == 'p') {
    plot_call <- TRUE
  }
}

context('Module 01')
test_that('@source-files', {
  expect('titles' %in% ls(envir = user), glue('Does the `titles` data frame exist in `{user_source_file}`?'))
})
test_that('@arrange-by-download', {
})
test_that('@select-columns', {
})
test_that('@top-ten-authors', {
})
test_that('@filter-top-ten-authors', {
})
test_that('@flesch-reading-ease', {
})
test_that('@flesch-kincaid-grade-level', {
})
test_that('@group-by-author', {
})
test_that('@summarising-readability-metrics', {
})
test_that('@reshape', {
})
test_that('@initialize-plot', {
})
test_that('@geom-bar', {
})
test_that('@aes', {
})
test_that('@facet-grid', {
})
test_that('@customize-plot', {
})