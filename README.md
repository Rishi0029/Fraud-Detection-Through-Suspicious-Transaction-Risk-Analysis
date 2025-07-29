Fraud Risk Behavioral Dashboard

This project was aimed at analyzing customer transaction behavior to identify potential fraud patterns and high-risk accounts. It involved multiple tools and phases — starting with data extraction and preprocessing using SQL, where key joins and filters were applied to prepare the base dataset. This was followed by behavioral flagging and fraud risk scoring in Excel, using a set of predefined conditions to highlight suspicious patterns like sudden balance drops, multiple logins, location mismatches, and more.

In the final phase, a Power BI dashboard was created to visualize key findings. The dashboard includes metrics such as total transaction count, total amount, and number of active accounts. Visuals were added to explore behavior across customer occupations, the channels most used for transactions (branch, online, ATM), usage differences between debit and credit cards, and the most common fraud flags. We also looked at the distribution of risk scores and how high-risk activity has trended over time.

Insights gained from the dashboard helped build targeted recommendations — for example, monitoring certain occupations more closely, prioritizing behaviors like new device/IP logins or location mismatches, and setting up automated alerts for spikes in risk score. The goal was to not only spot fraud that may already be happening, but also build a foundation for smarter, more proactive fraud detection in the future.

This repository includes the SQL scripts used, the Excel scoring file with flag logic, the Power BI (.pbix) file, and dashboard screenshots. It reflects an end-to-end data analysis project, moving from raw data all the way to visual insights and recommendations.
