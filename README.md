# DatabaseSerial

This project is aimed at testing Kafka integration and performing SQL inserts using Rust.

## Setup

To set up the Rust project and run the Kafka SQL tests, follow these steps:

1. Install Rust: Visit the official Rust website at [rust-lang.org](https://www.rust-lang.org/) and follow the instructions to install Rust on your system.

2. Clone the Repository: Clone the project repository from GitHub by running the following command in your terminal or command prompt:

   ````
   git clone https://github.com/burkaslarry/DatabaseSerial.git
   ```

3. Navigate to the Project Directory: Change your working directory to the cloned repository:

   ````
   cd DatabaseSerial
   ```

4. Build the Project: Build the Rust project using Cargo, the Rust package manager, by running the following command:

   ````
   cargo build
   ```

5. Configure Kafka: Set up a Kafka cluster or use an existing Kafka instance for testing. Make sure to note down the necessary configuration details, such as the Kafka broker addresses and topic names.

6. Update Configuration: Open the project's configuration file (`config.toml`) and update the Kafka-related settings with the appropriate values, including the broker addresses and topic names.

7. Run the Tests: Execute the Kafka SQL tests by running the following command:

   ````
   cargo test
   ```

   This command will run the test suite and validate the integration of Kafka and SQL inserts in the Rust project.

8. Analyze the Results: Once the tests complete, review the output to ensure that the Kafka integration and SQL inserts are functioning as expected.

## Contributing

If you would like to contribute to this project, please follow the guidelines outlined in the project's CONTRIBUTING.md file. Contributions, bug reports, and feature requests are welcome.

## License

This project is licensed under the [MIT License](LICENSE). Please refer to the LICENSE file for more details.

## Contact

For any questions or inquiries regarding this project, please contact me via Issues or my social handles:

We appreciate your interest and contributions to this Kafka SQL Rust project. Happy coding!