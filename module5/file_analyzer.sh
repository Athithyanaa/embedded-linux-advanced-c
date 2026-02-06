ERROR_LOG="errors.log"

show_help() {
cat <<END
Usage: $0 [OPTIONS]

Options:
  -d <directory>     Directory to recursively search
  -k <keyword>       Keyword to search inside files
  -f <file>          Search keyword in a specific file
  --help             Display this help menu

Examples:
  $0 -d logs -k error
  $0 -f script.sh -k TODO
END
}
# error.log
log_error() {
    echo "[ERROR] $1" | tee -a "$ERROR_LOG"
}

myfun() {
    local dir="$1"
    for item in "$dir"/*; do
        if [[ -d "$item" ]]; then
            myfun "$item"
        elif [[ -f "$item" ]]; then
            if grep -Iq . "$item" && grep -qi "$keyword" "$item"; then
                echo "Found in: $item"
            fi
        fi
    done
}
# Handle --help
if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

while getopts ":d:k:f:" opt; do
    case "$opt" in
        d) directory="$OPTARG" ;;
        k) keyword="$OPTARG" ;;
        f) file="$OPTARG" ;;
        \?) log_error "Invalid option: -$OPTARG"; exit 1 ;;
        :)  log_error "Missing value for -$OPTARG"; exit 1 ;;
    esac
done

# Validate keyword (simple-regex)
if [[ -n "$keyword" && ! "$keyword" =~ ^[A-Za-z0-9_]+$ ]]; then
    log_error "Invalid keyword: $keyword"
    exit 1
fi

if [[ -n "$file" ]]; then
    if [[ ! -f "$file" ]]; then
        log_error "File does not exist: $file"
        exit 1
    fi

    echo "Searching "$keyword" in file: $file"
    grep -Iq . "$file" && grep -ni "$keyword" "$file"
    echo "Exit status: $?"
    exit 0
fi

if [[ -n "$directory" ]]; then
    if [[ ! -d "$directory" ]]; then
        log_error "Directory not found: $directory"
        exit 1
    fi

    echo "Searching recursively in: $directory"
    echo "Arguments passed: $@"
    echo "Count: $#"

    myfun "$directory"
    exit 0
fi

log_error "No valid arguments. Use --help"
exit 1
