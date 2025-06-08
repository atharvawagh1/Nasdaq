#!/bin/bash

# Configuration
REPO_PATH="/c/Users/dbda/nasdaq/Nasdaq"  # Updated Git Bash style path
TOTAL_DAYS=50  # Look back over 50 days
CONTRIBUTION_DAYS=15  # Number of days to actually make contributions

cd "$REPO_PATH"

# Generate unique random days
mapfile -t RANDOM_DAYS < <(shuf -i 0-49 -n "$CONTRIBUTION_DAYS" | sort -n)

for DAY_OFFSET in "${RANDOM_DAYS[@]}"; do
    DATE=$(date -d "$DAY_OFFSET days ago" +%Y-%m-%d)

    # Random number of commits on that day
    NUM_COMMITS=$(( (RANDOM % 5) + 1 ))

    for ((j=1; j<=NUM_COMMITS; j++)); do
        echo "Fake commit $j on $DATE" > "$REPO_PATH/private.txt"

        git add .
        GIT_AUTHOR_DATE="$DATE 12:$j:00" GIT_COMMITTER_DATE="$DATE 12:$j:00" \
        git commit -m "Random commit $j on $DATE" --date "$DATE 12:$j:00"
    done

    # Clean up
    rm "$REPO_PATH/private.txt"
done

# Push all commits
git push origin main
