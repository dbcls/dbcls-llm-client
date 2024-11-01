# Configuration for available models and tenants

MODELS = {
    "gpt-35-turbo": [
        {"class": "gpt", "model": "gpt-35-turbo", "version": "0125", "tenant": "dbcls", "region": "northcentralus"},
        {"class": "gpt", "model": "gpt-35-turbo", "version": "1106", "tenant": "dbcls", "region": "australiaeast"},
        {"class": "gpt", "model": "gpt-35-turbo", "version": "0613", "tenant": "dbcls", "region": "japaneast"},
        {"class": "gpt", "model": "gpt-35-turbo", "version": "0301", "tenant": "dbcls", "region": "southcentralus"}
    ],
    "gpt-4o": [
        {"class": "gpt", "model": "gpt-4o", "version": "2024-05-13", "tenant": "dbcls", "region": "northcentralus"}
    ],
    "gpt-4": [
        {"class": "gpt", "model": "gpt-4", "version": "0125-Preview", "tenant": "dbcls", "region": "northcentralus"},
        {"class": "gpt", "model": "gpt-4", "version": "1106-Preview", "tenant": "dbcls", "region": "australiaeast"},
        {"class": "gpt", "model": "gpt-4-0613", "version": "0613", "tenant": "dbcls", "region": "australiaeast"}
    ],
    "claude3": [
        {"class": "claude3", "model": "opus"},
        {"class": "claude3", "model": "sonnet5"},
        {"class": "claude3", "model": "sonnet"},
        {"class": "claude3", "model": "haiku"}
    ],
    "commandr": [
        {"class": "commandr", "model": "plus"},
        {"class": "commandr", "model": "basic"}
    ],
    "gemini": [
        {"class": "gemini", "model": "1.5-pro"},
        {"class": "gemini", "model": "1.5-flash"},
        {"class": "gemini", "model": "1.0-pro"}
    ],
    "llama": [
        {"class": "llama", "model": "llama3-70b"},
        {"class": "llama", "model": "llama3-8b"},
        {"class": "llama", "model": "llama2-70b"},
        {"class": "llama", "model": "llama2-13b"}
    ],
    "mistral": [
        {"class": "mistral", "model": "mistral-7b"},
        {"class": "mistral", "model": "mixtral-8x7b"},
        {"class": "mistral", "model": "mistral-large"}
    ]
}
