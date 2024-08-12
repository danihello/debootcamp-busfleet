#!/usr/bin/env bash
set -eu

main() {
    export TOP_DIR=$(git rev-parse --show-toplevel)

    # Lint Python
    black "${TOP_DIR}"

    # Setup dbt
    #dbt deps --project-dir "${TOP_DIR}"/dbt/warehouse

    # Lint SQL
    sqlfluff fix -f "${TOP_DIR}"/dbt/warehouse --exclude-rules L009,L010,L011,L012,L013,L014,L015,L016,L017,L018,L019,L020,L021,L022,L023,L024,L025,L026,L027,L028,L029,L030,L031,L032,L033,L034,L035,L036,L037,L038,L039,L040,L041,L042,L043,L044,L045,L046,L047,L048,L049,L050,L051,L052,L053,L054,L055,L056,L057,L058,L

    # If the linter produce diffs, fail the linter
    if [ -z "$(git status --porcelain)" ]; then 
        echo "Working directory clean, linting passed"
        exit 0
    else
        echo "Linting failed. Please commit these changes:"
        git --no-pager diff HEAD
        exit 1
    fi

}

main




