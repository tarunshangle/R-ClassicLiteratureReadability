ProjectReporter <- R6::R6Class('ProjectReporter',
  inherit = Reporter,
  public = list(
    results = list(),
    tags = list(),
    n = 0L,
    has_tests = FALSE,
    contexts = NA_character_,

    start_context = function(context) {
      self$contexts[self$n + 1] <- context
    },

    add_result = function(context, test, result) {
      self$has_tests <- TRUE
      tag <- regmatches(test, gregexpr('@(.*)', test))[[1]]
      if (!tag %in% self$tags) {
        self$n <- self$n + 1L
        self$results[[self$n]] <- result
        self$tags[[self$n]] <- tag
      }
    },

    end_reporter = function() {
      if (!self$has_tests) {
        return()
      }
      
      for (i in 1:self$n) {
        if (!is.na(self$contexts[i])) {
          self$cat_line("# ", self$contexts[i])
        }
        result <- self$results[[i]]
        result$test <- gsub('@(.*)', '', result$test)

        if (testthat:::expectation_success(result)) {
          self$cat_line(i, '. ', result$test, crayon::green(' <passed>'))
        } else if (testthat:::expectation_broken(result)) {
          self$cat_line(i, '. ', result$test)
          msg <- gsub('(^|\n)', '\\1  ', format(result))
          self$cat_line(crayon::red('<failed>'), msg)
        } else {
          self$cat_line(i, ' # ', toupper(testthat:::expectation_type(result)), ' ',
            format(result), crayon::green(' <passed>')
          )
        }
      }
    }
  )
)
