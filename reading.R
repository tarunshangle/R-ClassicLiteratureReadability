source('data.R')

books <- books %>%
  arrange(desc(downloads)) %>%
  select(author, title, words, syllables, sentences)

top_ten_authors <- books %>% head(10) %>% pull(author)

authors_books <- books %>% filter(author %in% top_ten_authors) %>% arrange(author)

reading_stats <- authors_books %>% 
  mutate(flesch_reading_ease = 206.835 - 1.015 * (words / sentences) - 84.6 * (syllables / words)) %>%
  mutate(flesch_kincaid_grade_level = 0.39 * (words / sentences) + 11.8 * (syllables / words) - 15.59)

by_author <- reading_stats %>% group_by(author)

reading <- by_author %>% summarise(
  flesch_reading_ease = mean(flesch_reading_ease),
  flesch_kincaid_grade_level = mean(flesch_kincaid_grade_level)
)

reading_long <- reading %>% gather(type, score, flesch_reading_ease:flesch_kincaid_grade_level)

p <- ggplot(reading_long, aes(author, score)) + 
  geom_bar(stat = 'identity') +
  facet_grid(rows = vars(type)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

plot(p)