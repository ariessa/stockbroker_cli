# Stockbroker CLI

This repository is a technical test for a Senior Back-end Software Engineer role.

<br />

## Table of Contents

- [Technical Test](#technical-test)
- [Solution](#solution)
    - [Run in Batch Mode](#run-in-batch-mode)
        - [Usage](#usage)
        - [Example](#example)
        - [Sample](#sample)
    - [Run in Interactive Mode](#run-in-interactive-mode)
        - [Usage](#usage-1)
        - [Example](#example-1)
        - [Sample](#sample-1)
        - [Interactive Mode Commands](#interactive-mode-commands)
            - [Buy](#buy)
                - [Usage](#usage-2)
                - [Example](#example-2)
                - [Sample](#sample-2)
            - [Sell](#sell)
                - [Usage](#usage-3)
                - [Example](#example-3)
                - [Sample](#sample-3)
            - [Stocks](#stocks)
                - [Usage](#usage-4)
                - [Example](#example-4)
                - [Sample](#sample-4)
            - [Help](#help)
                - [Usage](#usage-5)
                - [Example](#example-5)
                - [Sample](#sample-5)
            - [History](#history)
                - [Usage](#usage-6)
                - [Example](#example-6)
                - [Sample](#sample-6)
            - [Exit](#exit)
                - [Usage](#usage-7)
                - [Example](#example-7)
                - [Sample](#sample-7)
- [License](#license)

<br />

## Technical Test

<details>
<summary>Overview</summary>

A stockbroker needs to keep track of trade coming from investors and record them to trade books. If there is any existing trade book for any incoming order, then the stockbroker needs to increase or decrease the volume of the order. If there’s no existing trade book, then the stockbroker needs to create one.

A trade book is a record entry, which has the following data:

- Trade action (buy or sell)
- A stock code
- Trade price
- The volume of the trade

</details>

<details>
<summary>Problem Statement</summary>

Create a command-line application to record incoming trade from investors. To record an order via a command line, a user shall issue a command with parameters of action of the trade (it is either buy or sell), the stock code, the price of the trade, and the volume of the trade.

On receiving a trade, the application shall check whether any existing trade book for that stock code with the same trade action and trade price. If there is, then the application will adjust the volume of the trade book of that stock code. The adjustment shall be made depending on the incoming trade action and its volume.

If the application does not find any trade book with the same stock code, trade action, and trade price, then the application will create a new trade book. If the stock code supplied is not valid, it will reject the trade order. A valid stock code means that a stock code can be found in a file `stockcode.csv` file, as explained below.

The application can be executed in two modes. The first mode, called the interactive mode, is when the command line application is invoked without a parameter. When the application is invoked, it will show a character `$` as a prompt waiting for user input. The application will exit if it receives a command `exit` on the prompt.

The second mode is when the application is invoked with 1 parameter. The parameter is a file path location to a text file, where the application shall read and process the text file line by line. Each line contains the trade order separated by a space character.

The application persists the data into files. The application shall read two files, `stockcode.csv` and `orders.csv`. The application shall read the files on start-up. The file `stockcode.csv` contains all the valid stock codes, one stock code per line. The file `orders.csv` contains trade orders, one trade book per line. That means each line has the trade action, stock code, trade price, and trade volume, separated by commas.

<br />

A sample of 2 lines in file `stockcode.csv`:

```
AAPL
GOOGL
```

A sample of 2 lines in file `orders.csv`:

```
buy,AAPL,1000.00,100
sell,AAPL,1000.10,10
```

</details>

<details>
<summary>Constraints</summary>

- Stock code is a 4 letter code.
- Stock code is all upper case.
- A trade price is a number with 2 decimal points, with a minimum of 0.50.
- A trade volume is a number between 1 to 1,000,000.
- The application must be invoked by calling `stockbroker.sh` Linux shell, or `stockbroker.bat` on Windows.

</details>

<details>
<summary>Examples</summary>

Example of invoking the application by supplying a file path to read:

```
>./stockbroker.sh orders.txt
```

Example of executing the application in an interactive mode:

```
>./stockbroker.sh
$
```

Example of a trade that is input via a command line:

```
$ buy AAPL 1000.00 100
Trade book added.
```

Where `buy` is the trade action, `AAPL` is the stock code, `1000.00` is the trade price, and finally, `100` is the volume of the trade.

</details>

<br />

## Solution

Stockbroker CLI is a command-line tool designed to help stockbrokers manage trade orders from investors. The tool allows the user to record buy and sell trades, adjusting the volume of existing orders when necessary or creating new records if no matching trade exists.

The CLI tool persists trade information in a file called orders.csv, and verifies stock codes against a file named `stock_codes.csv`. In case of invalid input, appropriate error messages are shown to guide the user.

It offers two modes of operation:

- [Batch mode](#run-in-batch-mode)

    The script can read a file containing a list of trade orders, automatically processing each line of the file. The file should include the trade action (buy or sell), stock code, trade price, and trade volume.

- [Interactive mode](#run-in-interactive-mode)

    The script can be run interactively in the terminal where the user is prompted to input commands for buying, selling, and viewing help.

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

### Run in Batch Mode

Running the script in batch mode will add all orders inside the file that is supplied as `<filepath>` into the order book.

If there is an existing order that matches the trade type, stock code, and price, it will update the volume of the existing order. Otherwise, it will add new order into the order book.

<br />

#### Usage

```bash
bash stockbroker.sh <filepath>
```

<br />

#### Example

```bash
bash stockbroker.sh files/orders.txt
```

<br />

#### Sample Output

<img src="/screenshots/batch_mode.png"/>

<br />

### Run in Interactive Mode

Running the script in interactive mode 

<br />

#### Usage

```bash
bash stockbroker.sh
bash stockbroker.sh <flag>
```

<br />

#### Example

```bash
bash stockbroker.sh
bash stockbroker.sh -h
bash stockbroker.sh --help
```

<br />

#### Sample Output

##### Without Flag

<img src="/screenshots/interactive_mode_no_flag.png"/>

<br />

##### With Flag

<img src="/screenshots/interactive_mode_flag_1.png"/>

<img src="/screenshots/interactive_mode_flag_2.png"/>

<br />

#### Interactive Mode Commands

##### Buy

Record a new buy order or update volume of existing buy order that matches stock code and price..

<br />

###### Usage

```bash
buy <stock_code> <price> <volume>
```

<br />

###### Example

```bash
buy AAPL 999.99 99
buy AAPL 1000.00 100
```

<br />

###### Sample Output

<img src="/screenshots/interactive_mode_buy.png"/>

<br />

##### Sell

Record a new sell order or update volume of existing sell order that matches stock code and price.

<br />

###### Usage

```bash
sell <stock_code> <price> <volume>
```

<br />

###### Example

```bash
sell AAPL 999.99 99
sell AAPL 1000.10 100
```

<br />

###### Sample Output

<img src="/screenshots/interactive_mode_sell.png"/>

<br /> 

##### Stocks

Show a list of available stock codes.

<br /> 

###### Usage

```bash
stocks
```

<br />

###### Example

```bash
stocks
```

<br />

###### Sample Output

<img src="/screenshots/interactive_mode_stocks.png"/>

<br />

##### Help

Show help message.

<br />

###### Usage

```bash
help                                   
```

<br />

###### Example

```bash
help
```

<br />

###### Sample Output

<img src="/screenshots/interactive_mode_help.png"/>

<br />

##### History

Show list of recent trades from order book.

<br />

###### Usage

```bash
history
```

<br />

###### Example

```bash
history
```

<br />

###### Sample Output

<img src="/screenshots/interactive_mode_history.png"/>

<br />

##### Exit

Exit the program.

<br />

###### Usage

```bash
exit                                   
```

<br />

###### Example

```bash
exit
```

<br />

###### Sample Output

<img src="/screenshots/interactive_mode_exit.png"/>

<br />

## License

Stockbroker CLI is licensed under the [GNU GPLv3 License](LICENSE).