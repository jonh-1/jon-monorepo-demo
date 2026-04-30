"""Shared configuration helpers."""

WORKSPACE_NAME = "livekit-uv-workspace"


def workspace_display_name() -> str:
    return WORKSPACE_NAME.replace("-", " ").title()

def say_hello(name: str) -> str:
    return f"hello, {name}!"

def get_a_number() -> int:
    return 2