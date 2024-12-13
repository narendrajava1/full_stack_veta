Adding indexes in MySQL can significantly improve the performance of queries, especially for large datasets. Indexes are used to speed up data retrieval operations by creating a data structure that allows the database engine to locate rows more quickly.

Here’s a detailed guide on when and how to add indexes in MySQL, along with usage best practices:

---

### **1. When to Add Indexes**

You should consider adding indexes in the following scenarios:

- **Primary Key or Unique Constraints**:
    - MySQL automatically creates indexes for primary keys and unique constraints.

- **Frequently Queried Columns**:
    - Columns used in `WHERE`, `JOIN`, `ORDER BY`, `GROUP BY`, or `HAVING` clauses.
    - Example: Queries like `SELECT * FROM employees WHERE department_id = 5;`.

- **Foreign Keys**:
    - Adding indexes to foreign key columns improves JOIN performance.

- **Large Tables**:
    - Indexes can prevent full table scans for large datasets, reducing query execution time.

- **Composite Queries**:
    - Queries involving multiple columns in filtering or sorting benefit from **composite indexes**.

---

### **2. Types of Indexes in MySQL**

1. **Primary Index**:
    - Automatically created when a column is defined as a primary key.
   ```sql
   CREATE TABLE employees (
       id INT PRIMARY KEY,
       name VARCHAR(50)
   );
   ```

2. **Unique Index**:
    - Ensures all values in a column (or combination of columns) are unique.
   ```sql
   CREATE UNIQUE INDEX unique_email ON users (email);
   ```

3. **Single-Column Index**:
    - Indexes a single column to speed up queries filtering by that column.
   ```sql
   CREATE INDEX idx_department_id ON employees (department_id);
   ```

4. **Composite Index (Multi-Column Index)**:
    - Useful when queries filter or sort by multiple columns.
   ```sql
   CREATE INDEX idx_name_department ON employees (name, department_id);
   ```

5. **Full-Text Index**:
    - Used for full-text search on textual data.
   ```sql
   CREATE FULLTEXT INDEX idx_fulltext_name ON employees (name);
   ```

6. **Spatial Index**:
    - Used for geospatial data.
   ```sql
   CREATE SPATIAL INDEX idx_location ON locations (coordinates);
   ```

---

### **3. Adding Indexes to an Existing Table**

To add an index to an existing table, use the `CREATE INDEX` statement:

```sql
CREATE INDEX idx_column_name ON table_name (column_name);
```

**Examples**:
- Adding a single-column index:
  ```sql
  CREATE INDEX idx_email ON users (email);
  ```
- Adding a composite index:
  ```sql
  CREATE INDEX idx_name_age ON employees (name, age);
  ```

---

### **4. Viewing Existing Indexes**

To list the indexes on a table, use the `SHOW INDEX` command:

```sql
SHOW INDEX FROM table_name;
```

**Example**:
```sql
SHOW INDEX FROM employees;
```

---

### **5. Dropping an Index**

To remove an existing index, use the `DROP INDEX` statement:

```sql
DROP INDEX idx_column_name ON table_name;
```

**Example**:
```sql
DROP INDEX idx_email ON users;
```

---

### **6. Best Practices for Index Usage**

1. **Avoid Over-Indexing**:
    - Adding too many indexes can slow down `INSERT`, `UPDATE`, and `DELETE` operations because the indexes need to be updated.

2. **Use Composite Indexes Wisely**:
    - Place the most selective columns (those with the highest number of unique values) first in composite indexes.

3. **Monitor Index Usage**:
    - Use the `EXPLAIN` command to analyze how indexes are used in queries.
   ```sql
   EXPLAIN SELECT * FROM employees WHERE department_id = 5;
   ```

4. **Use Covering Indexes**:
    - Include columns in the index that are frequently queried, even if they’re not part of the filtering criteria.
   ```sql
   CREATE INDEX idx_name_department_salary ON employees (name, department_id, salary);
   ```

5. **Full-Text Index for Textual Data**:
    - Use full-text indexes for search queries on large text columns.
   ```sql
   SELECT * FROM articles WHERE MATCH(title, content) AGAINST('search text');
   ```

6. **Periodically Optimize Table**:
    - Use the `OPTIMIZE TABLE` command to reorganize the storage for tables and reduce fragmentation.
   ```sql
   OPTIMIZE TABLE employees;
   ```

---

### **7. Example: Adding and Using Indexes**

#### **Table Without Index**
```sql
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    salary DECIMAL(10, 2)
);
```

#### **Adding an Index**
- Add an index to `department_id` for faster filtering:
  ```sql
  CREATE INDEX idx_department_id ON employees (department_id);
  ```

#### **Query Performance Before and After Indexing**
**Without Index**:
```sql
SELECT * FROM employees WHERE department_id = 5;
-- Full table scan, slower
```

**With Index**:
```sql
SELECT * FROM employees WHERE department_id = 5;
-- Index scan, much faster
```

---

### **8. Monitoring Index Effectiveness**

Use the `EXPLAIN` command to understand query performance:

```sql
EXPLAIN SELECT * FROM employees WHERE department_id = 5;
```

The output will show whether the query is using the index (`key` column in the result).

---

By strategically adding indexes in MySQL, you can drastically improve the performance of your queries while maintaining efficient data insertion and updates. Always test and monitor the impact of indexes using `EXPLAIN` and other tools like MySQL Performance Schema.