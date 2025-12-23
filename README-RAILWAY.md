# Deploy to Railway (frontend + backend)

This repository contains:
- `backend/` — FastAPI API
- `frontend/` — React (CRACO) web app

## 1) What was cleaned
- Removed the “Made with Emergent” badge from `frontend/public/index.html`
- Removed `node_modules/`, `__pycache__/`, `.emergent/` and test files
- Added a production start script for the frontend: `yarn start:prod`
- Simplified backend `requirements.txt` and added `backend/Procfile`

---

## 2) Local run (optional)
### Backend
```bash
cd backend
cp .env.example .env
# edit .env with your Mongo connection values
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn server:app --reload --port 8000
```

### Frontend
```bash
cd frontend
yarn install
# point to your local backend
export REACT_APP_BACKEND_URL=http://localhost:8000
yarn start
```

---

## 3) Deploy on Railway (recommended: 2 services)

### A) Create a new Railway project
1. Go to Railway → **New Project** → **Deploy from GitHub repo**
2. Select this repo.

### B) Create BACKEND service
1. In the Railway project, click **New Service** → **GitHub Repo**
2. Choose the same repo and set **Root Directory** to: `backend`
3. Railway should detect Python automatically.
4. **Start Command** (if not detected):  
   `uvicorn server:app --host 0.0.0.0 --port $PORT`
5. Add **Variables** (Service → Variables):
   - `MONGO_URL` = your MongoDB connection string
   - `DB_NAME` = your database name
   - plus any API keys your app uses (if applicable)

Deploy, then open the backend service and copy its **Public URL**.

### C) Create FRONTEND service
1. **New Service** → **GitHub Repo**
2. Root Directory: `frontend`
3. **Build Command** (Settings → Build):  
   `yarn install --frozen-lockfile && yarn build`
4. **Start Command** (Settings → Deploy):  
   `yarn start:prod`
5. Add variable:
   - `REACT_APP_BACKEND_URL` = the Backend Public URL (from the previous step)

Deploy. Your frontend will be publicly accessible from its own Railway URL.

---

## 4) Notes
- If you change variables, Railway will redeploy.
- CORS is enabled in the backend for local + deployed usage.
- If your backend requires additional environment variables, add them in Railway (do not commit `.env`).

