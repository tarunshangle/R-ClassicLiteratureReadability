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
You can also click on the `Packages` tab in the bottom right of `RStudio` to verify the install process was successful. 

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
In this module we'll create a visualization that presents data about Charles Dickens' literary works.

The data set provided for this module is separated into two main csv files. One called `titles.csv` and the other called `stats.csv`.

Each file was created using data compiled from Project Gutenberg. There is a common column between the data sets, the Project Gutenberg eBook `id`, which we will use to join the two csv files together.

We will filter this data to only include Dickens' work and then plot it using the ggplot2 package.

We will use the tidyverse collection of packages. For more on the tidyverse and it's opinionated design philosophy, grammar, and data structures see [Tidyverse](https://www.tidyverse.org/).

First Task
---
Open the file called `reading.R` that is located in the root folder of the project. We will be working in this file for the duration of this module.

In our plot for this module we would like to show certain statistics about the top ten download authors. We will prepare the data and create this plot in a new file.

Open the file called `reading.R`.
Since we are in a new file we need access to the `books` DataFrame in `data.R`. Use the `source()` function to import the `data.R` file.
Pipe the `books` DataFrame to the `arrange()` function.
Pass the `arrange()` function a call to the `desc()` function.
Pass the `downloads` column to `desc()` to order by `downloads` descending.
Save the resulting DataFrame as `books`.

## 2.2 - Select Relevant Variables
Still in `reading.R`, refine the columns of the `books` DataFrame with a pipe and `select()` function. 
We only want the columns: `author`, `title`, `words`, `syllables`, and `sentences`. 
The resulting DataFrame should be called `books`.

## 2.3 - Top Ten Authors

We need to pull out the authors of the top ten downloaded books.

Pipe the `books` DataFrame to the `head()` function, we only want the first 10 rows.
Pipe `head()` to the `pull()` function.
Pass the `author` column to `pull()` to order convert the data to a list. 
Save the resulting list as `top_ten_authors`.

## 2.4 - Filtering by the Top Ten Author

With the top ten authors stored in `top_ten_authors` we can find all books by these authors.

Pipe the `books` DataFrame to the `filter()` function.
Pass the construct `author %in% top_ten_authors` to `filter()`.
Pipe the result to `arrange()` to order by author.
Save the resulting list as `authors_books`.

## 2.5 - Adding a Flesch Reading Ease Variable

We can not calculate the readability of the top ten authors using the Flesch Reading Ease formula.
Which is: `206.835 - 1.015 * (words / sentences) - 84.6 * (syllables / words)`.

Pipe the `authors_books` DataFrame to the `mutate()` function.
Pass the `mutate()` function the keyword argument `flesch_reading_ease` set equal to the formula above.
Save the resulting list as `reading`.

## 2.6 - Adding a Flesch Reading Grade Level Variable

Just for good measure let's also calculate the Flesch/Kincaid Grade Level.
The formula is: `0.39 * (words / sentences) + 11.8 * (syllables / words) - 15.59`.

Pipe the `reading` DataFrame to the `mutate()` function.
Pass the `mutate()` function the keyword argument `flesch_kincaid_grade_level` set equal to the formula above.
Save the resulting list as `reading`.

## 2.7 - Grouping by Author

To prep the data for plotting, group the `reading` DataFrame by author using the `group_by()` function.
Save the resulting DataFrame as `reading`.

## 2.8 - Summarising Reading Statistics

The results of the `group_by()` function are not immediately apparent if we view the DataFrame.
We need to use the `summarise()` function to make calculations.

Pipe the `reading` DataFrame to the `summarise()` function.
Pass the `summarise()` function the keyword argument `flesch_reading_ease` set equal to the `mean()` of the `flesch_reading_ease` column.
Pass the `summarise()` function a second keyword argument `flesch_kincaid_grade_level` set equal to the `mean()` of the `flesch_kincaid_grade_level` column.
Save the resulting DataFrame as `reading`.

## 2.9 - Reshaping with gather()

Later on we are going to create a faceted bar plot. We need to use `gather()` to reshape the data for that type of plot.

Pipe the `reading` DataFrame to the `gather()` function.
The first two arguments of the `gather()` function are the names of the columns created after reshaping.
The first should be called `type` and the second `score`.
The final argument is the column or columns to reshape. 
Use `flesch_reading_ease:flesch_kincaid_grade_level` to select all columns.
Save this back to `reading`.

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