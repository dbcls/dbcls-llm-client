import requests
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

class DBCLSLLMClient:
    BASE_URL = "https://llms.japaneast.cloudapp.azure.com/"
    VERSION = "0.0.2"
    def __init__(self, username, password, model_info=None):
        self.username = username
        self.password = password
        self.model_info = model_info or {}

        logging.info("Initialized DBCLSLLMClient with provided model_info.")

    def query(self, data, tenant=None, region=None):
        # Default tenant and region from model_info if not provided
        tenant = tenant or self.model_info.get('tenant')
        region = region or self.model_info.get('region')

        if 'model' not in self.model_info:
            logging.error("Model information is required but not provided.")
            raise ValueError("Model information is required but not provided.")

        # Construct the payload
        payload = {
            "model": self.model_info['model'],
            "data": data
        }

        if tenant:
            payload["tenant"] = tenant
        if region:
            payload["region"] = region

        logging.info("Sending request to %s with payload: %s", self.BASE_URL, payload)

        try:
            # Send the request
            response = requests.post(
                self.BASE_URL + self.model_info['class'],
                auth=(self.username, self.password),
                headers={"Content-type": "application/json"},
                json=payload
            )

            # Raise an exception for HTTP errors
            response.raise_for_status()

            logging.info("Received response: %s", response.text)
            return LLMResponse(response.json())

        except requests.exceptions.HTTPError as http_err:
            logging.error("HTTP error occurred: %s", http_err)
            raise
        except requests.exceptions.RequestException as req_err:
            logging.error("Error occurred during the request: %s", req_err)
            raise
        except Exception as err:
            logging.error("An unexpected error occurred: %s", err)
            raise

class LLMResponse:
    def __init__(self, response_data):
        self.completion_tokens = response_data.get("completion_tokens")
        self.prompt_tokens = response_data.get("prompt_tokens")
        self.text = response_data.get("text")
        self.time_sec = response_data.get("time_sec")

        logging.debug("LLMResponse initialized with data: %s", response_data)
