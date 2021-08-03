#!/usr/bin/env python
# coding: utf-8

# This exercise will require you to pull some data from the Qunadl API. Qaundl is currently the most widely used aggregator of financial market data.

# As a first step, you will need to register a free account on the http://www.quandl.com website.

# After you register, you will be provided with a unique API key, that you should store:

# In[ ]:


# Store the API key as a string - according to PEP8, constants are always named in all upper case
API_KEY = 'API_KEY'
# IMPORTANT: Please ensure that you remove your API keys from the Jupyter Notebook before checking it into Github. 
# Your keys are private to you and should not be on a public repository.


# Qaundl has a large number of data sources, but, unfortunately, most of them require a Premium subscription. Still, there are also a good number of free datasets.

# For this mini project, we will focus on equities data from the Frankfurt Stock Exhange (FSE), which is available for free. We'll try and analyze the stock prices of a company called Carl Zeiss Meditec, which manufactures tools for eye examinations, as well as medical lasers for laser eye surgery: https://www.zeiss.com/meditec/int/home.html. The company is listed under the stock ticker AFX_X.

# You can find the detailed Quandl API instructions here: https://docs.quandl.com/docs/time-series

# While there is a dedicated Python package for connecting to the Quandl API, we would prefer that you use the *requests* package, which can be easily downloaded using *pip* or *conda*. You can find the documentation for the package here: http://docs.python-requests.org/en/master/ 

# Finally, apart from the *requests* package, you are encouraged to not use any third party Python packages, such as *pandas*, and instead focus on what's available in the Python Standard Library (the *collections* module might come in handy: https://pymotw.com/3/collections/ ).
# Also, since you won't have access to DataFrames, you are encouraged to us Python's native data structures - preferably dictionaries, though some questions can also be answered using lists.
# You can read more on these data structures here: https://docs.python.org/3/tutorial/datastructures.html

# Keep in mind that the JSON responses you will be getting from the API map almost one-to-one to Python's dictionaries. Unfortunately, they can be very nested, so make sure you read up on indexing dictionaries in the documentation provided above.

# In[2]:


# First, import the relevant modules
import requests, json


# Note: API's can change a bit with each version, for this exercise it is reccomended to use the "V3" quandl api at `https://www.quandl.com/api/v3/`

# In[3]:


# Now, call the Quandl API and pull out a small sample of the data (only one day) to get a glimpse
# into the JSON structure that will be returned

# NOTE: Frankfurt Stock Exhange (FSE) dataset not longer available for free access, used alternative data.

url = 'https://www.quandl.com/api/v3/datasets/HKEX/58538.json?rows=1&api_key=API_KEY'
r = requests.get(url)
r.json()


# In[4]:


# Inspect the JSON structure of the object you created, and take note of how nested it is,
# as well as the overall structure


# These are your tasks for this mini project:
# 
# 1. Collect data from the Franfurt Stock Exchange, for the ticker AFX_X, for the whole year 2017 (keep in mind that the date format is YYYY-MM-DD).
# 2. Convert the returned JSON object into a Python dictionary.
# 3. Calculate what the highest and lowest opening prices were for the stock in this period.
# 4. What was the largest change in any one day (based on High and Low price)?
# 5. What was the largest change between any two days (based on Closing Price)?
# 6. What was the average daily trading volume during this year?
# 7. (Optional) What was the median trading volume during this year. (Note: you may need to implement your own function for calculating the median.)

# In[5]:


# NOTE: Frankfurt Stock Exhange (FSE) dataset not longer available for free access, used alternative data.

# Collect data for whole year
url = 'https://www.quandl.com/api/v3/datasets/HKEX/58538.json?start_date=2020-01-01&end_date=2020-12-31&api_key=API_KEY'

# Convert to Python dictionary
r = requests.get(url)
rdata = r.json()
col_names = rdata.get('dataset').get('column_names')
data = rdata.get('dataset').get('data')

print(len(data))
print(data)
print(col_names)


date_list = [i1 for i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13 in data]
price_list = [i2 for i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13 in data]
high_list = [i8 for i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13 in data]
low_list = [i9 for i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13 in data]
one_day_change_list = [i8-i9 for i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13 in data]
close_list = [i10 for i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13 in data]
share_vol_list = [i11 for i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13 in data]




# In[6]:


# Calculate what the highest opening price for the stock in this period.
print("Highest opening price: "+str(max(high_list)))

# Calculate what the lowest opening price for the stock in this period.
print("Lowest opening price: "+str(min(low_list)))

# What was the largest change in any one day (based on High and Low price)?
print("Largest change in any one day: "+str(max(one_day_change_list)))

# What was the largest change between any two days (based on Closing Price)?
close_none = list(filter(None, close_list))
close_none_list = [close_none[n]-close_none[n-1] for n in range(1,len(close_none))]
print("Largest change in any two days: "+str(max(close_none_list)))

# What was the average daily trading volume during this year?
from statistics import mean
print("Average daily trading volume (000s): "+str(mean(share_vol_list)))

# What was the median trading volume during this year. (Note: you may need to implement your own function for calculating the median.)
from statistics import median
print("Median daily trading volume (000s): "+str(median(share_vol_list)))

