# 1. Command-line Arguments and Quoting
SRC_DIR="$1"
DEST_DIR="$2"
EXT="$3"

# Validate arguments
if [[ $# -ne 3 ]]; then
    echo "Usage: $0 \"source_directory\" \"backup_directory\" \"file_extension (.txt, .log, etc.)\""
    exit 1
fi

# Check if source directory exists
if [[ ! -d "$SRC_DIR" ]]; then
    echo "Error: Source directory '$SRC_DIR' does not exist."
    exit 1
fi

# 5. Conditional Execution(Create backup directory if needed)
if [[ ! -d "$DEST_DIR" ]]; then shopt -s nullglob   # prevents bugs/0-matching error if no match
    echo "Backup directory not found. Creating: $DEST_DIR"
    mkdir -p "$DEST_DIR"

    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to create backup directory."
        exit 1
    fi
fi

# 2,4. Globbing + Store files in an array
shopt -s nullglob   # prevents zero matching of files

file_array=( "$SRC_DIR"/*"$EXT" )

# Check if any files exist
if [[ ${#file_array[@]} -eq 0 ]]; then
    echo "No files with extension '$EXT' found in $SRC_DIR."
    exit 0
fi

echo "Files to be backed up:"
total_size=0

for file in "${file_array[@]}"; do
    size=$(stat -c%s "$file")
    echo "  - $(basename "$file") (${size} bytes)"
    total_size=$(( total_size + size ))
done

# 3. Export BACKUP_COUNT
export BACKUP_COUNT=0

echo
echo "Starting backup..."

for src_file in "${file_array[@]}"; do
    base=$(basename "$src_file")
    dest_file="$DEST_DIR/$base"

    # --- Overwrite only if source is newer ---
    if [[ -f "$dest_file" ]]; then
        if [[ "$src_file" -nt "$dest_file" ]]; then
            cp "$src_file" "$dest_file"
            echo "Updated: $base"
            BACKUP_COUNT=$(( BACKUP_COUNT + 1 ))
        else
            echo "Skipped (up-to-date): $base"
        fi
    else
        cp "$src_file" "$dest_file"
        echo "Copied: $base"
        BACKUP_COUNT=$(( BACKUP_COUNT + 1 ))
    fi
done

export BACKUP_COUNT

# 6. Summary Report
REPORT_FILE="$DEST_DIR/backup_report.log"

{
echo "Backup Summary Report"
echo "------------------------"
echo "Total files processed: ${#file_array[@]}"
echo "Total files backed up: $BACKUP_COUNT"
echo "Total size of matched files: $total_size bytes"
echo "Backup directory: $DEST_DIR"
echo "Date: $(date)"
} > "$REPORT_FILE"

echo
echo "Backup complete."
echo "Report saved to: $REPORT_FILE"

