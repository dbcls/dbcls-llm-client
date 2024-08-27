class LLMResponse:
    def __init__(self, response_json: dict):
        """
        Initialize the LLMResponse with the JSON response from the server.

        :param response_json: JSON response from the server.
        """
        self.completion_tokens = response_json.get("completion_tokens", None)
        self.prompt_tokens = response_json.get("prompt_tokens", None)
        self.text = response_json.get("text", None)
        self.time_sec = response_json.get("time_sec", None)

    def __repr__(self):
        return (f"<LLMResponse completion_tokens={self.completion_tokens}, "
                f"prompt_tokens={self.prompt_tokens}, text={self.text}, "
                f"time_sec={self.time_sec}>")

    def to_dict(self):
        """
        Convert the LLMResponse object to a dictionary.

        :return: A dictionary representation of the response.
        """
        return {
            "completion_tokens": self.completion_tokens,
            "prompt_tokens": self.prompt_tokens,
            "text": self.text,
            "time_sec": self.time_sec
        }
