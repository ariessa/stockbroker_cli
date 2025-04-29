#!/bin/bash

# ============================================
# Stockbroker CLI
# Author: Ariessa Norramli
# Created: 2025-04-29
# Description: A command-line tool for managing a stockbroker's trade book.
# Version: 1.0.0
# 
# Usage:
#    Batch mode:
#        bash stockbroker.sh <filepath>
#    Interactive mode:
#        bash stockbroker.sh <flag>
#        bash stockbroker.sh
#
# Arguments:
#    Batch mode:
#        <filepath>                         A list of trade type, stock code, price and volume.
#           files/orders.txt                The file should have either space-separated values or comma-separated values.
#    Interactive mode:
#        <flag>                             A flag to display help message.
#           -h, --help
#
# Commands (interactive mode only):
#    buy <stock_code> <price> <volume>      Record a new buy order or update volume of existing order.
#    sell <stock_code> <price> <volume>     Record a new sell order or update volume of existing order.
#    stocks                                 Show list of available stock codes.
#    help                                   Show help message.
#    history                                Show list of recent trades from order book.
#    exit                                   Exit the program.
#
# Example:
#    Batch mode:
#        $ bash stockbroker.sh files/orders.txt
#    Interactive mode:
#        $ bash stockbroker.sh --help
#        $ bash stockbroker.sh -h
#        $ bash stockbroker.sh
#        
#        Inside interactive mode only:
#            $ buy GOOGL 1000.00 100
#            $ sell AAPL 1000.00 100
#            $ stocks
#            $ help
#            $ history
#            $ exit
#
# Note:
#     All files used in this script must have an extra line after the last element.
#
# License: GNU GPLv3
# ============================================
# 
# Copyright (c) 2025 Ariessa Norramli
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# ============================================


# Colours
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Files
ORDER_BOOK='files/orders.csv'
STOCK_CODE_BOOK='files/stock_codes.csv'

# Directories
BACKUP_DIRECTORY='backups'

# Stock codes
stock_codes=()

# Orders
orders=()

print_help() {
    printf "\n"
    printf "Stockbroker CLI"
    printf "\n"
    printf "Developed by Ariessa Norramli - 2025"
    printf "\n"
    printf "\n"
    printf "Usage"
    printf "\n"
    printf "    ./stockbroker.sh [orders.txt]"
    printf "\n"
    printf "\n"
    printf "Description"
    printf "\n"
    printf "    Command-line stock trade book recorder."
    printf "\n"
    printf "    Supports both interactive mode and batch file mode."
    printf "\n"
    printf "\n"    
    printf "Modes"
    printf "\n"
    printf "    No argument     Start interactive mode."
    printf "\n"
    printf "    [orders.txt]    Read and process a file line-by-line."
    printf "\n"
    printf "\n"
    printf "Commands (interactive mode only)"
    printf "\n"
    printf "    buy <stock_code> <price> <volume>   Record a buy order."
    printf "\n"
    printf "    sell <stock_code> <price> <volume>  Record a sell order."
    printf "\n"
    printf "    stocks                              Show list of available stock codes."
    printf "\n"
    printf "    help                                Show this help message."
    printf "\n"
    printf "    history                             Show list of recent trades from order book."
    printf "\n"
    printf "    exit                                Exit the program."
    printf "\n"
    printf "\n"
    printf "Example"
    printf "\n"
    printf "    $ buy AAPL 1000.00 100"
    printf "\n"
    printf "\n"
}

is_valid_stockcode() {
    local code="$1"

    for s in "${stock_codes[@]}"; do
        if [[ "$s" == "$code" ]]; then
            return 0
        fi
    done

    return 1
}

load_stockcodes() {
    if [[ ! -f $STOCK_CODE_BOOK ]]; then
        printf "\n${RED}Missing $STOCK_CODE_BOOK file!${NC}\n"
        exit 1
    fi

    # Warning: 
    # - Stock code book file needs to end with empty line.
    #   If not, it will not read the last line.
    while IFS= read -r code; do
        stock_codes+=("$code")
    done < $STOCK_CODE_BOOK
}

load_orders() {
    if [[ -f $ORDER_BOOK ]]; then
        # Warning: 
        # - Order book file needs to end with empty line.
        #   If not, it will not read the last line.
        while IFS= read -r line; do
            orders+=("$line")
        done < $ORDER_BOOK
    else
        # Create order book if it does not exist
        mkdir -p "$ORDER_BOOK"
    fi
}

display_headers() {
    printf "\n"
    printf "Stockbroker CLI"
    printf "\n"
    printf "Developed by Ariessa Norramli - 2025"
    printf "\n"
    printf "\n"
    printf "Type 'help' for usage"
    printf "\n"
    printf "\n"
}

save_orders() {
    # Back up existing orders before saving new order
    if [[ -f $ORDER_BOOK ]]; then
        # Get current timestamp
        timestamp=$(date +%Y%m%d%H%M%S)

        # Create backup directory if it does not exist
        mkdir -p "$BACKUP_DIRECTORY"

        # Create backup file for current orders
        cp $ORDER_BOOK "${BACKUP_DIRECTORY}/orders_backup_$timestamp.csv"

        if [[ $? -ne 0 ]]; then
            printf "\n${RED}Failed to create backup of orders.csv!${NC}\n"
            return 1
        else
            printf "\n${YELLOW}Created backup file: ${BACKUP_DIRECTORY}/orders_backup_$timestamp.csv${NC}\n\n"
        fi
    fi

    printf "%s\n" "${orders[@]}" > $ORDER_BOOK

    if [[ $? -eq 0 ]]; then
        printf "\n${GREEN}Saved orders successfully.${NC}\n\n"
    else
        printf "\n${RED}Failed to save orders!${NC}\n\n"
    fi
}

process_order() {
    trade_type=$1
    stock_code=$2
    price=$3
    volume=$4

    # Validate trade_type (must be either buy or sell)
    if [[ "$trade_type" != "buy" && "$trade_type" != "sell" ]]; then
        printf "\n${RED}Invalid trade_type: $trade_type. Must be 'buy' or 'sell'.${NC}\n\n"
        continue
    fi

    # Validate stock code exists in stock_codes array
    found=0
    for code in "${stock_codes[@]}"; do
        if [[ "$code" == "$stock_code" ]]; then
            found=1
            break
        fi
    done

    if [[ $found -ne 1 ]]; then
        printf "\n${RED}Invalid stock code: $stock_code${NC}\n\n"
        continue
    fi

    # Validate price format (number with 2 decimal places, min 0.50)
    if ! [[ "$price" =~ ^[0-9]+\.[0-9]{2}$ ]] || (( $(echo "$price < 0.50" | bc -l) )); then
        printf "\n${RED}Invalid price: $price. Must be a number with 2 decimal places, min 0.50.${NC}\n\n"
        continue
    fi

    # Validate volume is number between 1 and 1000000
    if ! [[ "$volume" =~ ^[0-9]+$ ]] || (( volume < 1 || volume > 1000000 )); then
        printf "\n${RED}Invalid volume: $volume. Must be between 1 and 1,000,000.${NC}\n\n"
        continue
    fi

    # Find existing trade in tradebook
    local updated=0
    local current_volume=0
    local updated_volume=0
    for i in "${!orders[@]}"; do
        IFS=, read -r t s p v <<< "${orders[$i]}"
        if [[ "$t" == "$trade_type" && "$s" == "$stock_code" && "$p" == "$price" ]]; then
            current_volume=$v
            # Update volume
            v=$((v + volume))
            orders[$i]="$t,$s,$p,$v"
            updated=1
            updated_volume=$v
            break
        fi
    done

    if [[ "$updated" -eq 1 ]]; then
        printf "\n${YELLOW}Updated trade in order book.${NC}\n\n"
        printf "\nBefore\n"
        printf "$trade_type,$stock_code,$price,$current_volume"
        printf "\n\nAfter\n"
        printf "$trade_type,$stock_code,$price,$updated_volume"
        printf "\n\n"
    else
        orders+=("$trade_type,$stock_code,$price,$volume")
        printf "\n${GREEN}Added new trade in order book.${NC}\n\n"
        printf "\nNew Trade\n"
        printf "$trade_type,$stock_code,$price,$volume"
        printf "\n\n"
    fi

    save_orders
}

# Main program
load_stockcodes
load_orders

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    print_help
    exit 0
fi

if [[ $# -gt 1 ]]; then
    printf "\n${RED}Invalid usage.${NC}\n\n"
    print_help
    exit 1
fi

display_headers

# Batch mode
if [[ $# -eq 1 ]]; then
    filepath=$1
    if [[ ! -f $filepath ]]; then
        printf "\n${RED}File not found: $filepath${NC}\n\n"
        exit 1
    fi

    while IFS= read -r line; do
        # Skip empty or comment lines
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        # Detect delimiter and parse line
        if [[ "$line" == *","* ]]; then
            IFS=',' read -r trade_type stock_code price volume <<< "$line"
        else
            IFS=' ' read -r trade_type stock_code price volume <<< "$line"
        fi

        process_order "$trade_type" "$stock_code" "$price" "$volume"
    done < "$filepath"

    exit 0
fi

# Interactive mode
while true; do
    printf "$ "
    read -r input

    if [[ -z "$input" ]]; then
        continue
    fi

    if [[ "$input" == "exit" ]]; then
        printf "\nThank you for using Stockbroker CLI!\n\n"
        exit 0
    elif [[ "$input" == "help" ]]; then
        print_help
        continue
    elif [[ "$input" == "history" ]]; then
        printf "\n${YELLOW}Recent trades${NC}\n"

        for o in "${orders[@]}"; do
            printf "%s\n" "$o"
        done

        printf "\n"
        continue
    elif [[ "$input" == "stocks" ]]; then
        printf "\n${YELLOW}Available Stock Codes${NC}\n"

        for c in "${stock_codes[@]}"; do
            printf "%s\n" "$c"
        done

        printf "\n"
        continue
    fi

    # Read the input
    read -r -a parts <<< "$input"

    # Validate part count
    if [[ "${#parts[@]}" -ne 4 ]]; then
        printf "\n${RED}Invalid input format. Expected: <buy|sell> <stock_code> <price> <volume>${NC}\n\n"
        continue
    fi

    trade_type="${parts[0]}"
    stock_code="${parts[1]}"
    price="${parts[2]}"
    volume="${parts[3]}"

    process_order "$trade_type" "$stock_code" "$price" "$volume"
done
