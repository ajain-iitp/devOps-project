<%@ page import="java.net.*, java.io.*, org.json.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String city = request.getParameter("city");
    String temperature = "";
    String error = "";

    if (city != null && !city.trim().isEmpty()) {
        try {
            String apiKey = "589245745deafa8055cb72dfd66a8e30"; // Replace with your OpenWeatherMap API key
            String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=" + URLEncoder.encode(city, "UTF-8") + "&units=metric&appid=" + apiKey;
            URL url = new URL(apiUrl);
            BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));
            StringBuilder json = new StringBuilder();
            String line;
            while ((line = in.readLine()) != null) json.append(line);
            in.close();

            JSONObject obj = new JSONObject(json.toString());
            JSONObject main = obj.getJSONObject("main");
            temperature = main.get("temp") + " °C";

        } catch (Exception e) {
            error = "Could not fetch temperature. Please check the city name.";
        }
    }
%>

<html>
<head>
    <title>Simple Temperature Tracker</title>
</head>
<body>
    <h2>Check Temperature by City</h2>
    <form method="post">
        <input type="text" name="city" placeholder="Enter city" required>
        <button type="submit">Check</button>
    </form>

    <%
        if (city != null) {
            if (!error.isEmpty()) {
    %>
        <p style="color:red;"><%= error %></p>
    <%
            } else {
    %>
        <p>City: <strong><%= city %></strong></p>
        <p>Temperature: <strong><%= temperature %></strong></p>
    <%
            }
        }
    %>
</body>
</html>
