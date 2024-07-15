# Hotel Assistant Chatbot

Welcome to the Hotel Assistant Chatbot project! This repository contains a conversational AI powered by the Rasa framework, integrating Language Model capabilities from OpenAI. The chatbot assists users with various hotel-related queries, leveraging both structured data and natural language understanding.

## Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)
  - [Training the Model](#training-the-model)
  - [Running the Action Server](#running-the-action-server)
  - [Interacting with the Bot](#interacting-with-the-bot)
- [Configuration](#configuration)
- [File Structure](#file-structure)
- [Makefile Commands](#makefile-commands)
- [Contributing](#contributing)
- [License](#license)

## Introduction

The Hotel Assistant Chatbot leverages state-of-the-art Natural Language Processing (NLP) techniques to provide an intelligent conversational interface for hotel-related inquiries. This chatbot is built using the Rasa framework, which combines rule-based dialogue management with machine learning models for natural language understanding (NLU).

### Key Features

- **NLP and Transformers**: Utilizes advanced NLP models and transformer architectures, including BERT and SpaCy, to understand and process user queries with high accuracy.
- **Custom Components**: Includes custom pipeline components, such as a spell-checker, to enhance user input handling and improve the overall chatbot performance.
- **Flexible and Extensible**: Designed to be easily extendable, allowing the integration of additional services and customization to fit specific hotel requirements.

## Installation

1. **Clone the repository:**

   ```sh
   git clone https://github.com/your-username/hotel-assistant-bot.git
   cd hotel-assistant-bot
   ```

2. **Create and activate a virtual environment:**

   ```sh
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Install dependencies:**

   ```sh
   pip install -r requirements.txt
   ```

## Usage

### Training the Model

To train the Rasa model with your current data, run:

```sh
make train
```

This command will train the Rasa model using the domain, data, and configuration files, and save the trained model in the `models` directory.

### Running the Action Server

To start the action server, which handles custom actions, run:

```sh
make run-actions
```

### Interacting with the Bot

You can interact with the bot using Rasa Shell:

```sh
make shell
```

This will start the action server and open the Rasa shell, allowing you to chat with the bot in the terminal.

Alternatively, you can run the bot and interact with it via HTTP API:

```sh
make run
```

## Configuration

- **Domain File:** `configs/domain.yml` contains the intents, entities, slots, responses, and forms used by the bot.
- **Training Data:** `data` directory contains the NLU and Core training data.
- **Config File:** `configs/config.yml` specifies the pipeline and policies for training the model.
- **Endpoints File:** `configs/endpoints.yml` defines the endpoints for the action server and other external services.

## File Structure

```plaintext
hotel-assistant-rasa-bot/
├── app/
│   ├── data/                       # Training data for Rasa
│   │   ├── nlu/                    # NLU training data
│   │   ├── stories/                # Core training data (conversation stories)
│   │   └── rules/                  # Rule-based data for conversation handling
│   ├── configs/                    # Configuration files for Rasa and other services
│   │   ├── config_supervised.yml   # Configuration for supervised learning
│   │   ├── config_custom.yml       # Configuration using custom pipelines
│   │   ├── config_bert.yml         # Configuration using BERT embeddings
│   │   └── config_spacy.yml        # Configuration using SpaCy
│   ├── actions/                    # Custom action server files
│   │   └── actions.py              # Custom action implementation
│   ├── tests/                      # Directory for testing scripts or unit tests
│   │   └── ...                     # Unit tests and testing scripts
│   ├── resources/                  # Additional resources used in the project
│   │   └── ...                     # Any additional resource files
│   ├── domain.yml                  # Domain file defining intents, entities, and actions
│   ├── endpoints.yml               # Endpoints configuration for Rasa and external services
│   ├── components/                 # Custom pipeline components for Rasa
│   │   └── spell_checker.py        # Custom spell-checker component
│   ├── requirements.txt            # Python dependencies
│   └── deb-requirements.txt        # Debian-based system dependencies
├── docker/
│   ├── docker-compose.yml          # Docker Compose configuration for deployment
│   ├── Dockerfile.rasa             # Dockerfile for building the Rasa server image
│   └── Dockerfile.action           # Dockerfile for building the action server image
├── scripts/                        # Shell and batch scripts for automation
│   ├── init.sh                     # Initialization script for setting up directories
│   ├── init.bat                    # Batch file for setting up directories (Windows)
│   ├── start.sh                    # Script to build and start Docker containers
│   ├── start.bat                   # Batch file to build and start Docker containers (Windows)
│   ├── startSql.sh                 # Script to start SQL database access
│   ├── startSql.bat                # Batch file to start SQL database access (Windows)
│   ├── stop.sh                     # Script to stop Docker containers
│   └── stop.bat                    # Batch file to stop Docker containers (Windows)
├── Makefile                        # Makefile for automating tasks and commands
├── LICENSE                         # License information for the project
└── README.md                       # Detailed documentation and instructions

```

## Makefile Commands

Here are some useful commands to manage and run your Hotel Assistant Chatbot:

- **`make init`**: Initialize permissions and folder structure.
- **`make docker-start`**: Start Docker containers.
- **`make docker-stop`**: Stop Docker containers.
- **`make docker-up`**: Bring up Docker containers.
- **`make docker-down`**: Bring down Docker containers.
- **`make docker-rm`**: Remove Docker containers.
- **`make docker-clean`**: Clean Docker resources.
- **`make sql`**: Start SQL database access.
- **`make train`**: Train the full Rasa model.
- **`make train-nlu`**: Train only the NLU model.
- **`make run-actions`**: Start the action server for handling custom actions.
- **`make shell`**: Start the action server and open Rasa shell for interaction.
- **`make run`**: Start the action server and Rasa server with API enabled.
- **`make validate`**: Validate the Rasa configuration and training data.
- **`make help`**: Display help information with available targets.

## Contributing

Contributions are welcome! Please create a new issue or submit a pull request if you have any improvements or bug fixes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
