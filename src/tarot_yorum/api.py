from __future__ import annotations

from datetime import date as _date, datetime
from typing import Optional

from fastapi import FastAPI, Query

from .service import generate_daily_reading


app = FastAPI(title="Tarot Yorum API")


@app.get("/api/daily")
def get_daily(date: Optional[str] = Query(None, description="YYYY-MM-DD")):
    if date is None:
        d = _date.today()
    else:
        try:
            d = datetime.strptime(date, "%Y-%m-%d").date()
        except ValueError:
            # FastAPI validation would normally catch this with Pydantic types,
            # but we keep explicit check for clarity and to allow 422.
            from fastapi import HTTPException

            raise HTTPException(status_code=422, detail="Invalid date format, expected YYYY-MM-DD")
    cards, message = generate_daily_reading(d)
    return {"date": d.isoformat(), "cards": cards, "message": message}
