from fastapi.testclient import TestClient


def test_health_root():
    from tarot_yorum.api import app

    with TestClient(app) as client:
        r = client.get("/")
        assert r.status_code == 200
        assert r.json().get("status") == "ok"
