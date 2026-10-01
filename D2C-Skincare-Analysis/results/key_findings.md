# Key Findings
Here, I collate all of the key findings from the various sql files. The relevant business recommendations can be found in the README.

# Sales Analysis

### Total revenue
Final revenue (including discount) = $1,175,350.00

Final revenue (including discount and shipping fees, removing cancelled orders) = $1,122,034.65

### Revenue by month
Average yearly revenue significantly brought up by the months: 
- 2024 August, October, November
- 2025 January, July, October

(Noting that the average yearly revenue decreases by ~$3000 from 2024 to 2025)

The above is confirmed by the month-over-month growth. Notably, this swings quite dramatically between nearly every month.

Months with negative growth:
- 2024 Feb, Apr, May, Jul, Sep, Nov, Dec
- 2025 Feb, Apr, May, Jun, Aug, Sep, Nov

which accounts for more than half the year.

The above is also in agreement with the number of orders by month, suggesting that the total revenue underperforms during the first half of both years due to a lower number of overall orders. (Also confirmed by a rolling 3-month average revenue).

## Channel breakdowns
### Payment method
By far the most common payment method is UPI, accounting for 41.12% of the payment methods used. The second-most is via Credit Card, only accounting for 20.56%.

### Sales channel
Ordering via website is the most common sales channel, accounting for 55.84% of the sales channels. In comparison, Mobile App accounts for 35.52%, and Marketplace for 8.64%.

# Customer Analysis

## Customer Summary
Through the customer summary table, contained in the first section of the customer analysis sql file, we find that only 199 customers of the total 500 have spent more than the average amount. This accounts for less than half the total number of customers, perhaps suggesting that the overall revenue is brought up by a handful of high-spending customers.


## Customer Purchasing Habits

We find that 46 customers have never placed an order, which is quite a large proportion of the total 500 listed customers (~10%). Further, 102 customers have never made a repeat purchase, accounting for ~20% of the customer base, which is significant.

Finally, of the repeat customers, only 19 have ordered more than 5 times, and with 10 of those ordering between 7 and 8 times. This perhaps suggests that revenue could be increased by improving customer retention.



# Product Analysis


The first section in the relevant sql file contains a summary table of the products. From this, we find that the top 7 products contribute at least 5% to the total revenue each. Further, the bottom 7 items contribute 2% to the revenue each. This is not an enormous gap.

The average discount is quite high across all items. One way to increase revenue would be to limit the number of items with a discount, as each item has a non-zero average discount. However, this also likely rules out the method of increasing item discounts to increase customer retention.

The highest revenue product brings in $81,027,65 to the total revenue, whereas the lowest revenue product only brings in $10,872.75. This gap is not enormous, and the range of values is quite reasonable; further, there are no items that have not sold, meaning it would not be beneficial to remove items from the store to decrease purchasing cost.





