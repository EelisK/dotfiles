#!/usr/bin/env python3
import json
import sys
from typing import Final, NotRequired, TypedDict

# Documentation: https://code.claude.com/docs/en/statusline

#   ██████  ▄████▄   ██░ ██ ▓█████  ███▄ ▄███▓ ▄▄▄        ██████
# ▒██    ▒ ▒██▀ ▀█  ▓██░ ██▒▓█   ▀ ▓██▒▀█▀ ██▒▒████▄    ▒██    ▒
# ░ ▓██▄   ▒▓█    ▄ ▒██▀▀██░▒███   ▓██    ▓██░▒██  ▀█▄  ░ ▓██▄
#   ▒   ██▒▒▓▓▄ ▄██▒░▓█ ░██ ▒▓█  ▄ ▒██    ▒██ ░██▄▄▄▄██   ▒   ██▒
# ▒██████▒▒▒ ▓███▀ ░░▓█▒░██▓░▒████▒▒██▒   ░██▒ ▓█   ▓██▒▒██████▒▒
# ▒ ▒▓▒ ▒ ░░ ░▒ ▒  ░ ▒ ░░▒░▒░░ ▒░ ░░ ▒░   ░  ░ ▒▒   ▓▒█░▒ ▒▓▒ ▒ ░
# ░ ░▒  ░ ░  ░  ▒    ▒ ░▒░ ░ ░ ░  ░░  ░      ░  ▒   ▒▒ ░░ ░▒  ░ ░
# ░  ░  ░  ░         ░  ░░ ░   ░   ░      ░     ░   ▒   ░  ░  ░
#       ░  ░ ░       ░  ░  ░   ░  ░       ░         ░  ░      ░
#          ░


class Model(TypedDict):
    id: str
    display_name: str


class Workspace(TypedDict):
    current_dir: str
    project_dir: str
    added_dirs: list[str]


class OutputStyle(TypedDict):
    name: str


class Cost(TypedDict):
    total_cost_usd: float
    total_duration_ms: int
    total_api_duration_ms: int
    total_lines_added: int
    total_lines_removed: int


class CurrentUsage(TypedDict):
    input_tokens: int
    output_tokens: int
    cache_creation_input_tokens: int
    cache_read_input_tokens: int


class ContextWindow(TypedDict):
    total_input_tokens: int
    total_output_tokens: int
    context_window_size: int
    used_percentage: int | None
    remaining_percentage: int | None
    current_usage: CurrentUsage | None


class RateLimitWindow(TypedDict):
    used_percentage: float
    resets_at: int


class RateLimits(TypedDict):
    five_hour: NotRequired[RateLimitWindow]
    seven_day: NotRequired[RateLimitWindow]


class Vim(TypedDict):
    mode: str


class Agent(TypedDict):
    name: str


class Worktree(TypedDict):
    name: str
    path: str
    original_cwd: str
    branch: NotRequired[str]
    original_branch: NotRequired[str]


class ClaudeCodeSession(TypedDict):
    cwd: str
    session_id: str
    transcript_path: str
    model: Model
    workspace: Workspace
    version: str
    output_style: OutputStyle
    cost: Cost
    context_window: ContextWindow
    exceeds_200k_tokens: bool
    session_name: NotRequired[str]
    rate_limits: NotRequired[RateLimits]
    vim: NotRequired[Vim]
    agent: NotRequired[Agent]
    worktree: NotRequired[Worktree]


#  ███▄ ▄███▓ ▄▄▄       ██▓ ███▄    █
# ▓██▒▀█▀ ██▒▒████▄    ▓██▒ ██ ▀█   █
# ▓██    ▓██░▒██  ▀█▄  ▒██▒▓██  ▀█ ██▒
# ▒██    ▒██ ░██▄▄▄▄██ ░██░▓██▒  ▐▌██▒
# ▒██▒   ░██▒ ▓█   ▓██▒░██░▒██░   ▓██░
# ░ ▒░   ░  ░ ▒▒   ▓▒█░░▓  ░ ▒░   ▒ ▒
# ░  ░      ░  ▒   ▒▒ ░ ▒ ░░ ░░   ░ ▒░
# ░      ░     ░   ▒    ▒ ░   ░   ░ ░
#        ░         ░  ░ ░           ░


ANSI_GREEN: Final = "\033[38;5;46m"
ANSI_YELLOW: Final = "\033[38;5;226m"
ANSI_ORANGE: Final = "\033[38;5;208m"
ANSI_RED: Final = "\033[38;5;196m"
ANSI_RESET: Final = "\033[0m"
ANSI_DIM: Final = "\033[2m"


def _format_context_usage(
    session: ClaudeCodeSession,
    *,
    bar_width: int = 10,
    free_block: str = "░",
    used_block: str = "█",
) -> str:
    percentage = session["context_window"]["used_percentage"]
    if percentage is None:
        percentage = 0

    clamped_percentage = max(0, min(100, percentage))

    filled_blocks_count = round(clamped_percentage / 100 * bar_width)
    empty_blocks_count = bar_width - filled_blocks_count

    if clamped_percentage < 50:
        color = ANSI_GREEN
    elif clamped_percentage < 70:
        color = ANSI_YELLOW
    elif clamped_percentage < 85:
        color = ANSI_ORANGE
    else:
        color = ANSI_RED

    bar = (
        f"{color}{used_block * filled_blocks_count}{ANSI_RESET}"
        f"{ANSI_DIM}{free_block * empty_blocks_count}{ANSI_RESET}"
    )

    return f"{bar} {clamped_percentage}%"


def _format_duration(session: ClaudeCodeSession) -> str:
    duration_sec = session["cost"]["total_duration_ms"] // 1000
    days, remainder = divmod(duration_sec, 86400)
    hours, remainder = divmod(remainder, 3600)
    mins, secs = divmod(remainder, 60)

    if days:
        return f"{days}d {hours}h {mins}m"
    if hours:
        return f"{hours}h {mins}m {secs}s"
    return f"{mins}m {secs}s"


def _format_cost(session: ClaudeCodeSession) -> str:
    return f"${session['cost']['total_cost_usd']:.2f}"


def _format_model(session: ClaudeCodeSession) -> str:
    return f"[{session['model']['display_name']}]"


def _format(session: ClaudeCodeSession) -> str:
    return " | ".join(
        (
            _format_model(session),
            _format_cost(session),
            _format_duration(session),
            _format_context_usage(session),
        )
    )


def main() -> None:
    session: ClaudeCodeSession = json.load(sys.stdin)
    print(_format(session))


if __name__ == "__main__":
    main()
