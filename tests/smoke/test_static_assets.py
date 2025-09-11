from fastapi.testclient import TestClient


def test_static_assets_served():
    from tarot_yorum.api import app

    with TestClient(app) as client:
        r1 = client.get("/static/logo.svg")
        assert r1.status_code == 200
        assert r1.headers.get("content-type", "").startswith("image/svg+xml")

        r2 = client.get("/static/theme.css")
        assert r2.status_code == 200
        assert "--brand-primary" in r2.text
