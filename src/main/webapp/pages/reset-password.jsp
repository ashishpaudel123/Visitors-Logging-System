<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - Visitor Entry System</title>
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
        <div class="text-center text-5xl mb-6">🔑</div>
        <h2 class="text-2xl font-bold text-gray-900 dark:text-white text-center mb-2">Reset Your Password</h2>
        <p class="text-sm text-gray-600 dark:text-gray-400 text-center mb-6 leading-relaxed">
            Enter your new password below. Make sure it's strong and secure.
        </p>
        
        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <div class="mb-5 p-4 rounded-lg bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800">
                <p class="text-sm text-red-800 dark:text-red-300"><%= error %></p>
            </div>
        <% } %>
        
        <% String token = (String) request.getAttribute("token"); %>
        <% if (token != null) { %>
            <form method="post" action="<%= request.getContextPath() %>/reset-password" id="resetForm" class="space-y-4">
                <input type="hidden" name="token" value="<%= token %>">
                
                <div>
                    <label for="newPassword" class="block text-sm font-medium text-gray-900 dark:text-white mb-2">New Password</label>
                    <input 
                        type="password" 
                        id="newPassword" 
                        name="newPassword" 
                        placeholder="Enter new password"
                        required
                        minlength="6"
                        class="w-full px-4 py-3 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
                    >
                    <p class="text-xs text-gray-600 dark:text-gray-400 mt-2">Minimum 6 characters</p>
                    <div class="h-1 bg-gray-200 dark:bg-gray-700 rounded-full mt-2 overflow-hidden">
                        <div class="h-full transition-all duration-300" id="strengthBar"></div>
                    </div>
                </div>
                
                <div>
                    <label for="confirmPassword" class="block text-sm font-medium text-gray-900 dark:text-white mb-2">Confirm Password</label>
                    <input 
                        type="password" 
                        id="confirmPassword" 
                        name="confirmPassword" 
                        placeholder="Confirm new password"
                        required
                        minlength="6"
                        class="w-full px-4 py-3 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
                    >
                    <p id="matchMessage" class="text-xs mt-2"></p>
                </div>
                
                <button type="submit" class="w-full py-3 px-4 bg-primary hover:bg-primary/90 text-white font-semibold rounded-lg transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 focus:ring-offset-background-light dark:focus:ring-offset-background-dark mt-2">
                    Reset Password
                </button>
            </form>
        <% } else { %>
            <div class="text-center">
                <a href="<%= request.getContextPath() %>/forgot-password" class="text-sm text-primary hover:underline">Request New Reset Link</a>
            </div>
        <% } %>
        
        <div class="text-center mt-6">
            <a href="<%= request.getContextPath() %>/login" class="text-sm text-primary hover:underline">← Back to Login</a>
        </div>
    </div>
    
    <script>
        // Dark mode detection
        if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
            document.documentElement.classList.add('dark');
        }
        
        // Password strength checker
        const passwordInput = document.getElementById('newPassword');
        const confirmInput = document.getElementById('confirmPassword');
        const strengthBar = document.getElementById('strengthBar');
        const matchMessage = document.getElementById('matchMessage');
        
        if (passwordInput) {
            passwordInput.addEventListener('input', function() {
                const password = this.value;
                const strength = calculatePasswordStrength(password);
                
                if (password.length === 0) {
                    strengthBar.style.width = '0%';
                    strengthBar.className = 'h-full transition-all duration-300';
                } else if (strength < 2) {
                    strengthBar.style.width = '33%';
                    strengthBar.className = 'h-full transition-all duration-300 bg-red-500';
                } else if (strength < 4) {
                    strengthBar.style.width = '66%';
                    strengthBar.className = 'h-full transition-all duration-300 bg-yellow-500';
                } else {
                    strengthBar.style.width = '100%';
                    strengthBar.className = 'h-full transition-all duration-300 bg-green-500';
                }
                
                checkPasswordMatch();
            });
        }
        
        if (confirmInput) {
            confirmInput.addEventListener('input', checkPasswordMatch);
        }
        
        function calculatePasswordStrength(password) {
            let strength = 0;
            if (password.length >= 6) strength++;
            if (password.length >= 10) strength++;
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
            if (/\d/.test(password)) strength++;
            if (/[^a-zA-Z0-9]/.test(password)) strength++;
            return strength;
        }
        
        function checkPasswordMatch() {
            const password = passwordInput.value;
            const confirm = confirmInput.value;
            
            if (confirm.length === 0) {
                matchMessage.textContent = '';
                matchMessage.className = 'text-xs mt-2';
            } else if (password === confirm) {
                matchMessage.textContent = '✓ Passwords match';
                matchMessage.className = 'text-xs mt-2 text-green-600 dark:text-green-400';
            } else {
                matchMessage.textContent = '✗ Passwords do not match';
                matchMessage.className = 'text-xs mt-2 text-red-600 dark:text-red-400';
            }
        }
    </script>
</body>
</html>
