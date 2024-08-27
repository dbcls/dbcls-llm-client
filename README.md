# dbcls_llm

`dbcls_llm` is a Python client library for interacting with the DBCLS Large Language Model (LLM) server. This library provides a Pythonic interface for sending requests to the server and handling responses, making it easier to work with LLM models for various NLP tasks.

## Features

- **Pythonic Interface**: Simplifies the process of interacting with the DBCLS LLM server using Python.
- **Logging**: Built-in logging to track requests and responses.
- **Error Handling**: Handles HTTP and request errors gracefully.
- **Flexible Configuration**: Supports dynamic configuration of model details, tenants, and regions.

## Installation

To install `dbcls_llm`, clone the repository and install dependencies:

```bash
git clone https://github.com/your-repo/dbcls_llm.git
cd dbcls_llm
pip install -r requirements.txt
```

## Usage

### Initialization

To use the DBCLSLLMClient, you need to initialize it with your DBCLS LLM server credentials and optionally provide model information.

```python

from dbcls_llm import DBCLSLLMClient

# Initialize the client with your credentials
client = DBCLSLLMClient(username="your_username", password="your_password", model_info={
    "model": "your_model_name",
    "class": "model_class",
    "tenant": "your_tenant",  # Optional
    "region": "your_region"   # Optional
})

# preconfigured models are available in the config module

from dbcls_llm.config import MODELS

client = DBCLSLLMClient(username="your_username", password="your_password", model_info={
    MODELS['gpt-35-turbo'][0]
})

```

### Sending a Query

You can send a query to the DBCLS LLM server using the query method. You must provide the input data, and optionally specify the tenant and region.

```python

# Prepare your input data
data = {"text": "Your input text goes here"}

# Send a query to the server
response = client.query(data)

# Access response data
print("Completion Tokens:", response.completion_tokens)
print("Prompt Tokens:", response.prompt_tokens)
print("Text:", response.text)
print("Time (seconds):", response.time_sec)

```

### Logging

By default, the dbcls_llm library uses Python's logging module to log information about the requests and responses. You can adjust the logging level by configuring the logging settings in your application.
Contributing

Contributions are welcome! Please read our contributing guidelines for more information.
License

This project is licensed under the MIT License - see the LICENSE file for details.
Contact

For any questions or suggestions, please open an issue on the GitHub repository or contact us directly.

