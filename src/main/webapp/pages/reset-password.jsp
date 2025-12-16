<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - Visitor Entry System</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
    <style>
        .reset-password-container {
            max-width: 450px;
            margin: 80px auto;
            padding: 40px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .reset-password-container h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .instruction-text {
            text-align: center;
            color: #7f8c8d;
            margin-bottom: 30px;
            font-size: 14px;
            line-height: 1.5;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #2c3e50;
            font-weight: 500;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            box-sizing: border-box;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #4CAF50;
        }
        
        .submit-btn {
            width: 100%;
            padding: 12px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .submit-btn:hover {
            background: #45a049;
        }
        
        .back-to-login {
            text-align: center;
            margin-top: 20px;
        }
        
        .back-to-login a {
            color: #4CAF50;
            text-decoration: none;
            font-size: 14px;
        }
        
        .back-to-login a:hover {
            text-decoration: underline;
        }
        
        .alert {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .icon {
            text-align: center;
            font-size: 48px;
            color: #4CAF50;
            margin-bottom: 20px;
        }
        
        .password-requirements {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        
        .password-strength {
            height: 4px;
            background: #ddd;
            border-radius: 2px;
            margin-top: 8px;
            overflow: hidden;
        }
        
        .password-strength-bar {
            height: 100%;
            width: 0%;
            transition: all 0.3s;
        }
        
        .strength-weak { background: #dc3545; width: 33%; }
        .strength-medium { background: #ffc107; width: 66%; }
        .strength-strong { background: #28a745; width: 100%; }
    </style>
</head>
<body>
    <div class="reset-password-container">
        <div class="icon">🔑</div>
        <h2>Reset Your Password</h2>
        <p class="instruction-text">
            Enter your new password below. Make sure it's strong and secure.
        </p>
        
        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <div class="alert alert-error">
                <%= error %>
            </div>
        <% } %>
        
        <% String token = (String) request.getAttribute("token"); %>
        <% if (token != null) { %>
            <form method="post" action="<%= request.getContextPath() %>/reset-password" id="resetForm">
                <input type="hidden" name="token" value="<%= token %>">
                
                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <input 
                        type="password" 
                        id="newPassword" 
                        name="newPassword" 
                        placeholder="Enter new password"
                        required
                        minlength="6"
                    >
                    <div class="password-requirements">
                        Minimum 6 characters
                    </div>
                    <div class="password-strength">
                        <div class="password-strength-bar" id="strengthBar"></div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input 
                        type="password" 
                        id="confirmPassword" 
                        name="confirmPassword" 
                        placeholder="Confirm new password"
                        required
                        minlength="6"
                    >
                    <div id="matchMessage" style="font-size: 12px; margin-top: 5px;"></div>
                </div>
                
                <button type="submit" class="submit-btn">Reset Password</button>
            </form>
        <% } else { %>
            <div class="back-to-login">
                <a href="<%= request.getContextPath() %>/forgot-password">Request New Reset Link</a>
            </div>
        <% } %>
        
        <div class="back-to-login">
            <a href="<%= request.getContextPath() %>/login">← Back to Login</a>
        </div>
    </div>
    
    <script>
        // Password strength checker
        const passwordInput = document.getElementById('newPassword');
        const confirmInput = document.getElementById('confirmPassword');
        const strengthBar = document.getElementById('strengthBar');
        const matchMessage = document.getElementById('matchMessage');
        
        if (passwordInput) {
            passwordInput.addEventListener('input', function() {
                const password = this.value;
                const strength = calculatePasswordStrength(password);
                
                strengthBar.className = 'password-strength-bar';
                if (password.length === 0) {
                    strengthBar.style.width = '0%';
                } else if (strength < 2) {
                    strengthBar.className += ' strength-weak';
                } else if (strength < 4) {
                    strengthBar.className += ' strength-medium';
                } else {
                    strengthBar.className += ' strength-strong';
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
                matchMessage.style.color = '';
            } else if (password === confirm) {
                matchMessage.textContent = '✓ Passwords match';
                matchMessage.style.color = '#28a745';
            } else {
                matchMessage.textContent = '✗ Passwords do not match';
                matchMessage.style.color = '#dc3545';
            }
        }
    </script>
</body>
</html>
