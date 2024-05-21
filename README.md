# Flutter Gemini REST API Demo

This is a Flutter application demonstrating how to call the Gemini Generative Language Model API.

**Requirements:**

* Flutter SDK: https://docs.flutter.dev/get-started/install(https://flutter.dev/docs/get-started/install)
* A Google Cloud Project with the Generative Language API enabled: https://console.cloud.google.com/

**Instructions:**

1. Clone this repository.
2. Create a Google Cloud project and enable the Generative Language API.
3. Create an API key for your project and replace the `GEMINI_API_KEY` constant in the `_MyHomePageState` class with your actual API key.
4. Run the application using `flutter run`.

**How it Works:**

The application allows you to type a message and send it to the Gemini model. Once sent, it uses the `http` package to make a POST request to the Gemini API endpoint. The request body contains the message you entered.

The response from the API is parsed and the generated text from the first candidate is displayed on the screen.

**Model Files:**

* `Model/contents.dart`: Contains the `Contents` class representing the content to be processed by Gemini.
* `Model/parts.dart`: Contains the `Parts` class representing the parts of the content.
* `Model/request.dart`: Contains the `Request` class representing the request sent to the Gemini API.
* `Model/response.dart`: Contains the `Response` class representing the response received from the Gemini API.

**Further Enhancements:**

* Error handling for API calls.
* Implement a more user-friendly chat interface.
* Integrate UI elements to display additional response information (e.g., confidence score).
