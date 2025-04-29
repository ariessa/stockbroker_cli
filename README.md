# Stockbroker CLI

A command-line tool for managing a stockbroker's trade book.

<br />

## Table of Contents

- [Introduction](#introduction)
- [Run in Batch Mode](#run-in-batch-mode)
- [Run in Interactive Mode](#run-in-interactive-mode)
- [Interactive Mode Commands](#interactive-mode-commands)
    - [Buy](#buy)
    - [Sell](#sell)
    - [Stocks](#stocks)
    - [Help](#help)
    - [History](#history)
    - [Exit](#exit)
- [License](#license)

<br />

## Introduction

Stockbroker CLI is a command-line tool designed to help stockbrokers manage trade orders from investors. The tool allows the user to record buy and sell trades, adjusting the volume of existing orders when necessary or creating new records if no matching trade exists.

The CLI tool persists trade information in a file called orders.csv, and verifies stock codes against a file named `stock_codes.csv`. In case of invalid input, appropriate error messages are shown to guide the user. It offers two modes of operation:

- [Batch mode](#run-in-batch-mode)

    The script can read a file containing a list of trade orders, automatically processing each line of the file. The file should include the trade type (buy or sell), stock code, trade price, and trade volume.

- [Interactive mode](#run-in-interactive-mode)

    The script can be run interactively in the terminal where the user is prompted to input commands for buying stock, selling stock, viewing help message, viewing recent trades from order book, and viewing a list of available stock codes.

<br />

**Example of input validation with error messages**

- Validate trade type

    <img src="/screenshots/validate_trade_type.png"/>

- Validate stock code

    <img src="/screenshots/validate_stock_code.png"/>

- Validate price

    <img src="/screenshots/validate_price.png"/>

- Validate volume

    <img src="/screenshots/validate_volume.png"/>

<br />

## Run in Batch Mode

Running the script in batch mode will add all orders inside the file that is supplied as `<filepath>` into the order book. If there is an existing order that matches the trade type, stock code, and price, it will update the volume of the existing order. Otherwise, it will add new order into the order book.

<br />

**Usage**

```bash
bash stockbroker.sh <filepath>
```

<br />

**Example**

```bash
bash stockbroker.sh files/orders.txt
```

<br />

**Sample Output**

<img src="/screenshots/batch_mode.png"/>

<br />

## Run in Interactive Mode

Running the script in interactive mode allows user to input the following commands:

- [buy](#buy)
- [sell](#sell)
- [stocks](#stocks)
- [help](#help)
- [history](#history)
- [exit](#exit)

<br />

**Usage**

```bash
bash stockbroker.sh
bash stockbroker.sh <flag>
```

<br />

**Example**

```bash
bash stockbroker.sh
bash stockbroker.sh -h
bash stockbroker.sh --help
```

<br />

**Sample Output**

- Without Flag

    <img src="/screenshots/interactive_mode_no_flag.png"/>

<br />

- With Flag

    <img src="/screenshots/interactive_mode_flag_1.png"/>
    
    <img src="/screenshots/interactive_mode_flag_2.png"/>

<br />

## Interactive Mode Commands

### Buy

Record a new buy order or update volume of existing buy order that matches stock code and price.

<br />

**Usage**

```bash
buy <stock_code> <price> <volume>
```

<br />

**Example**

```bash
buy AAPL 999.99 99
buy AAPL 1000.00 100
```

<br />

**Sample Output**

<img src="/screenshots/interactive_mode_buy.png"/>

<br />

### Sell

Record a new sell order or update volume of existing sell order that matches stock code and price.

<br />

**Usage**

```bash
sell <stock_code> <price> <volume>
```

<br />

**Example**

```bash
sell AAPL 999.99 99
sell AAPL 1000.10 100
```

<br />

**Sample Output**

<img src="/screenshots/interactive_mode_sell.png"/>

<br /> 

### Stocks

Show a list of available stock codes.

<br /> 

**Usage**

```bash
stocks
```

<br />

**Example**

```bash
stocks
```

<br />

**Sample Output**

<img src="/screenshots/interactive_mode_stocks.png"/>

<br />

### Help

Show help message.

<br />

**Usage**

```bash
help                                   
```

<br />

**Example**

```bash
help
```

<br />

**Sample Output**

<img src="/screenshots/interactive_mode_help.png"/>

<br />

### History

Show list of recent trades from order book.

<br />

**Usage**

```bash
history
```

<br />

**Example**

```bash
history
```

<br />

**Sample Output**

<img src="/screenshots/interactive_mode_history.png"/>

<br />

### Exit

Exit the program.

<br />

**Usage**

```bash
exit                                   
```

<br />

**Example**

```bash
exit
```

<br />

**Sample Output**

<img src="/screenshots/interactive_mode_exit.png"/>

<br />

## License

Stockbroker CLI is licensed under the [GNU GPLv3 License](LICENSE).
