from __future__ import annotations

from contextlib import contextmanager
from datetime import date as _date, datetime
from pathlib import Path
import os
from typing import Iterator, Optional

from sqlmodel import Field, Session, SQLModel, create_engine, select


# Allow overriding data directory for container platforms (e.g., Render disk mount)
_DEFAULT_DATA_DIR = Path(__file__).resolve().parent.parent / "data"
DATA_DIR = Path(os.environ.get("DATA_DIR", str(_DEFAULT_DATA_DIR)))
DB_PATH = DATA_DIR / "tarot.db"
DB_PATH.parent.mkdir(parents=True, exist_ok=True)
engine = create_engine(f"sqlite:///{DB_PATH}", echo=False)


class Reading(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    date: _date = Field(index=True, unique=True)
    cards_csv: str
    message: str
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)


def init_db() -> None:
    SQLModel.metadata.create_all(engine)


@contextmanager
def get_session() -> Iterator[Session]:
    with Session(engine) as session:
        yield session


def get_reading_for_date(d: _date) -> Optional[Reading]:
    with get_session() as s:
        stmt = select(Reading).where(Reading.date == d)
        return s.exec(stmt).first()


def upsert_reading(d: _date, cards: list[str], message: str) -> Reading:
    now = datetime.utcnow()
    cards_csv = ",".join(cards)
    with get_session() as s:
        obj = s.exec(select(Reading).where(Reading.date == d)).first()
        if obj:
            obj.cards_csv = cards_csv
            obj.message = message
            obj.updated_at = now
        else:
            obj = Reading(date=d, cards_csv=cards_csv, message=message, created_at=now, updated_at=now)
            s.add(obj)
        s.commit()
        s.refresh(obj)
        return obj
