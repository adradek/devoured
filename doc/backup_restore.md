# Как я ресторил бэкапы

## Задампить

su postgres -c "pg_dump devoured_development > dumps/febr2025.sql"

=-=-==-=-=-=-=-==-==-===-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

## Запампить

pg_restore --clean --no-acl --no-owner -d <database> -U <user> <filename.dump>

???

psql -U postgres -d devoured_development < ./tmptmptmp/devoured_dump.sql
