import sys
from io import StringIO
from contextlib import redirect_stdout

from tarot_yorum.cli import main


def test_cli_prints_message_with_cards_for_given_date():
    buf = StringIO()
    with redirect_stdout(buf):
        rc = main(["--date", "2025-09-11"])
    out = buf.getvalue().strip()
    assert rc == 0
    # Should begin with Turkish prefix and contain commas
    assert out.startswith("Bugünün kartları:")
    assert "," in out
