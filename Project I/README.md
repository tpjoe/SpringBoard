
Inspiration:

In an aging society, medicare has becoming inceasingly vital. Unfortunately, with modern US Healthcare programs’ complexity and sophistication, fraud losses in healthcare cost US taxpayers a staggering amount, to quote from the Justice Department,

    “Health care fraud costs the United States tens of billions of dollars each year. 
    Some estimates put the figure close to $100 billion a year. It is a rising threat, 
    with national health care expenditures estimated to exceed $3 trillion in 2014.” 
    - U.S. Department of Justice

This project aims to tackle this data using a data-driven approach, particularly we hope to: 
* Detect patterns of fraud medicare providers. 
* Build classification models to detect these providers.

Solutions to all problems start with gathering data and seeing the big picture through big data analytics lens, here I employed a combination of data including CMS Medicare 2014 Part D data from Google BigQuery , Medicare Exclusion list from the Office of Inspector General, and a geographical dataset.
Results Summary:

In summary, we found that fraud providers for medicare related drugs tend to sell more narcotics (4x more times to be exact), with much higher price than typical providers would. Leveraging this knowledge, PCA, and several other techniques to capture the problem’s class imbalance, we built several models to capture fraud providers and achieve AUC of more than 0.98.

Apart from the Notebook, you can see the results and analysis in
https://plot.ly/~tpjoe33/12/catching-medicare-fraud-providers-from-sale-anomalies/

Stacks used: Python, sklearn, plotly, pandas
