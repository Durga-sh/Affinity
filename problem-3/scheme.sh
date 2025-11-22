
URL="https://portal.amfiindia.com/spages/NAVAll.txt"
OUTPUT_FILE="amfi_nav_data.tsv"

echo "Downloading AMFI NAV data..."

# Download, extract Scheme Name (field 4) and NAV (field 5), save as TSV
curl -s "$URL" | \
awk -F';' '
    BEGIN {
        # Print TSV header
        print "Scheme Name\tNet Asset Value"
    }
    {
        # Skip empty lines
        if (NF == 0 || length($0) == 0) next
        
        # Skip header line
        if ($1 == "Scheme Code") next
        
        # Skip category header lines (they have fewer fields)
        if (NF < 6) next
        
        # Skip lines that are just fund house names
        if ($4 == "" || $5 == "") next
        
        # Extract and clean the data
        scheme_name = $4
        nav = $5
        
        # Remove leading/trailing whitespace
        gsub(/^[ \t]+|[ \t]+$/, "", scheme_name)
        gsub(/^[ \t]+|[ \t]+$/, "", nav)
        
        # Only print if both fields have data
        if (scheme_name != "" && nav != "") {
            print scheme_name "\t" nav
        }
    }
' > "$OUTPUT_FILE"

# Count records extracted
record_count=$(tail -n +2 "$OUTPUT_FILE" | wc -l | tr -d ' ')

echo "Extraction complete!"
echo "Records extracted: $record_count"
echo "Output saved to: $OUTPUT_FILE"
echo ""
echo "First 5 records:"
head -6 "$OUTPUT_FILE" | column -t -s $'\t'