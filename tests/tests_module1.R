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
test_that('Require the readr package. @readr-package', {
  expect(exists('readr_package'), glue('Have you required the `readr` package in `{user_source_file}` with the `library()` function?'))
})

test_that('Read the titles data. @read-csv-titles', {
  expect('titles' %in% ls(envir = user), glue('Does the `titles` data frame exist in `{user_source_file}`?'))
  expect(isTRUE(all_equal(user$titles, solution$titles)), 'Are you using the `read_csv()` function from the `readr` package to read in the `titles.csv` file?')
})

test_that('Read the stats data. @read-csv-stats', {
  expect('stats' %in% ls(envir = user), glue('Does the `stats` data frame exist in `{user_source_file}`?'))
  expect(isTRUE(all_equal(user$stats, solution$stats)), 'Are you using the `read_csv()` function from the `readr` package to read in the `stats.csv` file?')
})

test_that('Require the dplyr package. @dplyr-package', {
  expect(exists('dplyr_package'), glue('Have you required the `dplyr` package in `{user_source_file}` with the `library()` function?'))
})

test_that('Join titles and stats. @join-titles-stats', {
  expect('books' %in% ls(envir = user), glue('Does the `books` data frame exist in `{user_source_file}`?'))
  expect(isTRUE(all_equal(user$books, solution$books)), 'Are you joining the `titles` and `stats` data frames with `full_join()`?')
})

test_that("Find Dickens' Works @filter-data", {
  expect('dickens' %in% ls(envir = user), glue('Does the `dickens` data frame exist in `{user_source_file}`?'))
  expect(isTRUE(all_equal(user$dickens, solution$dickens)), 'Does the `dickens` data frame only contain his works?')
})

test_that('Refining Columns. @refine-columns', {
  expect('dickens_stats' %in% ls(envir = user), glue('Does the `dickens_stats` data frame exist in `{user_source_file}`?'))
  correct_names <- c("id", "words", "sentences", "to_be_verbs", "contractions", "pauses", "cliches", "similes")
  user_names <- names(user$dickens_stats)
  expect(identical(correct_names, user_names), 'The column names do not match?')
  expect(isTRUE(all_equal(user$dickens_stats, solution$dickens_stats)), 'Does the `dickens_stats` data frame have the correct columns?')
})

test_that('Importing Year Published. @read-csv-published', {
  expect('published' %in% ls(envir = user), glue('Does the `published` data frame exist in `{user_source_file}`?'))
  expect(isTRUE(all_equal(user$published, solution$published)), 'The `published` data frame should have an `id` and a `year` column.')
})

test_that('Joining year published. @join-dickens-published', {
  expect('time' %in% ls(envir = user), glue('Does the `time` data frame exist in `{user_source_file}`?'))
  expect(isTRUE(all_equal(user$time, solution$time)), 'Are you joining the `dickens_stats` and `published` data frames with `full_join()`?')
})

test_that('Require the tidyr package. @tidyr-package', {
  expect(exists('tidyr_package'), glue('Have you required the `tidyr` package in `{user_source_file}` with the `library()` function?'))
})

test_that('Reshaping data frames. @reshape', {
  expect('time_long' %in% ls(envir = user), glue('Does the `time_long` data frame exist in `{user_source_file}`?'))
  expect(isTRUE(all_equal(user$time_long, solution$time_long)), 'Are you using the `gather()` function to reshape the `time` data frame?')
})

test_that('Require the ggplot2 package. @ggplot2-package', {
  expect(exists('ggplot2_package'), glue('Have you required the `ggplot2` package in `{user_source_file}` with the `library()` function?'))
})

test_that('Initialize a Plot Object. @ggplot', {
  expect(exists('simple_ggplot_call'), 'Was the variable `p` set to the result of a call to `ggplot()`')
})

test_that('Adding a Component. @geom-line', {
  expect(exists('geom_line_call'), 'Have you added the correct geom function call to `ggplot()` to create a line plot?')
})

test_that('Aesthetic Mappings. @aes', {
  expect(exists('correct_df'), 'Is the `time_long` data frame passed as the first argument to the `ggplot()` function?')
  expect(exists('aes_call_test'), 'Have you added an `aes()` call to the `ggplot()` function ?')
  expect(exists('aes_x') && isTRUE(aes_x == 'year'), 'Is the `x` mapping in the `aes()` function set to the `year` column?')
  expect(exists('aes_y') && isTRUE(aes_y == 'value'), 'Is the `y` mapping in the `aes()` function set to the `value` column?')
  expect(exists('aes_color') && isTRUE(aes_color == 'type'), 'Is the `color` mapping in the `aes()` function set to the `type` column?')
  expect(exists('plot_call'), 'Have you called the `plot()` function?')
})
