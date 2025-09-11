from datetime import date

from tarot_yorum.service import generate_daily_reading, seed_from_date


def test_seed_from_date_is_stable():
    d = date(2025, 9, 11)
    assert seed_from_date(d) == seed_from_date(d)


def test_generate_daily_reading_returns_three_distinct_cards():
    d = date(2025, 9, 11)
    cards, message = generate_daily_reading(d)
    assert len(cards) == 3
    assert len(set(cards)) == 3
    # message should mention all card names
    for c in cards:
        assert c in message
