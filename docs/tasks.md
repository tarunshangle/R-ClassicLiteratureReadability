# Setup

## Installation

Double-click on the `R-ClassicBooks.Rproj` in the root folder of the project. This will open `RStudio`.

To install the needed R packages for this project run the following command in the R console. 
*Note: Make sure you are in the `R console` and not the `terminal` when running this command.*

```
> packrat::restore()
```

This install process can take some time, when it is finished the prompt will return.
The console will list all of the packages that were installed.
You can also click on the `Packages` tab in the bottom right of `RStudio` to verify that the install process was successful. 

## Verify Setup

In order to verify that everything is setup correctly, run the following command from the `R console` in `RStudio`.

`> .run$tests()`

This should show you the failing tests. This is good! We'll be fixing these tests once we jump into the build step.

Every time you want to check your work locally you can type `.run$tests()` in the `R console`, and it will report the status of every task.

## Previewing Your Work

In order to see your work, you can click the `source` button at the top right of the `RStudio` editor window. Data frames can be viewed in the top right and any plots will show in the bottom right in the `Plots` tab.

# Module 01 - Plotting Popular Authors Reading Statistics

## 2.1 - Arrange Books by Download

Project Overview
-----
In this module we'll create a visualization that presents data about the top authors reading ease.

The data set provided for this module is separated into two main csv files. One called `titles.csv` and the other called `stats.csv`.

Each file was created using data compiled from Project Gutenberg. There is a common column between the data sets, the Project Gutenberg eBook `id`, which we will use to join the two csv files together.

We will filter this data to only include only the works of the top ten authors and then plot it using the ggplot2 package.

We will use the tidyverse collection of packages. For more on the tidyverse and it's opinionated design philosophy, grammar, and data structures see [Tidyverse](https://www.tidyverse.org/).

First Task
---
Open the file called `reading.R` that is located in the root folder of the project. We will be working in this file for the duration of this module.

In our plot for this module we would like to show two reading ease metrics for the authors of the top ten most downloaded books on Project Gutenberg.

Use the `source()` function to import the `data.R` file.

Using functions from the `dplyr` package order the `books` data frame by `download` descending. Save the resulting reordered data frame as books.

## 2.2 - Select Relevant Variables

For this plot we only need the columns used to calculate the two reading ease metrics, which are `author`, `title`, `words`, `syllables`, and `sentences`. Using a pipe `%>%` and the `select()` function refine the columns to those listed. 

The resulting data frame should be called `books`.

## 2.3 - Top Ten Authors

We need a `list` of the authors of the top ten books for our plot.  

Use the `head()` and `pull()` functions to get a `list` of the top ten authors from the `books` data frame.

Save the resulting `list` as `top_ten_authors`.

## 2.4 - Filtering by the Top Ten Author

With the top ten authors stored in `top_ten_authors` we can find all the works by these authors.

Use the construct `%in%` in a `filter()` function to refine the `books` data frame to only contain the works of the authors in the list `top_ten_authors`. Then order the data frame by `author`.

Save the resulting list as `authors_books`.

## 2.5 - Adding a Flesch Reading Ease Variable

We can calculate the readability of the top ten authors using the Flesch Reading Ease formula.
Which is: `206.835 - 1.015 * (words / sentences) - 84.6 * (syllables / words)`.

Use the `mutate()` function to add a column to the `authors_books` data frame. The new column should be called `flesch_reading_ease` and it should be set equal to the formula above.

Save the resulting list as `reading`.

## 2.6 - Adding a Flesch Reading Grade Level Variable

Just for good measure let's also calculate the Flesch/Kincaid Grade Level metric.
The formula is: `0.39 * (words / sentences) + 11.8 * (syllables / words) - 15.59`.

Use the `mutate()` function to add a column to the `authors_books` data frame. The new column should be called `flesch_kincaid_grade_level` and it should be set equal to the formula above.

## 2.7 - Grouping by Author

To  obtain an average for both readability metrics the data frame needs to be grouped by author behind the scenes.

Group the `reading` data frame by author.

Save the resulting data frame as `reading`.

## 2.8 - Summarising Reading Statistics

The results of the `group_by()` function are not immediately apparent if we view the data frame.
We need to use the `summarise()` function to aggregate the data.

Use the `summarise()` and `mean()` functions to calculate the mean for both the `flesch_reading_ease` and `flesch_kincaid_grade_level` columns.

Save the resulting data frame as `reading_summary`.

## 2.9 - Reshaping with gather()

Later on we are going to create a faceted bar plot. We need to use `gather()` to reshape the `reading_summary` data frame for that type of plot.

The `gather()` function requires the that you provide the names for the columns that are created as part of the reshaping process. 

The first column should be `type` and the second should be `score`.

The last argument to the `gather()` function is the column or columns to reshape. Select all columns.

Save this back to `reading_long`.

## 2.10 - Initialize a Plot Object

To construct a plot we will use the core function of the `ggplot2` library, `ggplot()`, which stands for grammar and graphics plot. You can find the relevant documentation here: [`ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html).

Let's add a call to the core `ggplot()` function and save the results to a variable called `p`.

To view the plot in `RStudio`, on a new line call the `plot()` function and pass in `p` as an argument.

## 2.11 - Adding a Component
The call to `ggplot()` creates a plot object, in our case `p`. The call to `ggplot()` is almost always followed by a call to one or more geom functions. Each geom function creates a layer on the plot. 

Add a layer to the plot that has the mappings for a bar plot. This is done by adding the `geom_bar()` function to the `ggplot()` function with the plus operator. **Hint: ggplot() + geom_function()**

The ensure the correct mappings `geom_bar()` requires a `stat`  named argument with a value of `identity`.

## 2.12 - Aesthetic Mappings
Columns in our `reading_long` data frame can be mapped to a layer using the `aes()` function.

Pass the `reading_long` data frame as the first argument to the `ggplot()` function. 
The second argument should be a call to the `aes()` function. 

The following mappings should be passed to the `aes()` function. 

- The x-axis should be the `year`.
- The y-axis should be the `value`.
- The color should be the `type`.

To view the plot click the `Source` button in the upper right of the editor pane.


## 2.10 - Create a Bar Plot

To create the bar plot we will use the `ggplot()` and `geom_bar()` functions.

Pass `reading` as the first argument to `ggplot()`.
As the second argument pass a call to the `aes()` function.
Pass `author` as the first argument (x-axis) and `score` second (y-axis) to the `aes()` function.
Add`(+)` on the `geom_line(stat = 'identity')` function.
Save the plot as `p`.
Show the plot with the `plot()` function.

## 2.11 - Faceting the Bar Plot

The current plot is adding the two different scores `flesch_reading_ease` and `flesch_kincaid_grade_level` together on one plot.
We can use a facet grid to separate out these two score.

Above the call to the `plot()` function, add the function call `facet_grid()` to `p`.
Pass `facet_grid()` the keyword argument `row` set equal to `vars(type)`.
Save this statement back to `p`.  **Hint: plot <- plot + function(argument)**

## 2.12 - Customizing the Plot

There are several ways that we can customize the plot. We are going to do something really simple, but this is just the beginning.

Above the call to the `plot()` function, and after the function call `facet_grid()`, add a call of `theme()` to `p`.
Pass `theme()` the keyword argument `axis.text.x` set equal to a call to `element_text()`.
Pass `element_text()` a keyword argument of `angle` set equal to `45`.
Pass `element_text()` a second keyword argument of `hjust` set equal to `1`.
Save this statement back to `p`.