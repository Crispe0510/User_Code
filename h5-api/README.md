# H5 User API

This folder is the trimmed backend for the H5 user frontend only.

It was extracted from `api/` and keeps only the backend code required by `h5/`.
The original `api/` folder is unchanged.

## Kept API Groups

Base path: `/api/h5`

| Frontend page | Backend endpoints |
| --- | --- |
| `AuthView.vue` | `POST /auth/register`, `POST /auth/login` |
| `HomeView.vue` | `POST /auth/logout` |
| `TopicBridgeView.vue` | `GET /scenarios`, `GET /recent-topics`, `GET /custom/scenarios` |
| `TopicListView.vue` | `GET /scenarios`, `GET /topics`, `GET /custom/scenarios` |
| `TopicDetailView.vue` | `GET /topics/{id}`, `GET /custom/scenarios` |
| `TopicChatView.vue` | `GET /topics/{id}`, `GET /custom/scenarios`, `GET /chat/messages`, `POST /chat/messages`, `POST /chat/ai-reply`, `GET /mood/family` |
| `MoodBoardView.vue` | `GET /mood/types`, `GET /mood/family`, `GET /mood/weekly`, `POST /mood/checkin`, `GET /family/members`, `POST /family/members`, `PUT /family/members/{id}`, `DELETE /family/members/{id}`, `GET /chat/linkable-users` |
| `ReportView.vue` | `GET /report/timeline`, `POST /report/timeline` |
| `CustomScenarioView.vue` | `POST /custom/scenarios` |

## Removed From This Copy

- `controller/admin/**`
- `interceptor/AdminAuthInterceptor.java`
- `entity/AdminUser.java`
- `mapper/AdminUserMapper.java`
- Admin token methods in `TokenStore`
- Admin interceptor registration in `WebConfig`
- Admin-only mapper methods that were not needed by H5 pages

## Still Required

- MySQL database initialized from `../databases/wy_db.sql`, unless the database already exists.
- Java and Maven.
- The H5 frontend in `../h5`.

## Build

```powershell
cd h5-api
mvn -q -DskipTests compile
```

## Run

```powershell
cd h5-api
mvn spring-boot:run
```

The server still uses port `8791`, matching the existing H5 Vite proxy config.
