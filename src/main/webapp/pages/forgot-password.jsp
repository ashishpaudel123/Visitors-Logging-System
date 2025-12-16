<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Visitor Entry System</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet" />
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        primary: "#0f49bd",
                        "background-light": "#f6f6f8",
                        "background-dark": "#101622",
                    },
                    fontFamily: {
                        display: ["Inter", "sans-serif"],
                    },
                },
            },
        };
    </script>
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
    </style>
</head>
<body class="bg-background-light dark:bg-background-dark min-h-screen flex items-center justify-center p-4">
    <div class="w-full max-w-md bg-white dark:bg-[#192231] rounded-xl shadow-lg p-10">
        <div class="text-center text-5xl mb-6">🔒</div>
        <h2 class="text-2xl font-bold text-gray-900 dark:text-white text-center mb-2">Forgot Password?</h2>
        <p class="text-sm text-gray-600 dark:text-gray-400 text-center mb-6 leading-relaxed">
            Enter your email address below and we'll send you a link to reset your password.
        </p>
        
        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <div class="mb-5 p-4 rounded-lg bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800">
                <p class="text-sm text-red-800 dark:text-red-300"><%= error %></p>
            </div>
        <% } %>
        
        <% String success = (String) request.getAttribute("success"); %>
        <% if (success != null) { %>
            <div class="mb-5 p-4 rounded-lg bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800">
                <p class="text-sm text-green-800 dark:text-green-300"><%= success %></p>
            </div>
        <% } %>
        
        <form method="post" action="<%= request.getContextPath() %>/forgot-password" class="space-y-4">
            <div>
                <label for="email" class="block text-sm font-medium text-gray-900 dark:text-white mb-2">Email Address</label>
                <input 
                    type="email" 
                    id="email" 
                    name="email" 
                    placeholder="Enter your email"
                    required
                    <%= success != null ? "disabled" : "" %>
                    class="w-full px-4 py-3 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent disabled:opacity-50"
                >
            </div>
            
            <% if (success == null) { %>
                <button type="submit" class="w-full py-3 px-4 bg-primary hover:bg-primary/90 text-white font-semibold rounded-lg transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 focus:ring-offset-background-light dark:focus:ring-offset-background-dark">
                    Send Reset Link
                </button>
            <% } %>
        </form>
        
        <div class="text-center mt-6">
            <a href="<%= request.getContextPath() %>/login" class="text-sm text-primary hover:underline">← Back to Login</a>
        </div>
    </div>
    
    <script>
        // Dark mode detection
        if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
            document.documentElement.classList.add('dark');
        }
    </script>
</body>
</html>
