## Full-Stack Expense Manager

Thanks for checking out the project! The Spring Boot + MongoDB backend lives in `Backend`, and the Flutter app lives in `Frontend/expense_management`. Follow the notes below and you should have both sides running in just a few minutes.

## What You’ll Need
- Java 21 and Maven 3.9+
- Flutter 3.x with your platform of choice enabled (Windows desktop, Android, iOS, etc.)
- MongoDB available at `mongodb://localhost:27017` or any other URI you prefer
- Port `8080` free for the backend (feel free to change `server.port` if something is already there)

## 1. Grab the Code
(https://github.com/SanskarPatidar747/expense_management) is currently empty, so push your local code there first). Once it’s populated:
```powershell
git clone https://github.com/SanskarPatidar747/expense_management.git
cd expense_management
```

## 2. Fire Up the Backend
1. Install dependencies (first run only):
   ```powershell
   cd Backend
   mvn clean package
   ```
2. MongoDB config:
   - Defaults to `mongodb://localhost:27017/expense_db`
   - Want something else? Set `MONGODB_URI` before running Maven.
3. Start the API:
   ```powershell
   mvn spring-boot:run
   ```
   You’ll get REST endpoints at `http://localhost:8080/api`. If the port is busy, either free it up or tweak `server.port` in `application.properties`.

## 3. Launch the Flutter App
1. From the repo root:
   ```powershell
   cd Frontend/expense_management
   flutter pub get
   ```
2. Run on any target you like:
   ```powershell
   flutter run -d windows   # or chrome / macos / android / ios
   ```
   - Defaults to `http://localhost:8080/api`
   - Need a different backend URL? Add `--dart-define API_BASE_URL=http://<host>:<port>/api`
   - Android emulator? It automatically swaps to `http://10.0.2.2:8080/api`

## 4. Headers (So Things Don’t Break)
- The API expects an `X-USER-ID` header. The Flutter app takes care of it after login, so you shouldn’t have to fiddle with Postman or anything unless you want to.

## 5. Handy Commands
- Backend tests → `cd Backend && mvn test`
- Flutter tests → `cd Frontend/expense_management && flutter test`

That’s it! Clone, run the backend, launch the Flutter client, and you’re ready to explore. Ping me if anything feels unclear. 
