<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
    <title>Pharmacy Inventory Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <style>
        body {
            margin: 0;
            padding: 0;
            background: #e6e6e6;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .login-container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 400px;
            box-sizing: border-box;
            transition: transform 0.3s;
        }

        .login-container:hover {
            transform: translateY(-3px);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
            color: #555;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: #56ab2f;
            outline: none;
        }

        input[type="submit"] {
            width: 100%;
            background-color: #56ab2f;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s, transform 0.2s;
        }

        input[type="submit"]:hover {
            background-color: #3e8e41;
            transform: scale(1.02);
        }
        
        .cognito-btn {
            width: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            transition: transform 0.2s, box-shadow 0.3s;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            margin-top: 15px;
        }
        
        .cognito-btn:hover {
            transform: scale(1.02);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .divider {
            text-align: center;
            margin: 20px 0;
            position: relative;
        }
        
        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #ccc;
        }
        
        .divider span {
            background: white;
            padding: 0 10px;
            position: relative;
            color: #777;
            font-size: 14px;
        }

        .footer-text {
            text-align: center;
            margin-top: 15px;
            font-size: 14px;
            color: #777;
        }

        .error {
            color: red;
            text-align: center;
            margin-bottom: 15px;
            font-weight: bold;
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 25px;
            }
        }
    </style>
</head>
<body>

<div class="login-container">
    <h2>Pharmacy Inventory Login</h2>

    <%
        String errorMessage = (String) request.getAttribute("error-message");
        if (errorMessage != null) {
    %>
    <div class="error"><%= errorMessage %>
    </div>
    <%
        }
    %>

    <form action="LoginServlet" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="txtUsername" placeholder="iamrahultawar" required>

        <label for="password">Password:</label>
        <input type="password" id="password" name="txtPassword" placeholder="Rahulishere" required>

        <input type="submit" value="Login">
    </form>
    
    <div class="divider">
        <span>OR</span>
    </div>
    
    <a href="cognitoLogin" class="cognito-btn">
        <i class="fas fa-shield-alt"></i> Sign in with AWS Cognito
    </a>

    <div class="footer-text">
        &copy; 2025 Pharmacy Inventory System
    </div>
</div>

</body>
</html>
