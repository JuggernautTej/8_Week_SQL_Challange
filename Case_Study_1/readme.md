# Case Study 1- Danny's Diner
![SQLChallange1](https://user-images.githubusercontent.com/88348888/204285716-7d1dc004-361f-482a-9dbd-f3180de26900.png)


## Problem Statement

Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. 
Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.
He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL

## Data Sets

Danny provided 3 data sets to use for the study; 
- Sales; This table captures all customer_id level purchases with an corresponding order_date and product_id information for when and what menu items were ordered.
- Menu; The menu table maps the product_id to the actual product_name and price of each menu item. 
- Members; This table captures the join_date when a customer_id joined the beta version of the Danny’s Diner loyalty program. 

All datasets exist within the dannys_diner database schema.

## Questions to answer
1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

### Bonus Questions

A. Recreate the following table output using the available data:

![SQLChallengeWeek1_Bonus Question A](https://user-images.githubusercontent.com/88348888/204283728-a793d544-315b-48f0-a2e3-6e6f8f3e245b.JPG)

B.Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.
![SQLChallengeWeek1_Bonus Question B](https://user-images.githubusercontent.com/88348888/204284665-f7f13da9-68d6-4726-af51-069c6f97dcce.JPG)
