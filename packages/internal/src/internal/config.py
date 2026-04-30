"""Shared configuration helpers."""

import random

WORKSPACE_NAME = "livekit-uv-workspace"

def workspace_display_name() -> str:
    return WORKSPACE_NAME.replace("-", " ").title()

def get_a_number() -> int:
    return random.randint(1, 100)