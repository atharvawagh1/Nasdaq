#!/bin/bash

# Configuration
REPO_PATH="/c/Users/dbda/nasdaq/Nasdaq"  # Updated repo path
TOTAL_DAYS=20       # Total days range
MIN_COMMITS=5       # Minimum random commit days within 20 days
MAX_COMMITS=10      # Maximum random commit days within 20 days

cd "$REPO_PATH" || exit 1

# Generate a random number of commit days between MIN_COMMITS and MAX_COMMITS
NUM_COMMIT_DAYS=$((RANDOM % (MAX_COMMITS - MIN_COMMITS + 1) + MIN_COMMITS))

# Pick random unique days within the past 20 days
commit_days=()
while [ "${#commit_days[@]}" -lt "$NUM_COMMIT_DAYS" ]; do
    day=$((RANDOM % TOTAL_DAYS))
    # Check uniqueness
    if [[ ! " ${commit_days[*]} " =~ " $day " ]]; then
        commit_days+=("$day")
    fi
done

# Sort the days in ascending order (optional)
IFS=$'\n' sorted_days=($(sort -n <<<"${commit_days[*]}"))
unset IFS

# Make commits on those random days
for day in "${sorted_days[@]}"; do
    # Calculate the date for the commit (day days ago)
    commit_date=$(date -d "$day days ago" '+%Y-%m-%dT12:00:00')

    # Update a dummy file to commit
    echo "Commit on $commit_date" >> private.txt

    # Set environment variables for commit date/time
    GIT_AUTHOR_DATE="$commit_date" GIT_COMMITTER_DATE="$commit_date" git add private.txt
    GIT_AUTHOR_DATE="$commit_date" GIT_COMMITTER_DATE="$commit_date" git commit -m "Random commit on $commit_date"
done
