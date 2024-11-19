#!/usr/bin/env python
# coding: utf-8

# # EXPLORATORY DATA ANALYSIS USING PANDAS

# TASKS PERFORMED-
# 
# Data Manipulation: Demonstrates proficiency in reading CSV files, handling missing values, sorting, filtering, and grouping data.
# 
# Data Visualization: Utilizes seaborn and matplotlib to create informative visualizations like heatmaps and line plots.
# 
# Data Analysis: Performs basic statistical analysis and explores relationships between variables.
# 
# Code Clarity: Uses clear variable names and comments to explain the code's purpose.

# In[1]:


import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt


# pandas: This library is used for data manipulation and analysis.
# seaborn: This library is used for data visualization.
# matplotlib.pyplot: This library is used for creating static, animated, and interactive visualizations.

# In[18]:


df = pd.read_csv(r"D:\Users\ANIKET1208\Downloads\world_population.csv")
df
#This reads the CSV file containing world population data into a pandas DataFrame named df.


# 1.df.info(): Provides a summary of the DataFrame, including column names, data types, and non-null values.
# 
# 2.df.describe(): Calculates summary statistics for numerical columns (count, mean, standard deviation, min, 25%, 50%, 75%, max).
# 
# 3.df.isnull().sum(): Counts the number of missing values in each column.
# 
# 4.df.nunique(): Counts the number of unique values in each column.

# In[3]:


df.info()


# In[4]:


df.describe()


# In[5]:


df.isnull().sum()


# In[6]:


df.nunique()


# Sorting and Head: Sorts the DataFrame by 2022 population in descending order and displays the top 5 rows.
# 
# Heatmap: Creates a heatmap to visualize the correlation matrix between numerical columns.
# 
# Grouping by Continent: Groups the data by continent and calculates the mean of all columns.
# 
# Filtering Oceania: Filters the DataFrame to display countries in Oceania.
# Grouping and Sorting by Population: Groups the data by continent, calculates the mean of population columns, and sorts by 2022 population in descending order.
# 
# Plotting: Plots the grouped and sorted data to visualize population trends by continent.

# In[7]:


df.sort_values(by = "2022 Population", ascending = False).head()


# In[8]:


sns.heatmap(df.corr(), annot = True)

plt.rcParams['figure.figsize'] = (25,7)
plt.show()


# In[9]:


df.groupby('Continent').mean()


# In[10]:


df[df['Continent'].str.contains('Oceania')]


# In[11]:


df2 = df.groupby('Continent')[df.columns[5:13]].mean().sort_values(by = "2022 Population", ascending = False)


# In[13]:


df3 = df2.transpose()


# In[14]:


df3


# In[15]:


df3.plot()


# In[16]:


df3.boxplot()


# In[17]:


df.select_dtypes(include = 'object')


# In[ ]:




