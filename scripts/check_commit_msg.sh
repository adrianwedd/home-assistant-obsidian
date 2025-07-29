#!/bin/bash
# Validate commit message against the new sophisticated format
# Expected format: EMOJI {category}: {elegant-description}
# Optional: Co-Authored-By: Name <email@example.com>

msg_file="$1"
commit_message=$(cat "$msg_file")

# Define allowed emojis and categories
# Emojis: 🏗️, 🎯, ✨, 🩹, 🔒, 📚, 🧹, 🚀, 🔄, 🧪, 🎭, 🌟, 💎, 🎨, 🧠, ⚡, 🛡️, 🎪, 💝, 🚨
# Categories: architect, enhance, create, heal, secure, document, refine, deploy, configure, experiment, style

# Regex for the first line: EMOJI {category}: {description}
# Using Unicode property escapes for emojis (requires grep -P)
# Note: The specific emojis are hardcoded for simplicity, but a more robust solution might involve a list.
EMOJI_REGEX="(\xe2\x9a\x92|\xf0\x9f\x8e\xaf|\xe2\x9c\xa8|\xf0\x9f\xa7\xb9|\xf0\x9f\x94\x92|\xf0\x9f\x93\x9a|\xf0\x9f\x9a\xba|\xf0\x9f\x9a\x80|\xf0\x9f\x94\x83|\xf0\x9f\xa7\xaa|\xf0\x9f\x8e\xad|\xf0\x9f\x8c\x9f|\xf0\x9f\x92\x8e|\xf0\x9f\x8e\xa8|\xf0\x9f\xa7\xa0|\xe2\x9a\xa1|\xf0\x9f\x9b\xa1|\xf0\x9f\x8f\x9a|\xf0\x9f\x92\x8c|\xf0\x9f\x9a\xa8)"
CATEGORY_REGEX="(architect|enhance|create|heal|secure|document|refine|deploy|configure|experiment|style)"
FIRST_LINE_REGEX="^${EMOJI_REGEX} ${CATEGORY_REGEX}: .+"

if ! echo "$commit_message" | head -n 1 | grep -qP "$FIRST_LINE_REGEX"; then
    echo "Error: Commit message first line does not follow the format 'EMOJI category: description'." >&2
    echo "Allowed emojis: 🏗️, 🎯, ✨, 🩹, 🔒, 📚, 🧹, 🚀, 🔄, 🧪, 🎭, 🌟, 💎, 🎨, 🧠, ⚡, 🛡️, 🎪, 💝, 🚨" >&2
    echo "Allowed categories: architect, enhance, create, heal, secure, document, refine, deploy, configure, experiment, style" >&2
    exit 1
fi

# Optional: Validate Co-Authored-By line if present
if echo "$commit_message" | grep -qE '^Co-Authored-By: .+ <.+@.+\..+>
    # Co-Authored-By line is present and correctly formatted
    :
elif echo "$commit_message" | grep -qE '^Co-Authored-By:'; then
    echo "Error: Co-Authored-By line is present but incorrectly formatted." >&2
    echo "Expected format: 'Co-Authored-By: Name <email@example.com>'" >&2
    exit 1
fi

exit 0
; then
    # Co-Authored-By line is present and correctly formatted
    :
elif echo "$commit_message" | grep -qE '^Co-Authored-By:'; then
    echo "Error: Co-Authored-By line is present but incorrectly formatted." >&2
    echo "Expected format: 'Co-Authored-By: Name <email@example.com>'" >&2
    exit 1
fi

exit 0
