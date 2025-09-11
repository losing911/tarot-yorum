from __future__ import annotations

import argparse
from datetime import date, datetime

from .service import generate_daily_reading


def _parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Günlük tarot yorumu CLI")
    parser.add_argument(
        "--date",
        type=str,
        help="YYYY-MM-DD formatında tarih (varsayılan: bugün)",
        default=None,
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    ns = _parse_args(argv)
    if ns.date:
        d = datetime.strptime(ns.date, "%Y-%m-%d").date()
    else:
        d = date.today()
    cards, message = generate_daily_reading(d)
    print(message)
    return 0


if __name__ == "__main__":  # pragma: no cover
    raise SystemExit(main())
