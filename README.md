
![Star Schema Image](https://github.com/user-attachments/assets/2b990e20-904d-4737-b513-585037f79e4e)


Why Star Schema instead of Snowflake:

A star schema keeps dimensions denormalized, which:

1.Simplifies BI queries (fewer joins → faster, easier to write).

2.Is more readable for business slicing (Product, Customer, Date, Store around a single fact).

- A Snowflake schema would normalize attributes. For example, (separate Category/Subcategory tables) and add joins without clear benefit for these analytics. 
