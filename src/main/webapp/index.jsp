<%@ page import="java.net.*, java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String city = request.getParameter("city");
    String temperature = "";
    String weather = "";
    String humidity = "";
    String windSpeed = "";
    String error = "";
    String condition = "default";  // For setting background color

    if (city != null && !city.trim().isEmpty()) {
        try {
            String apiKey = "your_api_key_here"; 
            String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=" + URLEncoder.encode(city, "UTF-8") + "&units=metric&appid=" + apiKey;

            URL url = new URL(apiUrl);
            BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));
            StringBuilder json = new StringBuilder();
            String line;

            while ((line = in.readLine()) != null) {
                json.append(line);
            }
            in.close();

            String jsonString = json.toString();

            int tempIndex = jsonString.indexOf("\"temp\":");
            int humidIndex = jsonString.indexOf("\"humidity\":");
            int windIndex = jsonString.indexOf("\"speed\":");
            int weatherIndex = jsonString.indexOf("\"main\":\"");

            if (tempIndex != -1 && humidIndex != -1 && windIndex != -1 && weatherIndex != -1) {
                int tempComma = jsonString.indexOf(",", tempIndex);
                temperature = jsonString.substring(tempIndex + 7, tempComma) + " °C";

                int humidComma = jsonString.indexOf(",", humidIndex);
                humidity = jsonString.substring(humidIndex + 11, humidComma) + " %";

                int windComma = jsonString.indexOf(",", windIndex);
                windSpeed = jsonString.substring(windIndex + 8, windComma) + " m/s";

                int weatherEnd = jsonString.indexOf("\"", weatherIndex + 8);
                weather = jsonString.substring(weatherIndex + 8, weatherEnd);

                condition = weather.toLowerCase(); // For CSS class
            } else {
                error = "Could not parse weather data.";
            }

        } catch (Exception e) {
            error = "Could not fetch data. Check city name.";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Weather Tracker</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding-top: 50px;
            transition: background-color 0.5s;
            color: white;
        }
        .default      { background-color: #333; }
        .clear        { background-color: #f7b733; }
        .clouds       { background-color: #708090; }
        .rain         { background-color: #4a90e2; }
        .drizzle      { background-color: #7fb3d5; }
        .thunderstorm { background-color: #34495e; }
        .snow         { background-color: #b0c4de; color: black; }
        .mist         { background-color: #aab7b8; }
        .haze         { background-color: #bdc3c7; }
        .fog          { background-color: #95a5a6; }
        .smoke        { background-color: #6e7f80; }
        .dust         { background-color: #d2b48c; }
        .sand         { background-color: #c2b280; }
        .tornado      { background-color: #2c3e50; }

        input, button {
            padding: 10px;
            font-size: 16px;
        }
        .weather-box {
            margin-top: 20px;
            padding: 20px;
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            display: inline-block;
        }
    </style>
</head>
<body class="<%= condition %>">
    <h1>🌤️ Weather Tracker</h1>
    <form method="post">
        <input type="text" name="city" placeholder="Enter city name" required>
        <button type="submit">Check</button>
    </form>

<%
    if (city != null) {
        if (!error.isEmpty()) {
%>
    <p style="color: yellow;"><%= error %></p>
<%
        } else {
            String emoji = "🌡️";
            if (condition.contains("clear")) emoji = "☀️";
            else if (condition.contains("cloud")) emoji = "☁️";
            else if (condition.contains("rain")) emoji = "🌧️";
            else if (condition.contains("snow")) emoji = "❄️";
            else if (condition.contains("drizzle")) emoji = "🌦️";
            else if (condition.contains("thunder")) emoji = "🌩️";
            else if (condition.contains("mist") || condition.contains("fog") || condition.contains("haze")) emoji = "🌫️";
            else if (condition.contains("tornado")) emoji = "🌪️";
%>
    <div class="weather-box">
        <h2><%= emoji %> Weather in <%= city %></h2>
        <p><strong>Temperature:</strong> <%= temperature %></p>
        <p><strong>Humidity:</strong> <%= humidity %></p>
        <p><strong>Wind Speed:</strong> <%= windSpeed %></p>
        <p><strong>Condition:</strong> <%= weather %></p>
    </div>
<%
        }
    }
%>

</body>
</html>
