<%@ page import="java.net.*, java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String city = request.getParameter("city");
    String temperature = "", humidity = "", wind = "", condition = "", error = "";

    if (city != null && !city.trim().isEmpty()) {
        try {
            String apiKey = "589245745deafa8055cb72dfd66a8e30";  // ← Replace with your real key
            String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=" + URLEncoder.encode(city, "UTF-8") + "&units=metric&appid=" + apiKey;

            URL url = new URL(apiUrl);
            BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));
            StringBuilder jsonResponse = new StringBuilder();
            String line;

            while ((line = in.readLine()) != null) {
                jsonResponse.append(line);
            }
            in.close();

            String json = jsonResponse.toString();

            // Manual parsing for temp, humidity, wind, condition
            int tempIndex = json.indexOf("\"temp\":");
            int humidityIndex = json.indexOf("\"humidity\":");
            int windIndex = json.indexOf("\"speed\":");
            int conditionIndex = json.indexOf("\"description\":\"");

            if (tempIndex != -1) {
                temperature = json.substring(tempIndex + 7, json.indexOf(",", tempIndex)).trim() + " °C";
            }
            if (humidityIndex != -1) {
                humidity = json.substring(humidityIndex + 10, json.indexOf("}", humidityIndex)).trim() + " %";
            }
            if (windIndex != -1) {
                wind = json.substring(windIndex + 8, json.indexOf(",", windIndex)).trim() + " m/s";
            }
            if (conditionIndex != -1) {
                int end = json.indexOf("\"", conditionIndex + 15);
                condition = json.substring(conditionIndex + 15, end);
            }

        } catch (Exception e) {
            error = "Could not fetch weather. Please check the city name.";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Weather Details</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #667eea, #764ba2);
            color: white;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .card {
            background: rgba(0, 0, 0, 0.3);
            padding: 30px 40px;
            border-radius: 20px;
            text-align: center;
            width: 320px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }
        input[type="text"] {
            padding: 10px;
            border-radius: 8px;
            border: none;
            width: 80%;
            margin-bottom: 10px;
        }
        button {
            padding: 10px 15px;
            border: none;
            border-radius: 8px;
            background-color: #ffcc00;
            cursor: pointer;
            font-weight: bold;
        }
        p {
            margin: 8px 0;
        }
        h2 {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="card">
        <h2>🌤️ WeatherPeek</h2>
        <form method="post">
            <input type="text" name="city" placeholder="Enter your city name" required>
            <br>
            <button type="submit">Check Weather</button>
        </form>

        <%
            if (city != null) {
                if (!error.isEmpty()) {
        %>
            <p style="color: #ff8080;"><%= error %></p>
        <%
                } else {
        %>
            <h3>📍 <%= city %></h3>
            <p>🌡️ Temperature: <strong><%= temperature %></strong></p>
            <p>💧 Humidity: <strong><%= humidity %></strong></p>
            <p>💨 Wind Speed: <strong><%= wind %></strong></p>
            <p>☁️ Condition: <strong><%= condition %></strong></p>
        <%
                }
            }
        %>
    </div>
</body>
</html>
