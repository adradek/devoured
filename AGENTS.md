# AGENTS.md

Инструкции для AI-агентов (Claude Code, ChatGPT/Codex и др.), работающих в этом репозитории.

## Проект

**devoured** — личный трекер прочитанных книг и просмотренных фильмов, плюс списки «прочитать» / «посмотреть».

- Ruby 4.0.5, Rails 8.1, PostgreSQL 17
- Hotwire: Turbo (frames/streams) + Stimulus; Bootstrap 5.3, Font Awesome, Sass; JS собирается esbuild
- Аутентификация — Sorcery, авторизация — Pundit (`UserPolicy#update?`: редактирует только владелец)
- Тесты — RSpec (в основном request specs) + FactoryBot

## Запуск

Приложение и тесты работают в Docker Compose:

- dev-сервер: `docker compose up`
- тесты: `docker compose exec -T web bundle exec rspec`
- линтер: `bin/rubocop` (конфиг на базе Standard)
- lefthook: pre-commit — rubocop по staged-файлам, pre-push — весь rspec

## Структура и соглашения

- Маршруты пользователя вложены в `users/:user_secret_id/...`; пользователь ищется по `secret_id`, не по `id`.
- В `Users::BooksController` параметр `:id` — это **id reading-а**, а не книги.
- `Book` — общая для всех пользователей сущность (уникальна по `title` + `author`). Всё персональное живёт в `Reading`.
- Бизнес-логика создания — `app/mutations/`, логика представления — `app/decorators/` (`ReadingDecorator#labels` даёт CSS-модификаторы карточки), сложные запросы — `app/queries/`.
- Сборники: `Reading#compilation_reading_id` связывает компоненты со сборником; клик по названию сборника сворачивает/разворачивает компоненты (`app/javascript/controllers/compilation_controller.js`).
- Интерфейс на русском.
- Строки в Ruby — в двойных кавычках (так требует Standard). В проекте Bootstrap, а не Tailwind. Правила в `.cursor/rules` в этих двух пунктах устарели.
- Префиксы коммитов: `feature:`, `fix:`, `refactoring:`, `chore:`.

## Текущая фича: прогресс чтения

Пользователь хочет фиксировать продвижение по начатым книгам (в том числе учебникам): в какой день какие страницы прочитаны («с такой-то по такую-то»). Затем панель reading-а на странице книг научится разворачиваться и показывать полосу прогресса, на которой видно продвижение по дням (дни могут различаться цветом).

Работа идёт поэтапно под руководством владельца проекта: агенты предлагают, решения принимает он. Требование, открытые вопросы, принятые решения и план лежат в [doc/features/reading-progress.md](doc/features/reading-progress.md). Прочитай этот файл перед любой работой над фичей и поддерживай его в актуальном состоянии.
