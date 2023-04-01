use std::io;
use std::io::stdin;
use std::num::ParseFloatError;
use snafu::Snafu;
use snafu::prelude::*;

#[derive(Debug, Snafu)]
enum NumberError {
    #[snafu(display("The number is a float, informed: {number}"))]
    NumberIsFloat { number: f64 },

    #[snafu(display("The number must be positive, informed: {number}"))]
    NumberIsNegative { number: f64 },

    #[snafu(display("Failed to parse number, informed: '{input}'"))]
    InvalidInput { input: String, source: ParseFloatError },

    #[snafu(display("Failed to read line from STDIN"))]
    FailedToReadLine { source: io::Error },
}

fn read_line() -> io::Result<String> {
    let mut input = String::new();

    stdin().read_line(&mut input)?;

    let mut input = input.replace("\n", "");

    return Ok(input);
}

fn get_input() -> Result<i64, NumberError> {
    let input = read_line().context(FailedToReadLineSnafu {})?;

    let number = input.parse::<f64>().context(InvalidInputSnafu { input })?;

    ensure!(number.trunc() == number, NumberIsFloatSnafu { number });
    ensure!(number > 0.0, NumberIsNegativeSnafu { number });

    return Ok(number.trunc() as i64);
}

fn main() {
    match get_input() {
        Ok(number) => println!("Number: {}", number),
        Err(err) => println!("Invalid input: {:#}", err),
    };

}
