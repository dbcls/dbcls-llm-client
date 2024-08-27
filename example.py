from dbcls_llm.client import DBCLSLLMClient
from dbcls_llm.config import MODELS

# Initialize the client
client = DBCLSLLMClient(username="*", password="*", model_info=MODELS["gpt-35-turbo"][0])
# Send a query to the LLM server
response = client.query(
    data="Explain about Akt pathway"
)

# Access the response details
print(response.text)  # RESPONSE text
print(response.completion_tokens)  # 345
print(response.prompt_tokens)  # 12
print(response.time_sec)  # 3.624066114425659