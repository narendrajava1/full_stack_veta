Yes, **Liquibase** in **Spring Boot** supports using SQL files as changelog files. This allows you to define database changes directly in SQL, which can be more familiar for database developers. Here's how to set it up and use SQL changelog files with Liquibase in a Spring Boot application.

---

### **Using SQL Changelogs with Liquibase**

#### **1. Create an SQL Changelog File**
1. In your project's `src/main/resources` directory, create an SQL file for your changelog, e.g., `db/changelog/db.changelog.sql`.
2. Add Liquibase-formatted SQL to the file:

```sql
--liquibase formatted sql

--changeset yourname:1
CREATE TABLE employee (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255)
);

--changeset yourname:2
ALTER TABLE employee ADD COLUMN age INT;
```

Each changeset must include:
- `--changeset author:id`: A unique identifier (`author` and `id`) for the changeset.
- SQL commands for the database change.

---

#### **2. Configure the SQL Changelog in `application.properties`**

Set the `spring.liquibase.change-log` property to the SQL changelog file location:

```properties
spring.liquibase.change-log=classpath:db/changelog/db.changelog.sql
spring.liquibase.enabled=true
```

Alternatively, in `application.yml`:

```yaml
spring:
  liquibase:
    change-log: classpath:db/changelog/db.changelog.sql
    enabled: true
```

---

#### **3. Run the Application**
When you run your Spring Boot application:
1. Liquibase will execute the SQL changesets defined in the changelog.
2. It will log the changes in the `DATABASECHANGELOG` table.

---

### **Key Notes for SQL Changelogs**

1. **Changeset Uniqueness**:
    - The `author:id` pair must be unique across all changelogs. If you duplicate an `author:id`, Liquibase will skip the changeset as already applied.

2. **Tracking Applied Changes**:
    - Liquibase maintains the execution history in the `DATABASECHANGELOG` table, even for SQL changelogs.

3. **Rollback in SQL**:
    - You can add rollback SQL commands using the `--rollback` keyword:
      ```sql
      --changeset yourname:3
      INSERT INTO employee (name, email) VALUES ('John Doe', 'john.doe@example.com');
 
      --rollback
      DELETE FROM employee WHERE name = 'John Doe';
      ```

4. **Comments in SQL**:
    - Standard SQL comments are ignored by Liquibase but helpful for documentation:
      ```sql
      -- This changeset adds an age column to the employee table
      --changeset yourname:4
      ALTER TABLE employee ADD COLUMN age INT;
      ```

---

### **When to Use SQL Changelogs**
- SQL changelogs are ideal for:
    - Database administrators and developers who are more comfortable with SQL.
    - Scenarios where native SQL performance tuning or database-specific commands are required.
- For simple changes or when working in a team that prefers YAML/XML, consider using the other supported formats.

---

### **Example: Combining SQL and Other Changelog Formats**

You can combine SQL changelogs with XML/YAML in a master changelog file:

`db.changelog-master.xml`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog
    xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
                        http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-3.8.xsd">

    <include file="db/changelog/db.changelog.sql"/>
    <include file="db/changelog/changes-1.xml"/>
</databaseChangeLog>
```

This way, you can mix and match formats as needed.

---

### **Advantages of SQL Changelogs**
- **Familiar Syntax**: SQL is universally understood and allows database-specific optimizations.
- **Database-Specific Features**: Directly use vendor-specific SQL commands.
- **Ease of Testing**: You can test SQL scripts independently before integrating them.

---

This flexibility allows teams to choose the best format for their needs while leveraging Liquibase's robust versioning and rollback capabilities.

Connection Pool Testing
To verify the connection pool:

### 1.Check the database for open connections using MySQL commands:

`SHOW PROCESSLIST;`