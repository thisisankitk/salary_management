# Performance Notes

## Dataset Size

The assessment requires the system to support an organization with 10,000 employees.

This size is manageable for a relational database, but inefficient implementation choices can still become visible.

## Salary Insights

Salary insights will be calculated using database-level aggregation such as:

- MIN
- MAX
- AVG
- COUNT

This avoids loading unnecessary employee records into Ruby memory.

## Indexing Strategy

The salary insight queries will commonly filter by:

- country
- job title
- country and job title together

Indexes will be added accordingly.

## Seeding Strategy

The seed script must generate 10,000 employees using `first_names.txt` and `last_names.txt`.

The seed implementation should avoid one database insert per employee.

Planned approach:

- load first and last names once
- generate employees in batches
- insert records using bulk insert
- keep the script re-runnable without creating duplicates.