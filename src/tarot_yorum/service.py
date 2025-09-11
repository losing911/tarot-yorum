from __future__ import annotations

import hashlib
import random
from datetime import date
from typing import List, Tuple


CARDS: List[str] = [
    "The Fool",
    "The Magician",
    "The High Priestess",
    "The Empress",
    "The Emperor",
    "The Hierophant",
    "The Lovers",
    "The Chariot",
    "Strength",
    "The Hermit",
    "Wheel of Fortune",
    "Justice",
    "The Hanged Man",
    "Death",
    "Temperance",
    "The Devil",
    "The Tower",
    "The Star",
    "The Moon",
    "The Sun",
    "Judgement",
    "The World",
]


def seed_from_date(d: date) -> int:
    # Hash YYYY-MM-DD into a stable int seed
    s = d.isoformat().encode("utf-8")
    h = hashlib.sha256(s).hexdigest()
    return int(h[:16], 16)


def draw_cards(seed: int, n: int = 3) -> List[str]:
    rng = random.Random(seed)
    return rng.sample(CARDS, n)


def generate_daily_reading(d: date) -> Tuple[List[str], str]:
    """Generate a deterministic daily tarot reading for given date.

    Returns a tuple of (cards, message).
    """
    seed = seed_from_date(d)
    cards = draw_cards(seed, 3)
    # Message assembly will be defined by tests to ensure stability
    message = f"Bugünün kartları: {', '.join(cards)}. İçgörü: Dengede kal, niyetini net tut."
    return cards, message
