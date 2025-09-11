from datetime import date

from fastapi.testclient import TestClient


def test_admin_login_and_update_message(monkeypatch):
    # Ensure known password
    monkeypatch.setenv("ADMIN_PASSWORD", "secret")

    from tarot_yorum.api import app

    with TestClient(app) as client:
        # Wrong password -> redirect to login with error
        resp = client.post("/admin/login", data={"password": "wrong"}, follow_redirects=False)
        assert resp.status_code in (302, 303)
        assert "/admin/login" in resp.headers["Location"]

        # Correct password -> set cookie and redirect to /admin
        resp = client.post("/admin/login", data={"password": "secret"}, follow_redirects=False)
        assert resp.status_code in (302, 303)
        assert resp.headers["location"].endswith("/admin")
        # Cookie should be set
        assert "admin=1" in resp.headers.get("set-cookie", "")

        # Client maintains cookies; update a specific date message
        d = date(2025, 9, 12)
        new_msg = "Bugün niyetini güçlendir."  # Turkish text
        resp = client.post("/admin/update", data={"date": d.isoformat(), "message": new_msg}, follow_redirects=False)
        assert resp.status_code in (302, 303)

        # Verify via public API
        j = client.get("/api/daily", params={"date": d.isoformat()}).json()
        assert j["date"] == d.isoformat()
        assert new_msg in j["message"]
