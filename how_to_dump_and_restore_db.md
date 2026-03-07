# restore
```
  psql -U postgres -d devoured_development < ./tmptmptmp/db/backups/2026_02_28.sql
```

  ## для бинарного дампа
    ```
    # сначала bin/rails db:create
    # потом:
    pg_restore -U postgres -d devoured_development /tmptmptmp/db/backups/2026_03_07.dump
    ```

# dump
  ## Custom format (рекомендуется)
  pg_dump -U postgres -d devoured_development -F c -v -f ./tmptmptmp/db/backups/2026_03_07.dump

  ## С исключением больших таблиц (если нужно)
  pg_dump -U postgres -d devoured_development > ./tmptmptmp/db/backups/2026_02_28.sql
