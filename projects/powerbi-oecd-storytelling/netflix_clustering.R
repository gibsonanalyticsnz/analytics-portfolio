# Load packages
library(tidyverse)
library(ggplot2)
library(caret)
library(cluster)
library(dplyr)


# Loading the CSV file
data <- read.csv("netflix_clustering_data.csv")

# Viewing the first few rows
head(data)

# Selecting only the columns needed
clean_data <- data %>%
  select(Genre, duration_value, main_country, Critic_Score_10)

# Removing rows with missing values
clean_data <- na.omit(clean_data)


# One-hot encoding genre and country
# Create dummy variables for genre
dv_genre <- dummyVars(~ Genre, data = clean_data)
genre_encoded <- data.frame(predict(dv_genre, newdata = clean_data))

# Creating dummy variables for country
dv_country <- dummyVars(~ main_country, data = clean_data)
country_encoded <- data.frame(predict(dv_country, newdata = clean_data))

# Combining encoded variables with numeric columns
numeric_data <- clean_data[, c("duration_value", "Critic_Score_10")]
encoded_data <- cbind(numeric_data, genre_encoded, country_encoded)

# Scaling numeric columns
scaled_data <- encoded_data
scaled_data[, c("duration_value", "Critic_Score_10")] <- scale(encoded_data[,
          c("duration_value", "Critic_Score_10")])

summary(scaled_data$duration_value)
summary(scaled_data$Critic_Score_10)

# Using only numeric columns for clustering
cats <- scaled_data

set.seed(767)  # For reproducibility

fits <- list()
withinss_scores <- numeric()
silhouette_scores <- numeric()

for (k in 2:10) {
  model <- kmeans(cats, centers = k)
  fits[[k]] <- model
  
  # Elbow method score
  withinss_scores[k] <- model$tot.withinss # Total within-cluster sum of squares
  
  # Silhouette score
  ss <- silhouette(model$cluster, dist(cats))
  silhouette_scores[k] <- mean(ss[, 3]) # Average silhouette width
}

print(withinss_scores[2:10])
print(silhouette_scores[2:10])

# Plotting elbow method/within-cluster sum of squares
plot(2:10, withinss_scores[2:10], type = "b",
     xlab = "Number of Clusters (k)",
     ylab = "Total Within-Cluster Sum of Squares",
     main = "Elbow Method for Optimal k")

# Plotting silhouette score
plot(2:10, silhouette_scores[2:10], type = "b",
     xlab = "Number of Clusters (k)",
     ylab = "Average Silhouette Score",
     main = "Silhouette Method for Optimal k")

# Final clustering with k = 7
set.seed(767)
final_model <- kmeans(cats, centers = 7)

# Adding cluster labels to original data
clean_data$cluster <- as.factor(final_model$cluster)

# Adding cluster labels to your dataset
cats$cluster <- as.factor(final_model$cluster)

# PCA reduces dimensionality, excludes the cluster column to avoid bias
pca <- prcomp(cats[, -which(names(cats) == "cluster")], center = TRUE, scale. = TRUE)
summary(pca)

# Viewing how much variance each principal component explains
explained_variance <- summary(pca)$importance[2,]

# Plotting variance explained by each principal component
barplot(explained_variance,
        main = "Variance Explained by Each Principal Component",
        xlab = "Principal Components",
        ylab = "Proportion of Variance",
        col = "skyblue")

# Extracting the first two principal components
# Creating a dataframe with PC1 and PC2
cats_pc_2 <- data.frame(pca$x[, 1:2])

# Adding cluster labels
cats_pc_2$cluster <- cats$cluster

# Many features after one-hot encoding genres and countries.These features are likely
# sparse and weakly correlated, meaning no small subset can explain most of the variance.
# That’s why PC1 and PC2 only capture 7.8% of the variance combined, and 44 
# components were needed to reach 95%. However, PCA was merely used to help visualize
# the structure and separation between clusters, even if they don’t capture most of the 
# variance, not for model performance.


# Visualizing Clusters in PCA Space using scatter plot of the first two PCs colored by cluster
ggplot(cats_pc_2, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(alpha = 0.7, size = 2) +
  labs(title = "Strategic Content Groupings: PCA View of Clusters",
       x = "Principal Component 1",
       y = "Principal Component 2") +
  theme_minimal() +
  scale_color_brewer(palette = "Set1")+
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold")
  )


# Profiling clusters
# Summary of duration and rating by cluster
cluster_summary <- clean_data %>%
  group_by(cluster) %>%
  summarise(
    count = n(),
    avg_duration = round(mean(duration_value, na.rm = TRUE), 1),
    avg_rating = round(mean(Critic_Score_10, na.rm = TRUE), 2)
  )

print(cluster_summary)

# Identifying Dominant Genres per Cluster
# Counting top genres per cluster
genre_counts <- clean_data %>%
  group_by(cluster, Genre) %>%
  summarise(count = n()) %>%
  arrange(cluster, desc(count))

# Viewing top genres per cluster
genre_top <- genre_counts %>%
  group_by(cluster) %>%
  slice_max(order_by = count, n = 3)

print(genre_top)

# Identifying Dominant Countries per Cluster
# Counting top countries per cluster
# Creating country_counts first
country_counts <- clean_data %>%
  group_by(cluster, main_country) %>%
  summarise(count = n(), .groups = "drop") %>%
  arrange(cluster, desc(count))

# Now finding top 3 countries per cluster
country_top <- country_counts %>%
  group_by(cluster) %>%
  slice_max(order_by = count, n = 3)

print(country_top)
print(country_top, n = Inf)



# Cluster Size Distribution
# This shows how many titles fall into each cluster.
clean_data %>%
  group_by(cluster) %>%
  summarise(count = n()) %>%
  ggplot(aes(x = factor(cluster), y = count, fill = cluster)) +
  geom_bar(stat = "identity") +
  labs(title = "Number of Titles per Cluster",
       x = "Cluster",
       y = "Count") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1")

# Average Rating and Duration per Cluster
# This shows how clusters differ in quality and format.
# Prepare summary
cluster_summary <- clean_data %>%
  group_by(cluster) %>%
  summarise(
    avg_rating = round(mean(Critic_Score_10, na.rm = TRUE), 2),
    avg_duration = round(mean(duration_value, na.rm = TRUE), 1)
  )

# Plotting average rating
ggplot(cluster_summary, aes(x = factor(cluster), y = avg_rating, fill = cluster)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Rating per Cluster",
       x = "Cluster",
       y = "Rating (0–10)") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1")

# Plotting average duration
ggplot(cluster_summary, aes(x = factor(cluster), y = avg_duration, fill = cluster)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Duration per Cluster",
       x = "Cluster",
       y = "Duration (minutes)") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1")

# Genre Composition per Cluster (Stacked Bar Chart)
# This shows how many titles of each genre appear in each cluster.
clean_data %>%
  group_by(cluster, Genre) %>%
  summarise(count = n(), .groups = "drop") %>%
  ggplot(aes(x = factor(cluster), y = count, fill = Genre)) +
  geom_bar(stat = "identity") +
  labs(title = "Genre Composition by Cluster",
       x = "Cluster",
       y = "Count") +
  theme_minimal() +
  scale_fill_brewer(palette = "Paired")

# Genre Share per Cluster (Filled Bar Chart)
# This shows the proportion of each genre within each cluster.
clean_data %>%
  group_by(cluster, Genre) %>%
  summarise(count = n(), .groups = "drop") %>%
  ggplot(aes(x = factor(cluster), y = count, fill = Genre)) +
  geom_bar(stat = "identity", position = "fill") +
  labs(title = "Genre Share by Cluster",
       x = "Cluster",
       y = "Proportion") +
  theme_minimal() +
  scale_fill_brewer(palette = "Paired")

# Country Composition per Cluster (Stacked Bar Chart)
clean_data %>%
  group_by(cluster, main_country) %>%
  summarise(count = n(), .groups = "drop") %>%
  ggplot(aes(x = factor(cluster), y = count, fill = main_country)) +
  geom_bar(stat = "identity") +
  labs(title = "Country Composition by Cluster",
       x = "Cluster",
       y = "Count") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set3")

# Country Share per Cluster (Filled Bar Chart)
clean_data %>%
  group_by(cluster, main_country) %>%
  summarise(count = n(), .groups = "drop") %>%
  ggplot(aes(x = factor(cluster), y = count, fill = main_country)) +
  geom_bar(stat = "identity", position = "fill") +
  labs(title = "Country Share by Cluster",
       x = "Cluster",
       y = "Proportion") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set3")


# Identifying Top 7 Genres and Countries for cleaner visuals
# Top 7 Genres by overall count
top_genres <- clean_data %>%
  count(Genre, sort = TRUE) %>%
  slice_head(n = 7) %>%
  pull(Genre)

# Top 7 Countries by overall count
top_countries <- clean_data %>%
  count(main_country, sort = TRUE) %>%
  slice_head(n = 7) %>%
  pull(main_country)

# Filtering Data Before Plotting
# Genre Composition per Cluster (Stacked Bar Chart)
clean_data %>%
  filter(Genre %in% top_genres) %>%
  group_by(cluster, Genre) %>%
  summarise(count = n(), .groups = "drop") %>%
  ggplot(aes(x = factor(cluster), y = count, fill = Genre)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 7 Genres: Count of Titles per Cluster",
       x = "Cluster",
       y = "Count") +
  theme_minimal() +
  scale_fill_brewer(palette = "Paired") +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold")
  )


# Genre Share per Cluster (Filled Bar Chart)
clean_data %>%
  filter(Genre %in% top_genres) %>%
  group_by(cluster, Genre) %>%
  summarise(count = n(), .groups = "drop") %>%
  ggplot(aes(x = factor(cluster), y = count, fill = Genre)) +
  geom_bar(stat = "identity", position = "fill") +
  labs(title = "Top 7 Genres: Distribution by Cluster (Proportional Share)",
       x = "Cluster",
       y = "Proportion") +
  theme_minimal() +
  scale_fill_brewer(palette = "Paired")+
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold")
  )


# Country Composition per Cluster (Stacked Bar Chart)
clean_data %>%
  filter(main_country %in% top_countries) %>%
  group_by(cluster, main_country) %>%
  summarise(count = n(), .groups = "drop") %>%
  ggplot(aes(x = factor(cluster), y = count, fill = main_country)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 7 Countries: Count of Titles per Cluster",
       x = "Cluster",
       y = "Count") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set3")+
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold")
  )

# Country Share per Cluster (Filled Bar Chart)
clean_data %>%
  filter(main_country %in% top_countries) %>%
  group_by(cluster, main_country) %>%
  summarise(count = n(), .groups = "drop") %>%
  ggplot(aes(x = factor(cluster), y = count, fill = main_country)) +
  geom_bar(stat = "identity", position = "fill") +
  labs(title = "Top 7 Countries:Distribution by Cluster (Proportional Share)",
       x = "Cluster",
       y = "Proportion") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set3")+
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold")
  )







