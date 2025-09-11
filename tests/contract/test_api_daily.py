from datetime import date

from fastapi.testclient import TestClient


def test_get_daily_with_explicit_date():
    # Import here so test fails until API exists
    from tarot_yorum.api import app

    client = TestClient(app)
    resp = client.get("/api/daily", params={"date": "2025-09-11"})
    assert resp.status_code == 200
    payload = resp.json()
    # Basic contract: keys and types
    assert set(payload.keys()) == {"date", "cards", "message"}
    assert payload["date"] == "2025-09-11"
    assert isinstance(payload["cards"], list)
    assert len(payload["cards"]) == 3
    assert len(set(payload["cards"])) == 3
    # message should mention the cards
    for c in payload["cards"]:
        assert c in payload["message"]


def test_get_daily_invalid_date_returns_422():
    from tarot_yorum.api import app

    client = TestClient(app)
    resp = client.get("/api/daily", params={"date": "2025-99-99"})
    assert resp.status_code == 422
