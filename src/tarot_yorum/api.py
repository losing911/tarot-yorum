from __future__ import annotations

import os
from datetime import date as _date, datetime
from pathlib import Path
from typing import Optional

from fastapi import Depends, FastAPI, Form, HTTPException, Query, Request, Response
from contextlib import asynccontextmanager
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles

from .db import get_reading_for_date, init_db, upsert_reading
from .service import generate_daily_reading


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    init_db()
    yield
    # Shutdown (no-op)


app = FastAPI(title="Tarot Yorum API", lifespan=lifespan)


# Templates directory inside package
_TEMPLATES_DIR = Path(__file__).parent / "web_templates"
templates = Jinja2Templates(directory=str(_TEMPLATES_DIR))
_STATIC_DIR = Path(__file__).parent / "web_static"
app.mount("/static", StaticFiles(directory=str(_STATIC_DIR)), name="static")


def _require_admin(request: Request):
    if request.cookies.get("admin") != "1":
        raise HTTPException(status_code=401, detail="Unauthorized")


@app.get("/")
def health():
    return {"status": "ok"}


@app.get("/api/daily")
def get_daily(date: Optional[str] = Query(None, description="YYYY-MM-DD")):
    if date is None:
        d = _date.today()
    else:
        try:
            d = datetime.strptime(date, "%Y-%m-%d").date()
        except ValueError:
            raise HTTPException(status_code=422, detail="Invalid date format, expected YYYY-MM-DD")

    # read from DB or generate & upsert
    rec = get_reading_for_date(d)
    if rec is None:
        cards, message = generate_daily_reading(d)
        rec = upsert_reading(d, cards, message)
    else:
        cards = rec.cards_csv.split(",")
        message = rec.message
    return {"date": d.isoformat(), "cards": cards, "message": message}


# --- Admin UI ---

@app.get("/admin/login", response_class=HTMLResponse)
def admin_login_get(request: Request):
    return templates.TemplateResponse("login.html", {"request": request, "error": None})


@app.post("/admin/login")
def admin_login_post(password: str = Form(...)):
    admin_pw = os.environ.get("ADMIN_PASSWORD", "admin123")
    if password != admin_pw:
        # redirect back with error via query
        resp = RedirectResponse(url="/admin/login?error=1", status_code=302)
        return resp
    resp = RedirectResponse(url="/admin", status_code=302)
    resp.set_cookie("admin", "1", httponly=True, samesite="lax")
    return resp


@app.get("/admin", response_class=HTMLResponse)
def admin_dashboard(request: Request):
    # auth
    if request.cookies.get("admin") != "1":
        return RedirectResponse(url="/admin/login", status_code=302)

    qs_date = request.query_params.get("date")
    if qs_date:
        try:
            d = datetime.strptime(qs_date, "%Y-%m-%d").date()
        except ValueError:
            d = _date.today()
    else:
        d = _date.today()

    rec = get_reading_for_date(d)
    if rec is None:
        cards, message = generate_daily_reading(d)
    else:
        cards = rec.cards_csv.split(",")
        message = rec.message

    return templates.TemplateResponse(
        "dashboard.html",
        {
            "request": request,
            "date": d.isoformat(),
            "cards": cards,
            "message": message,
        },
    )


@app.post("/admin/update")
def admin_update(request: Request, date: str = Form(...), message: str = Form(...)):
    if request.cookies.get("admin") != "1":
        return RedirectResponse(url="/admin/login", status_code=302)
    try:
        d = datetime.strptime(date, "%Y-%m-%d").date()
    except ValueError:
        return RedirectResponse(url="/admin?error=1", status_code=302)

    # Preserve existing cards or generate if not stored
    rec = get_reading_for_date(d)
    if rec is None:
        cards, _ = generate_daily_reading(d)
    else:
        cards = rec.cards_csv.split(",")
    upsert_reading(d, cards, message)
    return RedirectResponse(url=f"/admin?date={d.isoformat()}&saved=1", status_code=302)
